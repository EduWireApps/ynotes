import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/data/agenda/events.dart';
import 'package:ynotes/core/offline/data/agenda/reminders.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

///Agenda event editor, has to be called with a `buildContext`, and the boolean `isLesson` is not optionnal to avoid any confusions.
///`customEvent` and `reminder` are optionals (for editing existing events), but can't both be set.
///If this is a reminder `lessonID` can't be null otherwise it will throw an exception.
///It will return, "created", "edited" or "removed"
Future agendaEventEdit(context, isCustomEvent,
    {AgendaEvent? customEvent, AgendaReminder? reminder, String? lessonID, DateTime? defaultDate}) async {
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        //Assert for avoiding setting a new reminder without it's lesson ID
        assert(!isCustomEvent ? lessonID != null : true, "Setting a reminder require a lessonID");

        //Assert for avoiding setting a new custom event without default date
        assert(isCustomEvent ? defaultDate != null : true, "Setting a custom event require a default date");

        return AgendaEventEditLayout(
          isCustomEvent,
          customEvent: customEvent,
          reminder: reminder,
          lessonID: lessonID,
          defaultDate: defaultDate,
        );
      });
}

// ignore: must_be_immutable
class AgendaEventEditLayout extends StatefulWidget {
  bool isCustomEvent;
  //Reminder stuff
  AgendaReminder? reminder;
  String? lessonID;
  DateTime? defaultDate;
  //Custom event stuff
  AgendaEvent? customEvent;

  AgendaEventEditLayout(this.isCustomEvent,
      {Key? key, this.reminder, this.lessonID, this.customEvent, this.defaultDate})
      : super(key: key);

  @override
  _AgendaEventEditLayoutState createState() => _AgendaEventEditLayoutState();
}

class _AgendaEventEditLayoutState extends State<AgendaEventEditLayout> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List alarmChoices = [
    "Aucune alarme",
    "Au début",
    "5 minutes avant",
    "15 minutes avant",
    "30 minutes avant",
    "La veille"
  ];

//If this bottom sheet is called to edit an existing reminder
  String? title;

