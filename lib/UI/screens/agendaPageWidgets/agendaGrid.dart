import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_time/calendar_time.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/agendaElement.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/spaceAgenda.dart';
import 'package:ynotes/classes.dart';

class AgendaGrid extends StatefulWidget {
  List<AgendaEvent> events;
  final bool afterSchool;
  Function setStateCallback;
  AgendaGrid(this.events, this.setStateCallback, {this.afterSchool = false});
  @override
  _AgendaGridState createState() => _AgendaGridState();
}

//final actualHourBar = new GlobalKey();

class _AgendaGridState extends State<AgendaGrid> {
  ScrollController scontroller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    layoutEvents();
  }

  DateTime lastEventEnding;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;
  var defaultGridHeight = 1.5;
  List<AgendaEvent> _events = List();
  //The default school day length
  var minSchoolDayLength = [8, 18];
  //The default after school day length
  var minAfterSchoolDayLength = [18, 24];
  void layoutEvents() {
    var columns = List<List<AgendaEvent>>();
    _events.clear();
    _events.addAll(widget.events);
    // _events.removeWhere((element) => element.start.hour < _getStartHour(_events).hour || element.start.hour > _getEndHour(_events).hour);
    _events.removeWhere((element) => element.wholeDay);
    //sort events by date
    _events.sort((a, b) => a.end.compareTo(b.end));

    for (AgendaEvent ev in _events) {
      if (lastEventEnding != null && (ev.start.isAfter(lastEventEnding) || ev.start.isAtSameMomentAs(lastEventEnding))) {
        packEvents(columns);
        columns.clear();
        lastEventEnding = null;
      }
      bool placed = false;
      for (var col in columns) {
        if (!col.last.collidesWith(ev)) {
          col.add(ev);
          placed = true;
          break;
        }
      }
      if (!placed) {
        columns.add([ev]);
      }
      if (lastEventEnding == null || ev.end.isAfter(lastEventEnding)) {
        lastEventEnding = ev.end;
      }
    }
    if (columns.length > 0) {
      packEvents(columns);
    }
  }

  void packEvents(List<List<AgendaEvent>> columns) {
    int numColumns = columns.length;
    int iColumn = 0;
    for (var col in columns) {
      for (var ev in col) {
        int colSpan = expandEvent(ev, iColumn, columns);
        ev.left = (iColumn / columns.length) * 4.3;
        ev.width = ((colSpan) / (columns.length)) * 4.3;
      }
      iColumn++;
    }
  }

  expandEvent(AgendaEvent ev, int iColumn, List<List<AgendaEvent>> columns) {
    int colSpan = 1;
    for (var col in columns.sublist(iColumn + 1)) {
      for (var ev1 in col) {
        if (ev1.collidesWith(ev)) {
          return colSpan;
        }
      }
      colSpan++;
    }
    return colSpan;
  }

