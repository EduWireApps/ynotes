import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/agendaGrid.dart';

import '../../../classes.dart';
import '../../../usefulMethods.dart';

///Agenda event editor, has to be called with a `buildContext`, and the boolean `isLesson` is not optionnal to avoid any confusions.
///`customEvent` and `reminder` are optionals (for editing existing events), but can't both be set.
///If this is a reminder `lessonID` can't be null otherwise it will throw an exception.
Future agendaEventEdit(context, isCustomEvent, {AgendaEvent customEvent, AgendaReminder reminder, String lessonID}) async {
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
        return agendaEventEditLayout(
          isCustomEvent,
          customEvent: customEvent,
          reminder: reminder,
          lessonID: lessonID,
        );
      });
}

class agendaEventEditLayout extends StatefulWidget {
  bool isCustomEvent;
  //Reminder stuff
  AgendaReminder reminder;
  String lessonID;

  //Custom event stuff
  AgendaEvent customEvent;

  agendaEventEditLayout(this.isCustomEvent, {this.reminder, this.lessonID, this.customEvent});

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
    settingExistingReminder();
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
      alarm = this.widget.customEvent.alarm;
      id = this.widget.customEvent.id;
      // tagColor = this.widget.reminder.realTagColor;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2), height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75, width: screenSize.size.width / 5 * 2, child: Icon(MdiIcons.cancel, color: Colors.redAccent))),
                  GestureDetector(
                      onTap: () {
                        //Exit with a value

                        if (!widget.isCustomEvent) {
                          AgendaReminder reminder = AgendaReminder(widget.lessonID, titleController.text, alarm, id ?? (widget.lessonID + "1"), description: descriptionController.text, tagColor: tagColor.value);
                          Navigator.of(context).pop(reminder);
                        }
                        if (widget.isCustomEvent) {
                          AgendaEvent event = AgendaEvent(start, end, titleController.text, "", null, null, false, id, null);
                          Navigator.of(context).pop(event);
                        }
                      },
                      child: Container(margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2), height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75, width: screenSize.size.width / 5 * 2, child: Icon(MdiIcons.check, color: isDarkModeEnabled ? Colors.white : Colors.black))),
                ],
              ),
            ),
            SizedBox(height: screenSize.size.height / 10 * 0.2),
            Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
              child: TextField(
                controller: titleController,
                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: screenSize.size.width / 5 * 0.35),
                decoration: new InputDecoration.collapsed(hintText: 'Ajouter un titre', hintStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8))),
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
                      style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
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
                          'Toute la journée',
                          style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                        ),
                        value: wholeDay,
                        onChanged: (nValue) {
                          setState(() {
                            wholeDay = nValue;
                          });
                        }),
                    if (!wholeDay)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: screenSize.size.width / 5 * 0.4,
                            height: screenSize.size.width / 5 * 0.4,
                            child: Icon(
                              MdiIcons.calendar,
                              size: screenSize.size.width / 5 * 0.4,
                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(width: screenSize.size.width / 5 * 0.1),
                          Text(
                            'Changer la date',
                            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            if (widget.isCustomEvent) Divider(height: screenSize.size.height / 10 * 0.4),
            GestureDetector(
              onTap: () async {
                var choice = await CustomDialogs.showMultipleChoicesDialog(context, alarmChoices, [alarm.index]);
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
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
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
              height: screenSize.size.height / 10 * 2.5,
              child: TextField(
                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: screenSize.size.width / 5 * 0.25),
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                maxLines: null,
                decoration: new InputDecoration.collapsed(hintText: 'Description', hintStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8))),
              ),
            ),
            Divider(height: screenSize.size.height / 10 * 0.4),
          ],
        ));
  }
}
