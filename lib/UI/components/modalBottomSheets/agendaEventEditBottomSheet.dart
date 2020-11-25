import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/main.dart';

import '../../../classes.dart';
import '../../../usefulMethods.dart';

///Agenda event editor, has to be called with a `buildContext`, and the boolean `isLesson` is not optionnal to avoid any confusions.
///`customEvent` and `reminder` are optionals (for editing existing events), but can't both be set.
///If this is a reminder `lessonID` can't be null otherwise it will throw an exception.
///It will return, "created", "edited" or "removed"
Future agendaEventEdit(context, isCustomEvent, {AgendaEvent customEvent, AgendaReminder reminder, String lessonID, DateTime defaultDate}) async {
  Color colorGroup;

  MediaQueryData screenSize = MediaQuery.of(context);
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (BuildContext bc) {
        //Assert for avoiding setting a new reminder without it's lesson ID
        assert(!isCustomEvent ? lessonID != null : true, "Setting a reminder require a lessonID");

        //Assert for avoiding setting a new custom event without default date
        assert(isCustomEvent ? defaultDate != null : true, "Setting a custom event require a default date");

        return agendaEventEditLayout(
          isCustomEvent,
          customEvent: customEvent,
          reminder: reminder,
          lessonID: lessonID,
          defaultDate: defaultDate,
        );
      });
}

class agendaEventEditLayout extends StatefulWidget {
  bool isCustomEvent;
  //Reminder stuff
  AgendaReminder reminder;
  String lessonID;
  DateTime defaultDate;
  //Custom event stuff
  AgendaEvent customEvent;

  agendaEventEditLayout(this.isCustomEvent, {this.reminder, this.lessonID, this.customEvent, this.defaultDate});

  @override
  _agendaEventEditLayoutState createState() => _agendaEventEditLayoutState();
}

class _agendaEventEditLayoutState extends State<agendaEventEditLayout> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (start == null && widget.isCustomEvent) {
      print(widget.defaultDate);
      setState(() {
        widget.defaultDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(widget.defaultDate));
        start = widget.defaultDate.add(Duration(hours: 8));
      });
    }
    if (end == null && widget.isCustomEvent) {
      setState(() {
        widget.defaultDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(widget.defaultDate));
        end = widget.defaultDate.add(Duration(hours: 9));
      });
    }
    settingExistingReminder();
    settingExistingCustomEvent();
    if (widget.isCustomEvent && id == null) {
      // Create uuid object
      var uuid = Uuid();
      id = uuid.v1();
    }
  }

//If this bottom sheet is called to edit an existing reminder
  void settingExistingReminder() {
    if (this.widget.reminder != null) {
      title = this.widget.reminder.name;
      titleController.text = title;
      description = this.widget.reminder.description;
      descriptionController.text = description;
      alarm = this.widget.reminder.alarm;
      id = this.widget.reminder.id;
      tagColor = this.widget.reminder.realTagColor;
    }
  }

