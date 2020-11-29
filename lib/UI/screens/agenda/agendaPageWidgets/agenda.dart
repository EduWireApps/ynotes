import 'dart:async';

import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as ptr;
import 'package:ynotes/UI/components/modalBottomSheets/agendaEventBottomSheet.dart';
import 'package:ynotes/UI/screens/agenda/agendaPage.dart';
import 'package:ynotes/UI/screens/agenda/agendaPageWidgets/agendaGrid.dart';
import 'package:ynotes/UI/screens/agenda/agendaPageWidgets/buttons.dart';
import 'package:ynotes/UI/screens/agenda/agendaPageWidgets/spaceAgenda.dart';
import 'package:ynotes/utils/fileUtils.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

Future agendaFuture;

bool extended = false;

class _AgendaState extends State<Agenda> {
  List<FileInfo> listFiles;
  @override
  void initState() {
    if (agendaDate == null) {
      setState(() {
        agendaDate = CalendarTime().startOfToday;
      });
    }

    getLessons(agendaDate);
  }

  //Force get date
  getLessons(DateTime date) async {
    await refreshAgendaFutures(force: false);
  }

  Future<void> refreshAgendaFutures({bool force = true}) async {
    if (mounted) {
      setState(() {
        spaceAgendaFuture = localApi.getEvents(agendaDate, true, forceReload: force);
        agendaFuture = localApi.getEvents(agendaDate, false, forceReload: false);
      });
    }
    var realSAF = await agendaFuture;
    var realAF = await spaceAgendaFuture;
  }

  _buildFloatingButton(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return FloatingActionButton(
      heroTag: "btn1",
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenSize.size.width / 5 * 0.8,
        height: screenSize.size.width / 5 * 0.8,
        child: Icon(
          Icons.add,
          size: screenSize.size.width / 5 * 0.5,
        ),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff100A30)),
      ),
      onPressed: () async {
        agendaEventBottomSheet(context);
        /*
        AgendaEvent temp = await agendaEventEdit(context, true, defaultDate: agendaDate);
        if (temp != null) {
          print(temp.recurrenceScheme);
          if (temp.recurrenceScheme != null && temp.recurrenceScheme != "0") {
            await offline.addAgendaEvent(temp, temp.recurrenceScheme);
            await refreshAgendaFutures(force: false);
          } else {
            await offline.addAgendaEvent(temp, await get_week(temp.start));
            await refreshAgendaFutures(force: false);
          }
        }
        setState(() {});*/
      },
    );
  }

  _buildActualLesson(BuildContext context, Lesson lesson) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder(
        future: getColor(lesson.codeMatiere),
        initialData: 0,
        builder: (context, snapshot) {
          Color color = Color(snapshot.data);
          return Container(
            width: screenSize.size.width / 5 * 4.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: screenSize.size.width / 5 * 4.5,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.85),
                  ),
                  height: screenSize.size.height / 10 * 2.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenSize.size.width / 5 * 4.4,
                        height: screenSize.size.height / 10 * 1.57,
                        padding: EdgeInsets.all(screenSize.size.height / 10 * 0.05),
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                lesson.matiere,
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w800),
                                maxLines: 4,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                lesson.teachers[0],
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                              ),
                              Text(
                                lesson.room,
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
                        width: screenSize.size.width / 5 * 2.5,
                        height: screenSize.size.height / 10 * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                          color: Color(0xffC4C4C4),
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Text(
                                DateFormat.Hm().format(lesson.start),
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
                              ),
                              Icon(MdiIcons.arrowRight, color: ThemeUtils.textColor()),
                              Text(
                                DateFormat.Hm().format(lesson.end),
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  _buildAgendaButtons(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return AgendaButtons(
      getLessons: getLessons,
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  ptr.RefreshController _refreshController = ptr.RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 8,
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
          color: Theme.of(context).primaryColor,
        ),
        width: screenSize.size.width,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
              child: Container(
                width: screenSize.size.width,
                height: screenSize.size.height,
                child: Container(
                  width: screenSize.size.width,
                  height: screenSize.size.height,
                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        _buildAgendaButtons(context),
                        Container(
                          height: screenSize.size.height / 10 * 8,
                          child: Stack(
                            children: [
                              FutureBuilder(
                                  future: agendaFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && snapshot.data != null && snapshot.data.length != 0) {
                                      return RefreshIndicator(
                                          onRefresh: refreshAgendaFutures,
                                          child: AgendaGrid(
                                            snapshot.data,
                                            initState,
                                          ));
                                    }
                                    if (snapshot.data != null && snapshot.data.length == 0) {
                                      return Center(
                                        child: FittedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.5),
                                                height: screenSize.size.height / 10 * 1.9,
                                                child: Image(fit: BoxFit.fitWidth, image: AssetImage('assets/images/relax.png')),
                                              ),
                                              Text(
                                                "Journée détente ?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                                              ),
                                              FlatButton(
                                                onPressed: () async {
                                                  //Reload list
                                                  await refreshAgendaFutures(force: true);
                                                },
                                                child: snapshot.connectionState != ConnectionState.waiting
                                                    ? Text("Recharger", style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2))
                                                    : FittedBox(child: SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SpinKitFadingFour(
                                        color: Theme.of(context).primaryColorDark,
                                        size: screenSize.size.width / 5 * 1,
                                      );
                                    }
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.1, bottom: screenSize.size.height / 10 * 0.4),
                child: _buildFloatingButton(context),
              ),
            ),
          ],
        ));
  }
}

Lesson getCurrentLesson(List<Lesson> lessons, {DateTime now}) {
  List<Lesson> dailyLessons = List();
  Lesson lesson;
  dailyLessons = lessons.where((lesson) => DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start)) == DateTime.parse(DateFormat("yyyy-MM-dd").format(now ?? DateTime.now()))).toList();
  if (dailyLessons != null && dailyLessons.length != 0) {
    //Get current lesson
    try {
      lesson = dailyLessons.firstWhere((lesson) => (now ?? DateTime.now()).isBefore(lesson.end) && (now ?? DateTime.now()).isAfter(lesson.start));
    } catch (e) {
      print(lessons);
    }

    return lesson;
  } else {
    return null;
  }
}

getNextLesson(List<Lesson> lessons) {
  List<Lesson> dailyLessons = List();
  Lesson lesson;
  dailyLessons = lessons.where((lesson) => DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start)) == DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()))).toList();
  if (dailyLessons != null && dailyLessons.length != 0) {
    //Get current lesson
    try {
      dailyLessons.sort((a, b) => a.start.compareTo(b.start));
      lesson = dailyLessons.firstWhere((lesson) => DateTime.now().isBefore(lesson.start));
    } catch (e) {
      print(e.toString());
    }

    return lesson;
  } else {
    return null;
  }
}