//Calculate the top position
  _getPosition(TimeOfDay start, AgendaEvent event) {
    final dt = TimeOfDay(hour: event.start.hour, minute: event.start.minute);

    //print(f.parse(f.format(lesson.start)).difference(f2.parse(f2.format(start))).inMinutes / 60);
    double diff = ((dt.hour * 60 + dt.minute) - (start.hour * 60 + start.minute)) / 60;

    return (MediaQuery.of(context).size.height / 10 * defaultGridHeight * _scaleFactor) * diff;
  }

  //Calculate the start hour
  TimeOfDay _getStartHour(List lessons) {
    if (lessons != null && lessons.length != 0) {
      List lessonsIList = List();
      lessonsIList.addAll(lessons);
      lessonsIList.removeWhere((element) => element.lesson == null);
      print(lessonsIList.length);
      if (lessonsIList.length == 0) {
        if (widget.afterSchool) {
          return TimeOfDay(hour: minAfterSchoolDayLength[0], minute: 0);
        } else {
          return TimeOfDay(hour: minSchoolDayLength[0], minute: 0);
        }
      } else {
        lessonsIList.sort((a, b) => a.start.compareTo(b.start));
        return TimeOfDay(hour: lessonsIList.first.start.hour, minute: 0);
      }
    } else if (widget.afterSchool) {
      return TimeOfDay(hour: minAfterSchoolDayLength[0], minute: 0);
    } else {
      return TimeOfDay(hour: minSchoolDayLength[0], minute: 0);
    }
  }

  //Calculate the end hour (end the start hour of the after school grid)
  TimeOfDay _getEndHour(List lessons) {
    if (lessons != null && lessons.length != 0) {
      List lessonsIList = List();
      lessonsIList.addAll(lessons);

      lessonsIList.removeWhere((element) => element.lesson == null);
      if (lessonsIList.length == 0) {
        if (widget.afterSchool) {
          return TimeOfDay(hour: minAfterSchoolDayLength[1], minute: 0);
        } else {
          return TimeOfDay(hour: minSchoolDayLength[1], minute: 0);
        }
      } else {
        lessonsIList.sort((a, b) => a.start.compareTo(b.start));

        return TimeOfDay(hour: lessonsIList.last.end.hour + 1, minute: 0);
      }
    } else if (widget.afterSchool) {
      return TimeOfDay(hour: minAfterSchoolDayLength[1], minute: 0);
    } else {
      return TimeOfDay(hour: minSchoolDayLength[1], minute: 0);
    }
  }

  ///Get actual hour position
  _getBarPosition(TimeOfDay start) {
    final dt = TimeOfDay.fromDateTime(DateTime.now());

    double diff = ((dt.hour * 60 + dt.minute) - (start.hour * 60 + start.minute)) / 60;

    return (MediaQuery.of(context).size.height / 10 * defaultGridHeight * _scaleFactor) * diff;
  }

  Widget _buildGridDateTime() {
    SlidableController slidableController = SlidableController();
    var screenSize = MediaQuery.of(context);
    return GestureDetector(
      onScaleStart: (details) {
        _baseScaleFactor = _scaleFactor;
      },
      onScaleUpdate: (details) {
        setState(() {
          if (_baseScaleFactor * details.scale > 0.7 && _baseScaleFactor * details.scale < 10) {
            _scaleFactor = _baseScaleFactor * details.scale;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
        height: screenSize.size.height / 10 * 6.5,
        width: screenSize.size.width / 5 * 4.8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scontroller,
            child: Stack(
              children: [
                Column(
                  children: List.generate(_getEndHour(_events).hour - _getStartHour(_events).hour, (int index) {
                    if (index != 0) {
                      return GestureDetector(
                        onTapUp: (_) {
                          if (slidableController.activeState != null) {
                            slidableController.activeState.close();
                          } else {}
                        },
                        child: Slidable(
                          controller: slidableController,
                          actionPane: SlidableScrollActionPane(),
                          actionExtentRatio: 0.12,
                          actions: <Widget>[
                            Transform.translate(
                              offset: Offset(0, -screenSize.size.height / 10 * 0.15),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: screenSize.size.height / 10 * 0.3,
                                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: Theme.of(context).primaryColorDark),
                                      child: AutoSizeText(
                                        ((_getStartHour(_events).hour + index).toString() + ":00"),
                                        style: TextStyle(),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          child: Container(
                            height: screenSize.size.height / 10 * defaultGridHeight * _scaleFactor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                DottedLine(
                                  direction: Axis.horizontal,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashLength: 4.0,
                                  dashColor: Colors.black.withOpacity(0.2),
                                  dashRadius: 0.0,
                                  dashGapLength: 4.0,
                                  dashGapColor: Colors.transparent,
                                  dashGapRadius: 0.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: screenSize.size.height / 10 * defaultGridHeight * _scaleFactor,
                      );
                    }
                  }),
                ),
                for (AgendaEvent i in _events)
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 250),
                    left: screenSize.size.width / 5 * 0.15,
                    top: _getPosition(_getStartHour(_events), i),
                    child: AgendaElement(
                      i,
                      defaultGridHeight * _scaleFactor * i.end.difference(i.start).inMinutes / 60,
                      widget.setStateCallback,
                      width: i.width,
                      position: i.left,
                    ),
                  ),
                if (_getStartHour(_events) != null)
                  Positioned(
                    top: _getBarPosition(_getStartHour(_events)),
                    child: Row(
                      children: [
                        Container(
                          width: screenSize.size.width / 5 * 0.2,
                          height: screenSize.size.width / 5 * 0.2,
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(1000)),
                        ),
                        Container(
                            width: screenSize.size.width / 5 * 4.8,
                            child: Divider(
                              color: Colors.blue,
                              thickness: screenSize.size.height / 10 * 0.018,
                              height: screenSize.size.height / 10 * 0.018,
                            )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    layoutEvents();
    return _buildGridDateTime();
  }
}
