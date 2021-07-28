import 'dart:async';

import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/custom_loader.dart';
import 'package:ynotes/ui/screens/agenda/agenda.dart';

import 'agenda_grid.dart';
import 'buttons.dart';

bool extended = false;

Lesson? getCurrentLesson(List<Lesson>? lessons, {DateTime? now}) {
  List<Lesson> dailyLessons = [];
  Lesson? lesson;
  if (lessons != null) {
    dailyLessons = lessons
        .where((lesson) =>
            DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start!)) ==
            DateTime.parse(DateFormat("yyyy-MM-dd").format(now ?? DateTime.now())))
        .toList();
    if (dailyLessons.length != 0) {
      //Get current lesson
      try {
        lesson = dailyLessons.firstWhere((lesson) =>
            (now ?? DateTime.now()).isBefore(lesson.end!) && (now ?? DateTime.now()).isAfter(lesson.start!));
      } catch (e) {
        CustomLogger.log("AGENDA", "An error occured while getting current lesson");
        CustomLogger.log("AGENDA", "Lessons: $lessons");
        CustomLogger.error(e);
      }

      return lesson;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

getNextLesson(List<Lesson>? lessons) {
  List<Lesson> dailyLessons = [];
  Lesson? lesson;
  if (lessons != null) {
    dailyLessons = lessons
        .where((lesson) =>
            DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start!)) ==
            DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now())))
        .toList();
    if (dailyLessons.length != 0) {
      //Get current lesson
      try {
        dailyLessons.sort((a, b) => a.start!.compareTo(b.start!));
        lesson = dailyLessons.firstWhere((lesson) => DateTime.now().isBefore(lesson.start!));
      } catch (e) {
        CustomLogger.log("AGENDA", "An error occured while getting the current lesson");
        CustomLogger.error(e);
      }

      return lesson;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  List<FileInfo>? listFiles;

  //Force get date
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 7.5,
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
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
                            FutureBuilder<List<AgendaEvent>?>(
                                future: agendaFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data != null && (snapshot.data ?? []).length != 0) {
                                    return RefreshIndicator(
                                        onRefresh: refreshAgendaFuture,
                                        child: AgendaGrid(
                                          snapshot.data,
                                          initState,
                                        ));
                                  }
                                  if (snapshot.data != null && snapshot.data!.length == 0) {
                                    return Center(
                                      child: FittedBox(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.5),
                                              height: screenSize.size.height / 10 * 1.9,
                                              child: Image(
                                                  fit: BoxFit.fitWidth,
                                                  image: AssetImage('assets/images/pageItems/agenda/noEvent.png')),
                                            ),
                                            Text(
                                              "Journée détente ?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Asap",
                                                  color: ThemeUtils.textColor(),
                                                  fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                                              width: 80,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: new BorderRadius.circular(18.0),
                                                      side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                                ),
                                                onPressed: () async {
                                                  //Reload list
                                                  await refreshAgendaFuture(force: true);
                                                },
                                                child: !(snapshot.connectionState == ConnectionState.waiting)
                                                    ? Text("Recharger",
                                                        style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: ThemeUtils.textColor(),
                                                        ))
                                                    : FittedBox(
                                                        child: SpinKitThreeBounce(
                                                            color: Theme.of(context).primaryColorDark,
                                                            size: screenSize.size.height / 10 * 1.8)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: CustomLoader(
                                          500, screenSize.size.height / 10 * 2.4, Theme.of(context).primaryColorDark),
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
          ],
        ));
  }

  getLessons(DateTime? date) async {
    await refreshAgendaFuture(force: false);
  }

  @override
  void initState() {
    super.initState();
    if (agendaDate == null) {
      setState(() {
        agendaDate = CalendarTime().startOfToday;
      });
    }

    getLessons(agendaDate);
  }

  Future<void> refreshAgendaFuture({force = false}) async {
    if (mounted) {
      setState(() {
        agendaFuture = appSys.api!.getEvents(agendaDate!, forceReload: force);
      });
    }
    await agendaFuture;
  }

  _buildAgendaButtons(BuildContext context) {
    return AgendaButtons(
      getLessons: getLessons,
    );
  }
}
