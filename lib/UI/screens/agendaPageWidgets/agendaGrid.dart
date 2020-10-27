
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/agendaElement.dart';
import 'package:ynotes/classes.dart';

class AgendaGrid extends StatefulWidget {
  final List<Lesson> lessons;

  const AgendaGrid(this.lessons);
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
    setEvents();
  }

  DateTime lastEventEnding;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;
  var defaultGridHeight = 1.5;
  List<AgendaEvent> events = List();

  void setEvents() {
    events.clear();
    //Add lessons
    for (Lesson lesson in this.widget.lessons) {
      events.add(AgendaEvent(lesson.start, lesson.end, lesson.matiere, lesson.room, null, null, lesson.canceled, lesson.id, null, isLesson: true, lesson: lesson));
    }

    layoutEvents();
  }

  void layoutEvents() {
    var columns = List<List<AgendaEvent>>();
    DateTime lastEventEnding = null;

    //sort events by date
    events.sort((a, b) => a.start.compareTo(b.start));
    for (AgendaEvent ev in events) {
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
        print(colSpan / (columns.length));
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
  _getPosition(DateTime start, AgendaEvent event) {
    final f = new DateFormat.Hm();
    final f2 = new DateFormat.H();

    //print(f.parse(f.format(lesson.start)).difference(f2.parse(f2.format(start))).inMinutes / 60);
    double diff = f.parse(f.format(event.start)).difference(f2.parse(f2.format(start))).inMinutes / 60;

    return (MediaQuery.of(context).size.height / 10 * defaultGridHeight * _scaleFactor) * diff;
  }

  //Calculate the start hour
  DateTime _getStartHour(List lessons) {
    List lessonsIList = List();
    lessonsIList.addAll(lessons);
    lessonsIList.sort((a, b) => a.start.compareTo(b.start));
    return lessonsIList.first.start;
  }

  //Calculate the end hour (end the start hour of the after school grid)
  DateTime _getEndHour(List lessons) {
    List lessonsIList = List();
    lessonsIList.addAll(lessons);
    lessonsIList.sort((a, b) => a.start.compareTo(b.start));
    return lessonsIList.last.end;
  }

  ///Get actual hour position
  _getBarPosition(DateTime start) {
    final f = new DateFormat.Hm();
    final f2 = new DateFormat.H();

    double diff = f.parse(f.format(DateTime.now())).difference(f2.parse(f2.format(start))).inMinutes / 60;
    
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
                  children: List.generate(
                    _getEndHour(this.widget.lessons).hour - _getStartHour(this.widget.lessons).hour + 1,
                    (int index) {
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
                                        (_getStartHour(this.widget.lessons).hour + index).toString() + ":00",
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
                    },
                  ),
                ),
                for (AgendaEvent i in events)
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 250),
                    left: screenSize.size.width / 5 * 0.15,
                    top: _getPosition(_getStartHour(this.widget.lessons), i),
                    child: AgendaElement(
                      i,
                      defaultGridHeight * _scaleFactor * i.end.difference(i.start).inMinutes / 60,
                      width: i.width,
                      position: i.left,
                    ),
                  ),
                Positioned(
                  top: _getBarPosition(_getStartHour(this.widget.lessons)),
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
    setEvents();
    return _buildGridDateTime();
  }
}

class AgendaEvent {
  final DateTime start;
  final DateTime end;
  final String name;
  //Place or room
  final String location;
  double left;
  final double height;
  double width;
  final bool canceled;
  final String id;
  final List<AgendaReminder> reminders;
  final bool isLesson;
  final Lesson lesson;
  final String description;
  final alarmType alarm;

  bool collidesWith(AgendaEvent other) {
    return end.isAfter(other.start) && start.isBefore(other.end);
  }

  AgendaEvent(
    this.start,
    this.end,
    this.name,
    this.location,
    this.left,
    this.height,
    this.canceled,
    this.id,
    this.width, {
    this.isLesson = false,
    this.lesson,
    this.reminders,
    this.description,
    this.alarm,
  });
}
