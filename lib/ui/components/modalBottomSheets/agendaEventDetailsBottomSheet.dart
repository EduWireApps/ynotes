import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/ui/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/ui/components/modalBottomSheets/keyValues.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/globals.dart';

Future<void> lessonDetails(context, AgendaEvent event) async {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (BuildContext bc) {
        return LessonDetailsDialog(event);
      });
}

class LessonDetailsDialog extends StatefulWidget {
  AgendaEvent event;
  LessonDetailsDialog(this.event);

  @override
  _LessonDetailsDialogState createState() => _LessonDetailsDialogState();
}

class _LessonDetailsDialogState extends State<LessonDetailsDialog> {
  List<AgendaReminder> reminders = [];
  @override
  void initState() {
    super.initState();
    getAssociatedReminders();
  }

  void getAssociatedReminders() async {
    List<AgendaReminder>? remindersOnline = await appSys.offline.reminders.getReminders(widget.event.id);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.event.name != null)
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.05),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)), color: widget.event.realColor),
                      padding: EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text(
                          widget.event.name != "" && widget.event.name != null ? widget.event.name! : "(sans nom)",
                          style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
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
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                        child: Container(
                          width: screenSize.size.height / 10 * 0.5,
                          height: screenSize.size.height / 10 * 0.5,
                          child: RawMaterialButton(
                            onPressed: () async {
                              var temp = await agendaEventEdit(context, true,
                                  defaultDate: this.widget.event.start, customEvent: this.widget.event);
                              if (temp != null) {
                                if (temp.runtimeType.toString().contains("String")) {
                                  if (temp == "removed") {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  await appSys.offline.agendaEvents.addAgendaEvent(temp, await getWeek(temp.start));
                                  await AppNotification.scheduleAgendaReminders(temp);
                                }
                                setState(() {
                                  this.widget.event = temp;
                                });
                              }
                            },
                            child: new Icon(
                              Icons.edit,
                              color: ThemeUtils.textColor(),
                              size: screenSize.size.height / 10 * 0.4,
                            ),
                            shape: new CircleBorder(),
                            elevation: 1.0,
                            fillColor: ThemeUtils.textColor(revert: true),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                            child: Text("Infos de l'évènement",
                                style: TextStyle(
                                    fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()))),
                        Container(
                          padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 0.2)),
                          child: FittedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                buildKeyValuesInfo(context, "Horaires", [
                                  "${DateFormat.Hm().format(widget.event.start!)} - ${DateFormat.Hm().format(widget.event.end!)}"
                                ]),
                                if (widget.event.location != null)
                                  SizedBox(
                                    height: (screenSize.size.height / 3) / 25,
                                  ),
                                if (widget.event.location != null)
                                  buildKeyValuesInfo(context, widget.event.lesson != null ? "Salle" : "Emplacement",
                                      [widget.event.location]),
                                if (widget.event.lesson != null && widget.event.lesson!.teachers != null)
                                  SizedBox(
                                    height: (screenSize.size.height / 3) / 25,
                                  ),
                                if (widget.event.lesson != null && widget.event.lesson!.teachers != null)
                                  buildKeyValuesInfo(
                                      context,
                                      "Professeur${widget.event.lesson!.teachers!.length > 1 ? "s" : ""}",
                                      widget.event.lesson!.teachers),
                                if (widget.event.lesson != null && widget.event.lesson!.groups != null)
                                  SizedBox(
                                    height: (screenSize.size.height / 3) / 25,
                                  ),
                                if (widget.event.lesson != null && widget.event.lesson!.groups != null)
                                  buildKeyValuesInfo(context, "Groupes", widget.event.lesson!.groups),
                                SizedBox(
                                  height: (screenSize.size.height / 3) / 25,
                                ),
                                if (widget.event.canceled! ||
                                    (widget.event.lesson != null && widget.event.lesson!.status != null))
                                  buildKeyValuesInfo(context, "Statut",
                                      [widget.event.canceled! ? "Annulé" : widget.event.lesson!.status]),
                                if (widget.event.description != null && widget.event.description != "")
                                  buildKeyValuesInfo(context, "Description", [widget.event.description]),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                          AgendaReminder? reminder = await (agendaEventEdit(context, false, lessonID: widget.event.id)
                              as Future<AgendaReminder?>);
                          if (reminder != null) {
                            setState(() {
                              reminders.add(reminder);
                            });
                            appSys.offline.reminders.updateReminders(reminder);
                            await AppNotification.scheduleReminders(widget.event);
                          }
                        },
                        child: Card(
                            margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.05),
                            color: Theme.of(context).primaryColorDark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                            child: Container(
                              width: screenSize.size.width / 5 * 3,
                              height: screenSize.size.height / 10 * 0.8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.size.width / 5 * 0.2,
                                  vertical: screenSize.size.height / 10 * 0.1),
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
                                          AgendaReminder? reminder =
                                              await (agendaEventEdit(context, false, lessonID: widget.event.id)
                                                  as Future<AgendaReminder?>);
                                          if (reminder != null) {
                                            setState(() {
                                              reminders.add(reminder);
                                            });
                                            appSys.offline.reminders.updateReminders(reminder);
                                            await AppNotification.scheduleReminders(widget.event);
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
                                                    color: ThemeUtils.textColor(),
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
                                              style: TextStyle(
                                                  fontFamily: "Asap",
                                                  color: ThemeUtils.textColor(),
                                                  textBaseline: TextBaseline.ideographic),
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
                          var reminder = await agendaEventEdit(context, false,
                              lessonID: widget.event.id, reminder: reminders[index]);

                          if (reminder != null) {
                            if (reminder.runtimeType.toString().contains("String")) {
                              if (reminder == "removed") {
                                await AppNotification.cancelNotification(reminders[index].id.hashCode);
                                setState(() {
                                  reminders.removeAt(index);
                                });
                              }
                            } else {
                              setState(() {
                                reminders.add(reminder);
                              });
                              appSys.offline.reminders.updateReminders(reminder);
                              await AppNotification.scheduleReminders(widget.event);
                            }
                          }
                        },
                        child: Card(
                            margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.05),
                            color: reminders[index].realTagColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                            child: Container(
                              width: screenSize.size.width / 5 * 4.5,
                              height: screenSize.size.height / 10 * 0.8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.size.width / 5 * 0.2,
                                  vertical: screenSize.size.height / 10 * 0.1),
                              child: FittedBox(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    //Plus button
                                    if (reminders[index].alarm != alarmType.none)
                                      Container(
                                        width: screenSize.size.width / 5 * 0.4,
                                        height: screenSize.size.width / 5 * 0.4,
                                        child: RawMaterialButton(
                                          onPressed: () async {
                                            var reminder = await agendaEventEdit(context, false,
                                                lessonID: widget.event.id, reminder: reminders[index]);

                                            if (reminder != null) {
                                              if (reminder.runtimeType.toString().contains("String")) {
                                                if (reminder == "removed") {
                                                  await AppNotification.cancelNotification(
                                                      reminders[index].id.hashCode);
                                                  setState(() {
                                                    reminders.removeAt(index);
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  reminders.add(reminder);
                                                });
                                                appSys.offline.reminders.updateReminders(reminder);
                                                await AppNotification.scheduleReminders(widget.event);
                                              }
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
                                                      color: ThemeUtils.textColor(),
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
                                    if (reminders[index].name != null && reminders[index].name!.length > 0)
                                      Container(
                                        height: screenSize.size.height / 10 * 0.4,
                                        child: FittedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                reminders[index].name!,
                                                style: TextStyle(
                                                    fontFamily: "Asap",
                                                    color: ThemeUtils.textColor(),
                                                    textBaseline: TextBaseline.ideographic),
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
