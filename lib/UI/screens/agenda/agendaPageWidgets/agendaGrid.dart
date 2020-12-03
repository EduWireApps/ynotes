import 'package:calendar_time/calendar_time.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ynotes/UI/components/modalBottomSheets/agendaEventDetailsBottomSheet.dart';
import 'package:ynotes/UI/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/UI/screens/agenda/agendaPage.dart';
import 'package:ynotes/UI/screens/agenda/agendaPageWidgets/agenda.dart';
import 'package:ynotes/UI/screens/agenda/agendaPageWidgets/agendaElement.dart';
import 'package:ynotes/UI/screens/agenda/agendaPageWidgets/spaceAgenda.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/notifications.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/usefulMethods.dart';

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
  double _scaleFactor = 1.1;
  double _baseScaleFactor = 1.1;
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
    //_events.removeWhere((element) => element.wholeDay);

    //sort events by date
    _events.sort((a, b) => a.end.compareTo(b.end));

    for (AgendaEvent ev in _events) {
      if (!ev.wholeDay) {
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
      } else {
        print("ok");
      }
    }
  }

  void packEvents(List<List<AgendaEvent>> columns) {
    int numColumns = columns.length;
    int iColumn = 0;
    for (var col in columns) {
      for (var ev in col) {
        int colSpan = expandEvent(ev, iColumn, columns);
        ev.left = (iColumn / columns.length) * 4.5;
        ev.width = ((colSpan) / (columns.length)) * 4.5;
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
    double diff = ((dt.hour * 60 + dt.minute) - (start.hour * 60 + start.minute)) / 60;

    return (MediaQuery.of(context).size.height / 10 * defaultGridHeight * _scaleFactor) * diff;
  }

  //Calculate the start hour
  TimeOfDay _getStartHour(List<AgendaEvent> events) {
    if (events != null && events.length != 0) {
      List<AgendaEvent> lessonsIList = List();
      lessonsIList.addAll(events);

      lessonsIList.removeWhere((element) => element.wholeDay);
      if (widget.afterSchool) {
        lessonsIList.removeWhere((element) => !element.isLesson);
      }
      if (lessonsIList.length == 0) {
        if (widget.afterSchool) {
          return TimeOfDay(hour: minAfterSchoolDayLength[0], minute: 0);
        } else {
          return TimeOfDay(hour: minSchoolDayLength[0], minute: 0);
        }
      } else {
        if (widget.afterSchool) {
          lessonsIList.sort((a, b) => a.end.compareTo(b.end));
          return TimeOfDay(hour: lessonsIList.last.end.hour, minute: 0);
        }
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
  TimeOfDay _getEndHour(List events) {
    if (events != null && events.length != 0) {
      List lessonsIList = List();
      lessonsIList.addAll(events);
      lessonsIList.removeWhere((element) => element.wholeDay);
      if (!this.widget.afterSchool) {
        lessonsIList.removeWhere((element) => element.lesson == null);
      }
      if (lessonsIList.length == 0) {
        if (widget.afterSchool) {
          return TimeOfDay(hour: minAfterSchoolDayLength[1], minute: 0);
        } else {
          return TimeOfDay(hour: minSchoolDayLength[1], minute: 0);
        }
      } else {
        lessonsIList.sort((a, b) => a.end.compareTo(b.end));
        return TimeOfDay(hour: lessonsIList.last.end.hour + 1, minute: 0);
      }
    } else if (widget.afterSchool) {
      return TimeOfDay(hour: minAfterSchoolDayLength[1], minute: 0);
    } else {
      return TimeOfDay(hour: minSchoolDayLength[1], minute: 0);
    }
  }

  Future<int> getRelatedColor(AgendaEvent event) async {
    if (event != null && event.color != null) {
      return event.color;
    } else {
      return await getColor(event.lesson.codeMatiere);
    }
  }

  ///Get actual hour position
  _getBarPosition(TimeOfDay start) {
    final dt = TimeOfDay.fromDateTime(DateTime.now());

    double diff = ((dt.hour * 60 + dt.minute) - (start.hour * 60 + start.minute)) / 60;

    return (MediaQuery.of(context).size.height / 10 * defaultGridHeight * _scaleFactor) * diff;
  }

  Future<void> refreshAgendaFuture() async {
    if (mounted) {
      setState(() {
        spaceAgendaFuture = localApi.getEvents(agendaDate, true);
        agendaFuture = localApi.getEvents(agendaDate, false);
      });
    }
    var realAF = await spaceAgendaFuture;
    var realSAF = await agendaFuture;
  }

  Widget _buildHeaderAllDays() {
    var screenSize = MediaQuery.of(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
          color: widget.afterSchool ? darken(ThemeUtils.spaceColor(), forceAmount:0.01).withOpacity(0.9) : Theme.of(context).primaryColorDark.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          )),
      width: screenSize.size.width / 5 * 4.9,
      height: _events.any((element) => element.wholeDay) ? screenSize.size.height / 10 * 0.7 : 0,
      child: Container(
        child: Container(
          width: screenSize.size.width / 5 * 4.5,
          child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.size.height / 10 * 0.1,
              ),
              itemCount: _events.where((element) => element.wholeDay).length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctxt, index) {
                return Container(
                  margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2),
                  child: FutureBuilder(
                      initialData: 0,
                      future: getRelatedColor(_events.where((element) => element.wholeDay).toList()[index]),
                      builder: (context, snapshot) {
                        return Material(
                          color: Color(snapshot.data),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                          child: InkWell(
                            onLongPress: () async {
                              var _event = _events.where((element) => element.wholeDay).toList()[index];
                              if (_event.isLesson) {
                                //Getting color before
                                _event.color = await getColor(_event.lesson.codeMatiere);
                              }
                              var temp = await agendaEventEdit(context, true, defaultDate: _event.start, customEvent: _event);

                              if (temp != null) {
                                if (temp != "removed") {
                                  if (temp != null) {
                                    if (temp.recurrenceScheme != null && temp.recurrenceScheme != "0") {
                                      await offline.agendaEvents.addAgendaEvent(temp, temp.recurrenceScheme);

                                      setState(() {
                                        _event = temp;
                                      });
                                    } else {
                                      await offline.agendaEvents.addAgendaEvent(temp, await get_week(temp.start));

                                      setState(() {
                                        _event = temp;
                                      });
                                    }
                                    await LocalNotification.scheduleAgendaReminders(temp);
                                  }
                                } else {
                                  await offline.reminders.removeAll(_event.id);
                                  await LocalNotification.cancelNotification(_event.id.hashCode);
                                }
                                await refreshAgendaFuture();
                                widget.setStateCallback();
                              }
                            },
                            onTap: () async {
                              var _event = _events.where((element) => element.wholeDay).toList()[index];

                              if (_event.isLesson) {
                                _event.color = await getColor(_event.lesson.codeMatiere);
                                await lessonDetails(context, _event);
                                await refreshAgendaFuture();
                                print("ok");
                              } else {
                                await lessonDetails(context, _event);
                                await refreshAgendaFuture();
                                widget.setStateCallback();
                              }
                            },
                            borderRadius: BorderRadius.circular(11),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenSize.size.width / 5 * 0.12,
                                vertical: screenSize.size.height / 10 * 0.1,
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    (_events.where((element) => element.wholeDay).toList()[index].name != null && _events.where((element) => element.wholeDay).toList()[index].name != "") ? _events.where((element) => element.wholeDay).toList()[index].name : "(sans nom)",
                                    style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }),
        ),
      ),
    );
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
        height: screenSize.size.height / 10 * 7.2,
        width: screenSize.size.width,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: scontroller,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: screenSize.size.height / 10 * (_events.any((element) => element.wholeDay) ? 0.8 : 0)),
                      child: Column(
                        children: List.generate(((_getEndHour(_events).hour - _getStartHour(_events).hour)) < 0 ? 0 : ((_getEndHour(_events).hour - _getStartHour(_events).hour)), (int index) {
                          if (index != 0) {
                            return GestureDetector(
                              onTapUp: (_) {
                                if (slidableController.activeState != null) {
                                  slidableController.activeState.close();
                                } else {}
                              },
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
                            );
                          } else {
                            return Container(
                              height: screenSize.size.height / 10 * defaultGridHeight * _scaleFactor,
                            );
                          }
                        }),
                      ),
                    ),
                    for (AgendaEvent i in _events)
                      if (!i.wholeDay && _getPosition(_getStartHour(_events), i) != null && (this.widget.afterSchool ? !i.isLesson : true))
                        Positioned(
                          left: screenSize.size.width / 5 * 0.2,
                          top: _getPosition(_getStartHour(_events), i) + screenSize.size.height / 10 * (_events.any((element) => element.wholeDay) ? 0.8 : 0),
                          child: AgendaElement(
                            i,
                            defaultGridHeight * _scaleFactor * i.end.difference(i.start).inMinutes / 60,
                            widget.setStateCallback,
                            width: i.width,
                            position: i.left,
                          ),
                        ),
                    if (_getStartHour(_events) != null && CalendarTime(agendaDate).isToday)
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        top: _getBarPosition(_getStartHour(_events)) + screenSize.size.height / 10 * (_events.any((element) => element.wholeDay) ? 0.8 : 0),
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
            Positioned(
              top: 0,
              child: _buildHeaderAllDays(),
            ),
          ],
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
