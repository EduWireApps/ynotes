import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:flutter/src/scheduler/binding.dart';
import 'package:ynotes/UI/components/modalsBottomSheets.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import '../../../background.dart';
import '../../../usefulMethods.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/apiManager.dart';
import 'dart:async';
import 'package:ynotes/UI/components/expandable_bottom_sheet-master/src/raw_expandable_bottom_sheet.dart';
import 'dart:io';

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

enum explorerSortValue { date, reversed_date, name }
Future agendaFuture;

class _AgendaState extends State<Agenda> {
  DateTime date = DateTime.now();
  @override
  List<FileInfo> listFiles;
  // ignore: must_call_super
  void initState() {
    // TODO: implement initState
    getLessons(date);
  }

  //Force get date
  getLessons(DateTime date) async {
    await refreshAgendaFuture(force: false);
  }

  Future<void> refreshAgendaFuture({bool force = true}) async {
    if (mounted) {
      setState(() {
        agendaFuture = localApi.getNextLessons(date, forceReload: force);
      });
    }

    var realLF = await agendaFuture;
  }

  _buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      child: Container(
        width: 60,
        height: 60,
        child: Icon(
          Icons.add,
          size: 40,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
              colors: [const Color(0xFFFFFFEE), const Color(0xFFB4ACDC)],
            )),
      ),
      onPressed: () async {
        //agendaEventBottomSheet(context);
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
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                              Icon(MdiIcons.arrowRight, color: isDarkModeEnabled ? Colors.white : Colors.black),
                              Text(
                                DateFormat.Hm().format(lesson.end),
                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
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

    return Container(
      width: screenSize.size.width / 5 * 4.2,
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.005, horizontal: screenSize.size.width / 5 * 0.05),
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15)),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
              child: Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                  onTap: () {
                    setState(() {
                      date = date.subtract(Duration(days: 1));
                    });
                    getLessons(date);
                  },
                  child: Container(
                      height: screenSize.size.height / 10 * 0.45,
                      width: screenSize.size.width / 5 * 1,
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              MdiIcons.arrowLeft,
                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: (screenSize.size.height / 10 * 8.8) / 10 * 0.05),
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
              child: Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                  onTap: () async {
                    DateTime someDate = await showDatePicker(
                      locale: Locale('fr', 'FR'),
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                      helpText: "",
                      builder: (BuildContext context, Widget child) {
                        return FittedBox(
                          child: Material(
                            color: Colors.transparent,
                            child: Theme(
                              data: isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[SizedBox(child: child)],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    if (someDate != null) {
                      setState(() {
                        date = someDate;
                      });
                      getLessons(date);
                    }
                  },
                  child: Container(
                      height: screenSize.size.height / 10 * 0.45,
                      width: screenSize.size.width / 5 * 2,
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              DateFormat("EEEE dd MMMM", "fr_FR").format(date),
                              style: TextStyle(
                                fontFamily: "Asap",
                                color: isDarkModeEnabled ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: (screenSize.size.height / 10 * 8.8) / 10 * 0.05),
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
              child: Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                  onTap: () {
                    setState(() {
                      date = date.add(Duration(days: 1));
                    });
                    getLessons(date);
                  },
                  child: Container(
                      height: screenSize.size.height / 10 * 0.45,
                      width: screenSize.size.width / 5 * 1,
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              MdiIcons.arrowRight,
                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAgendaElement(BuildContext context, Lesson lesson) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return AgendaElement(lesson);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 6.5,
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
          color: Theme.of(context).primaryColor,
        ),
        width: screenSize.size.width / 5 * 4.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
          child: Container(
            width: screenSize.size.width,
            height: screenSize.size.height,
            child: ExpandableBottomSheet(
              background: Container(
                width: screenSize.size.width,
                height: screenSize.size.height,
                padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      _buildAgendaButtons(context),
                      Container(
                        height: screenSize.size.height / 10 * 5.8,
                        padding: EdgeInsets.all(screenSize.size.height / 10 * 0.1),
                        child: Stack(
                          children: [
                            FutureBuilder(
                                future: agendaFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data != null && snapshot.data.length != 0) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                      child: RefreshIndicator(
                                        onRefresh: refreshAgendaFuture,
                                        child: ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return _buildAgendaElement(context, snapshot.data[index]);
                                            }),
                                      ),
                                    );
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
                                              style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                //Reload list
                                                getLessons(date);
                                              },
                                              child: snapshot.connectionState != ConnectionState.waiting
                                                  ? Text("Recharger", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2))
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
              persistentHeader: Container(
                child: FutureBuilder(
                    future: agendaFuture,
                    builder: (context, pheaderData) {
                      if (pheaderData.hasData && getCurrentLesson(pheaderData.data) != null && !getCurrentLesson(pheaderData.data).canceled) {
                        return FutureBuilder(
                            future: getColor(getCurrentLesson(pheaderData.data).codeMatiere),
                            initialData: 0,
                            builder: (context, snapshot) {
                              Color color = Color(snapshot.data);
                              return Container(
                                height: screenSize.size.height / 10 * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
                                  color: color.withOpacity(0.85),
                                ),
                                child: Center(
                                    child: Container(
                                  width: screenSize.size.width / 5 * 3,
                                  height: screenSize.size.height / 10 * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.shade700,
                                  ),
                                )),
                              );
                            });
                      } else {
                        return Container(
                          height: screenSize.size.height / 10 * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
                            color: Colors.grey.withOpacity(0.85),
                          ),
                        );
                      }
                    }),
              ),
              expandableContent: Container(
                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0),
                child: FutureBuilder(
                    future: agendaFuture,
                    builder: (context, econtentdata) {
                      if (econtentdata.hasData && getCurrentLesson(econtentdata.data) != null && !getCurrentLesson(econtentdata.data).canceled) {
                        return Align(
                          alignment: Alignment.center,
                          child: _buildActualLesson(context, getCurrentLesson(econtentdata.data)),
                        );
                      } else {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                    }),
              ),
            ),
          ),
        ));
  }
}

