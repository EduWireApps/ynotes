import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ynotes/UI/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/UI/components/modalBottomSheets/utils.dart';
import 'package:ynotes/UI/screens/spacePageWidgets/agendaGrid.dart';
import 'package:ynotes/UI/utils/themeUtils.dart';
import '../../../classes.dart';
import '../../../usefulMethods.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ynotes/main.dart';

import '../gradesChart.dart';

void lessonDetails(context, Lesson lesson, Color color) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (BuildContext bc) {
        return LessonDetailsDialog(lesson, color);
      });
}

class LessonDetailsDialog extends StatefulWidget {
  Lesson lesson;
  Color color;
  LessonDetailsDialog(this.lesson, this.color);

  @override
  _LessonDetailsDialogState createState() => _LessonDetailsDialogState();
}

class _LessonDetailsDialogState extends State<LessonDetailsDialog> {
  List<AgendaReminder> reminders = List<AgendaReminder>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssociatedReminders();
  }

  void getAssociatedReminders() async {
    List<AgendaReminder> remindersOnline = await offline.reminders(widget.lesson.id);
    setState(() {
      if (remindersOnline != null) {
        reminders = remindersOnline;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 5.0,
        padding: EdgeInsets.all(0),
        child: new Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenSize.size.width * 0.8),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.05),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: widget.color),
                      padding: EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text(
                          widget.lesson.matiere ?? "",
                          style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            Card(
              color: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
              child: Container(
                width: screenSize.size.width / 5 * 4.5,
                child: Column(
                  children: [
                    Container(padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1), child: Text("Infos de l'évènement", style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black))),
                    Container(
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      height: screenSize.size.height / 10 * 2,
                      margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 0.2)),
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildKeyValuesInfo(context, "Horaires", ["${DateFormat.Hm().format(widget.lesson.start)} - ${DateFormat.Hm().format(widget.lesson.end)}"]),
                            if (widget.lesson.room != null)
                              SizedBox(
                                height: (screenSize.size.height / 3) / 25,
                              ),
                            if (widget.lesson.room != null) buildKeyValuesInfo(context, "Salle", [widget.lesson.room]),
                            if (widget.lesson.teachers != null)
                              SizedBox(
                                height: (screenSize.size.height / 3) / 25,
                              ),
                            if (widget.lesson.teachers != null) buildKeyValuesInfo(context, "Professeur${widget.lesson.teachers.length > 1 ? "s" : ""}", widget.lesson.teachers),
                            if (widget.lesson.groups != null)
                              SizedBox(
                                height: (screenSize.size.height / 3) / 25,
                              ),
                            if (widget.lesson.groups != null) buildKeyValuesInfo(context, "Groupes", widget.lesson.groups),
                            SizedBox(
                              height: (screenSize.size.height / 3) / 25,
                            ),
                            buildKeyValuesInfo(context, "Statut", [widget.lesson.status ?? "Maintenu"]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            Container(
              height: screenSize.size.height / 10 * 0.7,
              child: ListView.builder(
                  padding: EdgeInsets.only(left: screenSize.size.width / 5 * 0.25),
                  scrollDirection: Axis.horizontal,
                  itemCount: reminders.length + 1,
                  itemBuilder: (BuildContext context, index) {
                    if (index == reminders.length) {
                      return GestureDetector(
                        onTap: () async {
                          AgendaReminder reminder = await agendaEventEdit(context, false, lessonID: widget.lesson.id);
                          if (reminder != null) {
                            setState(() {
                              reminders.add(reminder);
                            });
                            offline.updateReminder(reminder);
                          }
                        },
                        child: Card(
                            margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.05),
                            color: Theme.of(context).primaryColorDark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                            child: Container(
                              width: screenSize.size.width / 5 * 3,
                              height: screenSize.size.height / 10 * 0.8,
                              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2, vertical: screenSize.size.height / 10 * 0.1),
                              child: FittedBox(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    //Plus button

                                    Container(
                                      width: screenSize.size.width / 5 * 0.4,
                                      height: screenSize.size.width / 5 * 0.4,
                                      child: RawMaterialButton(
                                        onPressed: () async {
                                          AgendaReminder reminder = await agendaEventEdit(context, false, lessonID: widget.lesson.id);
                                          if (reminder != null) {
                                            setState(() {
                                              reminders.add(reminder);
                                            });
                                          }
                                        },
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: screenSize.size.width / 5 * 0.3,
                                                height: screenSize.size.width / 5 * 0.3,
                                                padding: EdgeInsets.all(
                                                  screenSize.size.width / 5 * 0.05,
                                                ),
                                                child: FittedBox(
                                                  child: new Icon(
                                                    Icons.add,
                                                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        shape: new CircleBorder(),
                                        elevation: 1.0,
                                        fillColor: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: screenSize.size.width / 5 * 0.1),
                                    Container(
                                      height: screenSize.size.height / 10 * 0.2,
                                      child: FittedBox(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Ajouter un rappel",
                                              style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, textBaseline: TextBaseline.ideographic),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          AgendaReminder reminder = await agendaEventEdit(context, false, reminder: reminders[index], lessonID: widget.lesson.id);
                          if (reminder != null) {
                            setState(() {
                              reminders[index] = reminder;
                            });
                            offline.updateReminder(reminder);
                          }
                        },
                        child: Card(
                            margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.05),
                            color: reminders[index].realTagColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                            child: Container(
                              width: screenSize.size.width / 5 * 4.5,
                              height: screenSize.size.height / 10 * 0.8,
                              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2, vertical: screenSize.size.height / 10 * 0.1),
                              child: FittedBox(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    //Plus button
                                if(reminders[index].alarm!=alarmType.none)
                                    Container(
                                      width: screenSize.size.width / 5 * 0.4,
                                      height: screenSize.size.width / 5 * 0.4,
                                      child: RawMaterialButton(
                                        onPressed: () async {
                                          AgendaReminder reminder = await agendaEventEdit(context, false, reminder: reminders[index], lessonID: widget.lesson.id);
                                          if (reminder != null) {
                                            setState(() {
                                              reminders[index] = reminder;
                                            });
                                            offline.updateReminder(reminder);
                                          }
                                        },
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: screenSize.size.width / 5 * 0.3,
                                                height: screenSize.size.width / 5 * 0.3,
                                                padding: EdgeInsets.all(
                                                  screenSize.size.width / 5 * 0.05,
                                                ),
                                                child: FittedBox(
                                                  child: new Icon(
                                                    MdiIcons.bellRing,
                                                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        shape: new CircleBorder(),
                                        elevation: 1.0,
                                        fillColor: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: screenSize.size.width / 5 * 0.1),
                                    if (reminders[index].name != null && reminders[index].name.length > 0)
                                      Container(
                                        height: screenSize.size.height / 10 * 0.4,
                                        child: FittedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                reminders[index].name,
                                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, textBaseline: TextBaseline.ideographic),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            )),
                      );
                    }
                  }),
            )
          ],
        ));
  }
}
