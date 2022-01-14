import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/data/agenda/reminders.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/legacy/theme_utils.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/key_values.dart';
import 'agenda_event_edit_bottom_sheet.dart';

Future<void> lessonDetails(context, AgendaEvent event) async {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return LessonDetailsDialog(event);
      });
}

// ignore: must_be_immutable
class LessonDetailsDialog extends StatefulWidget {
  AgendaEvent event;
  LessonDetailsDialog(this.event, {Key? key}) : super(key: key);

  @override
  _LessonDetailsDialogState createState() => _LessonDetailsDialogState();
}

class _LessonDetailsDialogState extends State<LessonDetailsDialog> {
  List<AgendaReminder> reminders = [];
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                  color: Theme.of(context).primaryColor),
              padding: EdgeInsets.symmetric(
                  vertical: screenSize.size.height / 10 * 0.2, horizontal: screenSize.size.width / 5 * 0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const DragHandle(),
                  SizedBox(
                    height: screenSize.size.height / 10 * 0.1,
                  ),
                  if (widget.event.name != null)
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.05),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(25)),
                                color: widget.event.realColor),
                            padding: const EdgeInsets.all(5),
                            child: FittedBox(
                              child: Text(
                                widget.event.name != "" && widget.event.name != null
                                    ? widget.event.name!
                                    : "(sans nom)",
                                style: const TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w700),
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
                    margin: EdgeInsets.zero,
                    color: Theme.of(context).primaryColorDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                child: Text("Infos de l'évènement",
                                    style: TextStyle(
                                        fontFamily: "Asap",
                                        fontWeight: FontWeight.bold,
                                        color: ThemeUtils.textColor()))),
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 0.2)),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.size.height / 10 * 0.1,
                  ),
                  SizedBox(
                    height: screenSize.size.height / 10 * 0.7,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 0),
                        scrollDirection: Axis.horizontal,
                        itemCount: reminders.length + 1,
                        itemBuilder: (BuildContext context, index) {
                          if (index == reminders.length) {
                            return GestureDetector(
                              onTap: () async {
                                AgendaReminder? reminder =
                                    (await (agendaEventEdit(context, false, lessonID: widget.event.id)))
                                        as AgendaReminder?;
                                if (reminder != null) {
                                  setState(() {
                                    reminders.add(reminder);
                                  });

                                  RemindersOffline(appSys.offline).updateReminders(reminder);
                                  await AppNotification.scheduleReminders(widget.event);
                                }
                              },
                              child: Card(
                                  margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.05),
                                  color: Theme.of(context).primaryColorDark,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                                  child: Container(
                                    height: screenSize.size.height / 10 * 0.8,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: screenSize.size.height / 10 * 0.1),
                                    child: FittedBox(
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          //Plus button

                                          SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: RawMaterialButton(
                                              onPressed: () async {
                                                AgendaReminder? reminder =
                                                    (await agendaEventEdit(context, false, lessonID: widget.event.id))
                                                        as AgendaReminder?;
                                                if (reminder != null) {
                                                  setState(() {
                                                    reminders.add(reminder);
                                                  });
                                                  RemindersOffline(appSys.offline).updateReminders(reminder);
                                                  await AppNotification.scheduleReminders(widget.event);
                                                }
                                              },
                                              child: FittedBox(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 25,
                                                      height: 25,
                                                      padding: const EdgeInsets.all(
                                                        5,
                                                      ),
                                                      child: FittedBox(
                                                        child: Icon(
                                                          Icons.add,
                                                          color: ThemeUtils.textColor(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              shape: const CircleBorder(),
                                              elevation: 1.0,
                                              fillColor: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          SizedBox(width: screenSize.size.width / 5 * 0.1),
                                          Text(
                                            "Ajouter un rappel",
                                            style: TextStyle(
                                                fontFamily: "Asap",
                                                color: ThemeUtils.textColor(),
                                                textBaseline: TextBaseline.ideographic),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () async {
                                Logger.log("BOTTOM SHEET", "(Agenda event details) Reminders ${reminders[index]}");

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
                                    RemindersOffline(appSys.offline).updateReminders(reminder);
                                    await AppNotification.scheduleReminders(widget.event);
                                  }
                                }
                              },
                              child: Card(
                                  margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.05),
                                  color: reminders[index].realTagColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                                  child: Container(
                                    height: screenSize.size.height / 10 * 0.8,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.size.width / 5 * 0.2,
                                        vertical: screenSize.size.height / 10 * 0.1),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        //Plus button
                                        if (reminders[index].alarm != AlarmType.none)
                                          SizedBox(
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
                                                    RemindersOffline(appSys.offline).updateReminders(reminder);
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
                                                        child: Icon(
                                                          MdiIcons.bellRing,
                                                          color: ThemeUtils.textColor(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              shape: const CircleBorder(),
                                              elevation: 1.0,
                                              fillColor: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        if (reminders[index].alarm != AlarmType.none)
                                          SizedBox(width: screenSize.size.width / 5 * 0.1),
                                        if (reminders[index].name != null && reminders[index].name!.isNotEmpty)
                                          SizedBox(
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
                                  )),
                            );
                          }
                        }),
                  )
                ],
              )),
        ),
      ],
    );
  }

  void getAssociatedReminders() async {
    List<AgendaReminder>? remindersOnline = await RemindersOffline(appSys.offline).getReminders(widget.event.id);
    setState(() {
      if (remindersOnline != null) {
        reminders = remindersOnline;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getAssociatedReminders();
  }
}