class AgendaElement extends StatefulWidget {
  final Lesson lesson;

  const AgendaElement(this.lesson);

  @override
  _AgendaElementState createState() => _AgendaElementState();
}

class _AgendaElementState extends State<AgendaElement> {
  bool buttons = false;
  bool isAlarmSet = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder(
        future: getColor(widget.lesson.codeMatiere),
        initialData: 0,
        builder: (context, snapshot) {
          Color color = Color(snapshot.data);
          return Container(
            margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
            child: Material(
              color: color,
              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
              child: InkWell(
                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                onLongPress: () {
                  setState(() {
                    buttons = !buttons;
                  });
                },
                onTap: () {
                  lessonDetails(context, widget.lesson, color);
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: buttons
                      ? Container(
                          width: screenSize.size.width / 5 * 4.2,
                          height: screenSize.size.height / 10 * 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Pin button
                              FutureBuilder(
                                  future: getSetting(widget.lesson.start.hashCode.toString()),
                                  initialData: false,
                                  builder: (context, snapshot) {
                                    return RaisedButton(
                                      color: Color(0xff3b3b3b),
                                      onPressed: () async {
                                        if (snapshot.data == false) {
                                          try {
                                            await setSetting(widget.lesson.start.hashCode.toString(), true);
                                            setState(() {});
                                            await LocalNotification.scheduleNotification(widget.lesson);
                                            //Get the delay between lesson and reminder
                                            int minutes = await getIntSetting("lessonReminderDelay");
                                            CustomDialogs.showAnyDialog(context, "yNotes vous rappelera ce cours $minutes minutes avant son commencement.");
                                            print("Registered " + widget.lesson.start.hashCode.toString());
                                          } catch (e) {
                                            print("Error while scheduling " + e.toString());
                                          }
                                        } else {
                                          print("Canceled " + widget.lesson.start.hashCode.toString());
                                          await setSetting(widget.lesson.start.hashCode.toString(), false);
                                          setState(() {});
                                          await LocalNotification.cancelNotification(widget.lesson.start.hashCode);
                                        }
                                      },
                                      shape: CircleBorder(),
                                      child: Container(
                                          width: screenSize.size.width / 5 * 0.7,
                                          height: screenSize.size.width / 5 * 0.7,
                                          padding: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.05),
                                          child: Icon(
                                            MdiIcons.alarm,
                                            color: snapshot.data ? Colors.green : Colors.white,
                                            size: screenSize.size.width / 5 * 0.5,
                                          )),
                                    );
                                  }),
                            ],
                          ),
                        )
                      : Container(
                          key: ValueKey<bool>(buttons),
                          decoration: BoxDecoration(border: Border.all(width: 5, color: widget.lesson.canceled ? Colors.red.shade600 : Colors.transparent), borderRadius: BorderRadius.circular(11)),
                          width: screenSize.size.width / 5 * 4.2,
                          height: screenSize.size.height / 10 * 1.2,
                          child: Stack(children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  Transform.translate(
                                    offset: Offset(0, -screenSize.size.height / 10 * 0.03),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      width: screenSize.size.width / 5 * 1.1,
                                      height: screenSize.size.height / 10 * 0.4,
                                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                      child: FittedBox(
                                        child: Row(
                                          children: [
                                            Text(
                                              DateFormat.Hm().format(widget.lesson.start),
                                              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                            ),
                                            Icon(MdiIcons.arrowRight, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                            Text(
                                              DateFormat.Hm().format(widget.lesson.end),
                                              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1, top: screenSize.size.height / 10 * 0.2),
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenSize.size.width / 5 * 1.2,
                                      height: screenSize.size.height / 10 * 0.8,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            widget.lesson.matiere,
                                            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: 15),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (widget.lesson.teachers != null && widget.lesson.teachers.length > 0 && widget.lesson.teachers[0] != "")
                                            FittedBox(
                                              child: AutoSizeText(
                                                widget.lesson.teachers[0],
                                                style: TextStyle(fontFamily: "Asap", fontSize: 15),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (widget.lesson.canceled)
                                      Container(
                                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                        width: screenSize.size.width / 5 * 1.5,
                                        height: screenSize.size.height / 10 * 0.5,
                                        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black, width: 2)),
                                        child: Center(
                                          child: AutoSizeText(
                                            widget.lesson.status,
                                            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: 32),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: screenSize.size.width / 5 * 1.2,
                                    height: screenSize.size.height / 10 * 0.8,
                                    padding: EdgeInsets.all(screenSize.size.width / 5 * 0.08),
                                    child: AutoSizeText(
                                      widget.lesson.room ?? "",
                                      style: TextStyle(fontSize: 30, fontFamily: "Asap", fontWeight: FontWeight.bold),
                                      minFontSize: 10,
                                      stepGranularity: 5,
                                      maxLines: 4,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ])),
                ),
              ),
            ),
          );
        });
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