//If this bottom sheet is called to edit an existing reminder
  Color tagColor = Colors.orange;

  DateTime? start;
  DateTime? end;
  AlarmType alarm = AlarmType.none;
  String? description;
  bool? wholeDay = true;
  String? id;
  bool? canceled = false;
  String? location;
  Lesson? lesson;
  String? recurringScheme;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              ),
              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.size.height / 10 * 0.2),
                          const DragHandle(),
                          SizedBox(height: screenSize.size.height / 10 * 0.2),
                          Container(
                            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                            child: TextField(
                              controller: titleController,
                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 25),
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Ajouter un titre',
                                  hintStyle:
                                      TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8))),
                            ),
                          ),
                          Divider(height: screenSize.size.height / 10 * 0.4),
                          GestureDetector(
                            onTap: () async {
                              Color? color = await CustomDialogs.showColorPicker(context, tagColor);
                              if (color != null) {
                                setState(() {
                                  tagColor = color;
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: tagColor,
                                  ),
                                ),
                                SizedBox(width: screenSize.size.width / 5 * 0.1),
                                Text(
                                  'Choisir une couleur',
                                  style: TextStyle(
                                      fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8), fontSize: 25),
                                )
                              ],
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
                                        style: TextStyle(
                                            fontFamily: "Asap",
                                            color: ThemeUtils.textColor().withOpacity(0.8),
                                            fontSize: 25),
                                      ),
                                      value: canceled!,
                                      onChanged: (nValue) {
                                        setState(() {
                                          canceled = nValue;
                                        });
                                      }),
                                  SwitchListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        'Toute la journée',
                                        style: TextStyle(
                                            fontFamily: "Asap",
                                            color: ThemeUtils.textColor().withOpacity(0.8),
                                            fontSize: 25),
                                      ),
                                      value: wholeDay!,
                                      onChanged: (nValue) {
                                        setState(() {
                                          wholeDay = nValue;
                                        });
                                      }),
                                  if (!wholeDay!)
                                    Column(
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              var tempDate = await showTimePicker(
                                                  context: context, initialTime: TimeOfDay.fromDateTime(start!));
                                              if (tempDate != null) {
                                                setState(() {
                                                  start = DateTime(start!.year, start!.month, start!.day, tempDate.hour,
                                                      tempDate.minute);
                                                  if (start!.isAfter(end!)) {
                                                    end = start!.add(const Duration(minutes: 30));
                                                  }
                                                });
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  MdiIcons.calendar,
                                                  size: 25,
                                                  color: ThemeUtils.textColor(),
                                                ),
                                                SizedBox(width: screenSize.size.width / 5 * 0.1),
                                                Text(
                                                  'Début ${DateFormat.Hm().format(start!)}',
                                                  style: TextStyle(
                                                      fontFamily: "Asap",
                                                      color: ThemeUtils.textColor().withOpacity(0.8),
                                                      fontSize: 25),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              var tempDate = await showTimePicker(
                                                  context: context, initialTime: TimeOfDay.fromDateTime(end!));
                                              if (tempDate != null) {
                                                setState(() {
                                                  end = DateTime(
                                                      end!.year, end!.month, end!.day, tempDate.hour, tempDate.minute);
                                                  if (end!.isBefore(start!)) {
                                                    start = end!.subtract(const Duration(minutes: 30));
                                                  }
                                                });
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  MdiIcons.calendar,
                                                  size: 25,
                                                  color: ThemeUtils.textColor(),
                                                ),
                                                SizedBox(width: screenSize.size.width / 5 * 0.1),
                                                Text(
                                                  'Fin  ${DateFormat.Hm().format(end!)}',
                                                  style: TextStyle(
                                                      fontFamily: "Asap",
                                                      color: ThemeUtils.textColor().withOpacity(0.8),
                                                      fontSize: 25),
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

                                CustomLogger.log(
                                    "BOTTOM SHEET", "(Agenda event edit) Recurring scheme: $recurringScheme");
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    MdiIcons.repeat,
                                    size: 25,
                                    color: ThemeUtils.textColor(),
                                  ),
                                  SizedBox(width: screenSize.size.width / 5 * 0.1),
                                  Text(
                                    "Récurrence",
                                    style: TextStyle(
                                        fontFamily: "Asap",
                                        color: ThemeUtils.textColor().withOpacity(0.8),
                                        fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () async {
                              var choice = await CustomDialogs.showMultipleChoicesDialog(
                                  context, alarmChoices, [alarm.index],
                                  singleChoice: true);
                              if (choice != null && choice.length == 1) {
                                setState(() {
                                  alarm = AlarmType.values[choice[0]];
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    MdiIcons.bell,
                                    size: 25,
                                    color: ThemeUtils.textColor(),
                                  ),
                                  SizedBox(width: screenSize.size.width / 5 * 0.1),
                                  Text(
                                    alarmChoices[alarm.index],
                                    style: TextStyle(
                                        fontFamily: "Asap",
                                        color: ThemeUtils.textColor().withOpacity(0.8),
                                        fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(height: screenSize.size.height / 10 * 0.4),
                          Container(
                            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                            height: screenSize.size.height / 10 * 2,
                            child: TextField(
                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 25),
                              keyboardType: TextInputType.multiline,
                              controller: descriptionController,
                              maxLines: null,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Description',
                                  hintStyle:
                                      TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8))),
                            ),
                          ),
                          Divider(height: screenSize.size.height / 10 * 0.4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              YButton(
                                onPressed: () => Navigator.pop(context),
                                text: "Annuler",
                                color: YColor.secondary,
                                invertColors: true,
                              ),
                              YHorizontalSpacer(YScale.s2),
                              if (widget.customEvent != null || widget.reminder != null)
                                YButton(
                                    onPressed: () => deleteOrReset(),
                                    text: (widget.isCustomEvent && widget.customEvent!.isLesson!)
                                        ? "Réinitialiser"
                                        : "Supprimer",
                                    color: YColor.warning),
                              YHorizontalSpacer(YScale.s2),
                              YButton(
                                  onPressed: () => createEvent(),
                                  text: "Valider",
                                  color: !(widget.isCustomEvent && !wholeDay! && start!.isAtSameMomentAs(end!))
                                      ? YColor.success
                                      : YColor.secondary),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }

  void createEvent() async {
    //Exit with a value
    if (widget.isCustomEvent && !wholeDay! && start!.isAtSameMomentAs(end!)) {
      CustomDialogs.showAnyDialog(context, "Le début et la fin ne peuvent pas être au même moment.");
    } else {
      if (!widget.isCustomEvent) {
        AgendaReminder reminder = AgendaReminder(
            widget.lessonID, titleController.text, alarm, id ?? (widget.lessonID! + "1"),
            description: descriptionController.text, tagColor: tagColor.value);
        Navigator.of(context).pop(reminder);
      }
      if (widget.isCustomEvent) {
        if (wholeDay!) {}
        AgendaEvent event = AgendaEvent(wholeDay! ? widget.defaultDate : start, wholeDay! ? widget.defaultDate : end,
            titleController.text.trim(), location, null, null, canceled, id, null,
            wholeDay: wholeDay,
            color: tagColor.value,
            alarm: alarm,
            lesson: lesson,
            isLesson: lesson != null,
            description: descriptionController.text.trim(),
            recurrenceScheme: recurringScheme);
        Navigator.of(context).pop(event);
      }
    }
  }

  void deleteOrReset() async {
    if (widget.customEvent != null) {
      if (widget.customEvent!.recurrenceScheme != null && widget.customEvent!.recurrenceScheme != "0") {
        await AgendaEventsOffline(appSys.offline).removeAgendaEvent(id, await getWeek(widget.customEvent!.start!));
        await AgendaEventsOffline(appSys.offline).removeAgendaEvent(id, widget.customEvent!.recurrenceScheme);
      } else {
        await AgendaEventsOffline(appSys.offline).removeAgendaEvent(id, await getWeek(widget.customEvent!.start!));
      }
    }
    if (widget.reminder != null) {
      RemindersOffline(appSys.offline).remove(id);
    }
    Navigator.of(context).pop("removed");
  }

  @override
  void initState() {
    super.initState();
    if (start == null && widget.isCustomEvent) {
      CustomLogger.log("BOTTOM SHEET", "(Agenda event edit) Default data: ${widget.defaultDate}");
      setState(() {
        widget.defaultDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(widget.defaultDate!));
        start = widget.defaultDate!.add(const Duration(hours: 8));
      });
    }
    if (end == null && widget.isCustomEvent) {
      setState(() {
        widget.defaultDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(widget.defaultDate!));
        end = widget.defaultDate!.add(const Duration(hours: 9));
      });
    }
    settingExistingReminder();
    settingExistingCustomEvent();
    if (widget.isCustomEvent && id == null) {
      id = const Uuid().v1();
    }
  }

  void settingExistingCustomEvent() {
    if (widget.customEvent != null) {
      title = widget.customEvent?.name;
      titleController.text = title ?? "";
      description = widget.customEvent?.description;
      descriptionController.text = description ?? "";
      alarm = widget.customEvent?.alarm ?? AlarmType.none;
      id = widget.customEvent?.id;
      tagColor = widget.customEvent?.realColor ?? Colors.deepOrange;
      wholeDay = widget.customEvent?.wholeDay;
      start = widget.customEvent?.start;
      end = widget.customEvent?.end;
      lesson = widget.customEvent?.lesson;
      location = widget.customEvent?.location;
      canceled = widget.customEvent?.canceled;
      recurringScheme = widget.customEvent?.recurrenceScheme;
    }
  }

  void settingExistingReminder() {
    if (widget.reminder != null) {
      title = widget.reminder?.name;
      titleController.text = title!;
      description = widget.reminder?.description;
      descriptionController.text = description!;
      alarm = widget.reminder?.alarm ?? AlarmType.none;
      id = widget.reminder?.id;
      tagColor = widget.reminder?.realTagColor ?? Colors.deepOrange;
    }
  }
}