//If this bottom sheet is called to edit an existing reminder
  void settingExistingCustomEvent() {
    if (this.widget.customEvent != null) {
      title = this.widget.customEvent.name;
      titleController.text = title;
      description = this.widget.customEvent.description;
      descriptionController.text = description;
      alarm = this.widget.customEvent.alarm ?? alarmType.none;
      id = this.widget.customEvent.id;
      print("ID : " + id);
      tagColor = this.widget.customEvent.realColor;
      wholeDay = this.widget.customEvent.wholeDay;
      start = this.widget.customEvent.start;
      end = this.widget.customEvent.end;
      lesson = this.widget.customEvent.lesson;
      location = this.widget.customEvent.location;
      canceled = this.widget.customEvent.canceled;
      recurringScheme = this.widget.customEvent.recurrenceScheme;
    }
  }

  List alarmChoices = ["Aucune alarme", "Au début", "5 minutes avant", "15 minutes avant", "30 minutes avant", "La veille"];
  String title;
  Color tagColor = Colors.orange;
  DateTime start;
  DateTime end;
  alarmType alarm = alarmType.none;
  String description;
  bool wholeDay = true;
  String id;
  bool canceled = false;
  String location;
  Lesson lesson;
  String recurringScheme;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 8.5,
        width: screenSize.size.width / 5 * 4.8,
        padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: screenSize.size.width / 5 * 4.8,
              height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2), height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75, width: screenSize.size.width / 5 * 1, child: Icon(MdiIcons.cancel, color: Colors.orange))),
                  if (this.widget.customEvent != null || this.widget.reminder != null)
                    GestureDetector(
                        onTap: () async {
                          if (this.widget.customEvent != null) {
                            if (this.widget.customEvent.recurrenceScheme != null && this.widget.customEvent.recurrenceScheme != "0") {
                              await offline.removeAgendaEvent(id, await get_week(this.widget.customEvent.start));
                              await offline.removeAgendaEvent(id, this.widget.customEvent.recurrenceScheme);
                            } else {
                              await offline.removeAgendaEvent(id, await get_week(this.widget.customEvent.start));
                            }
                          }
                          if (this.widget.reminder != null) {
                            await offline.removeReminder(id);
                          }
                          Navigator.of(context).pop("removed");
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2),
                            height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75,
                            width: screenSize.size.width / 5 * 1,
                            child: Icon((this.widget.isCustomEvent && this.widget.customEvent.isLesson) ? MdiIcons.restore : MdiIcons.trashCan, color: Colors.deepOrange))),
                  GestureDetector(
                      onTap: () {
                        //Exit with a value
                        if (widget.isCustomEvent && !wholeDay && start.isAtSameMomentAs(end)) {
                          CustomDialogs.showAnyDialog(context, "Le début et la fin ne peuvent pas être au même moment.");
                        } else {
                          if (!widget.isCustomEvent) {
                            AgendaReminder reminder = AgendaReminder(widget.lessonID, titleController.text, alarm, id ?? (widget.lessonID + "1"), description: descriptionController.text, tagColor: tagColor.value);
                            Navigator.of(context).pop(reminder);
                          }
                          if (widget.isCustomEvent) {
                            AgendaEvent event = AgendaEvent(wholeDay ? null : start, wholeDay ? null : end, titleController.text.trim(), location, null, null, canceled, id, null,
                                wholeDay: wholeDay, color: tagColor.value, alarm: alarm, lesson: lesson, isLesson: lesson != null, description: descriptionController.text.trim(), recurrenceScheme: recurringScheme);
                            Navigator.of(context).pop(event);
                          }
                        }
                      },
                      child: Container(margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2), height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75, width: screenSize.size.width / 5 * 1, child: Icon(MdiIcons.check, color: ThemeUtils.textColor()))),
                ],
              ),
            ),
            Container(
              height: (screenSize.size.height / 10 * 8.8) / 10 * 8.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenSize.size.height / 10 * 0.2),
                    Container(
                      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                      child: TextField(
                        controller: titleController,
                        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.width / 5 * 0.35),
                        decoration: new InputDecoration.collapsed(hintText: 'Ajouter un titre', hintStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8))),
                      ),
                    ),
                    Divider(height: screenSize.size.height / 10 * 0.4),
                    GestureDetector(
                      onTap: () async {
                        Color color = await CustomDialogs.showColorPicker(context, tagColor);
                        if (color != null) {
                          setState(() {
                            tagColor = color;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: screenSize.size.width / 5 * 0.3,
                              height: screenSize.size.width / 5 * 0.3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: tagColor,
                              ),
                            ),
                            SizedBox(width: screenSize.size.width / 5 * 0.1),
                            Text(
                              'Choisir une couleur',
                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(height: screenSize.size.height / 10 * 0.4),
                    if (widget.isCustomEvent)
                      Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Annulé',
                                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                                ),
                                value: canceled,
                                onChanged: (nValue) {
                                  setState(() {
                                    canceled = nValue;
                                  });
                                }),
                            SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Toute la journée',
                                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                                ),
                                value: wholeDay,
                                onChanged: (nValue) {
                                  setState(() {
                                    wholeDay = nValue;
                                  });
                                }),
                            if (!wholeDay)
                              Column(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        var tempDate = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(start));
                                        if (tempDate != null) {
                                          setState(() {
                                            start = DateTime(start.year, start.month, start.day, tempDate.hour, tempDate.minute);
                                            if (start.isAfter(end)) {
                                              end = start.add(Duration(minutes: 1));
                                            }
                                          });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: screenSize.size.width / 5 * 0.4,
                                            height: screenSize.size.width / 5 * 0.4,
                                            child: Icon(
                                              MdiIcons.calendar,
                                              size: screenSize.size.width / 5 * 0.4,
                                              color: ThemeUtils.textColor(),
                                            ),
                                          ),
                                          SizedBox(width: screenSize.size.width / 5 * 0.1),
                                          Text(
                                            'Début ${DateFormat.Hm().format(start)}',
                                            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        var tempDate = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(end));
                                        if (tempDate != null) {
                                          setState(() {
                                            end = DateTime(end.year, end.month, end.day, tempDate.hour, tempDate.minute);
                                            if (end.isBefore(start)) {
                                              start = end.subtract(Duration(minutes: 1));
                                            }
                                          });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: screenSize.size.width / 5 * 0.4,
                                            height: screenSize.size.width / 5 * 0.4,
                                            child: Icon(
                                              MdiIcons.calendar,
                                              size: screenSize.size.width / 5 * 0.4,
                                              color: ThemeUtils.textColor(),
                                            ),
                                          ),
                                          SizedBox(width: screenSize.size.width / 5 * 0.1),
                                          Text(
                                            'Fin  ${DateFormat.Hm().format(end)}',
                                            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    if (widget.isCustomEvent) Divider(height: screenSize.size.height / 10 * 0.4),
                    GestureDetector(
                      onTap: () async {
                        var temp = await CustomDialogs.showRecurringEventDialog(context, recurringScheme);
                        if (temp != null) {
                          setState(() {
                            recurringScheme = temp;
                          });

                          print(recurringScheme);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: screenSize.size.width / 5 * 0.4,
                              height: screenSize.size.width / 5 * 0.4,
                              child: Icon(
                                MdiIcons.repeat,
                                size: screenSize.size.width / 5 * 0.4,
                                color: ThemeUtils.textColor(),
                              ),
                            ),
                            SizedBox(width: screenSize.size.width / 5 * 0.1),
                            Text(
                              "Récurrence",
                              style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (widget.isCustomEvent) Divider(height: screenSize.size.height / 10 * 0.4),
                    GestureDetector(
                      onTap: () async {
                        var choice = await CustomDialogs.showMultipleChoicesDialog(context, alarmChoices, [alarm.index], singleChoice: true);
                        if (choice != null && choice.length == 1) {
                          setState(() {
                            alarm = alarmType.values[choice[0]];
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: screenSize.size.width / 5 * 0.4,
                              height: screenSize.size.width / 5 * 0.4,
                              child: Icon(
                                MdiIcons.bell,
                                size: screenSize.size.width / 5 * 0.4,
                                color: ThemeUtils.textColor(),
                              ),
                            ),
                            SizedBox(width: screenSize.size.width / 5 * 0.1),
                            Text(
                              alarmChoices[alarm.index],
                              style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(height: screenSize.size.height / 10 * 0.4),
                    Container(
                      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                      width: screenSize.size.width / 5 * 4.5,
                      height: screenSize.size.height / 10 * 2,
                      child: TextField(
                        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.width / 5 * 0.25),
                        keyboardType: TextInputType.multiline,
                        controller: descriptionController,
                        maxLines: null,
                        decoration: new InputDecoration.collapsed(hintText: 'Description', hintStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8))),
                      ),
                    ),
                    Divider(height: screenSize.size.height / 10 * 0.4),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
