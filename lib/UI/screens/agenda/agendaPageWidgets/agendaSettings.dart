import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';

class AgendaSettings extends StatefulWidget {
  @override
  _AgendaSettingsState createState() => _AgendaSettingsState();
}

class _AgendaSettingsState extends State<AgendaSettings> {
  @override
  void initState() {
    // TODO: implement initState

    getSettings();
  }

  //Settings
  var boolSettings = {"lighteningOverride": false, "agendaOnGoingNotification": false, "reverseWeekNames": false};
  var intSettings = {"lessonReminderDelay": 5};
  void getSettings() async {
    await Future.forEach(boolSettings.keys, (key) async {
      var value = await getSetting(key);
      setState(() {
        boolSettings[key] = value;
      });
    });

    await Future.forEach(intSettings.keys, (key) async {
      int value = await getIntSetting(key);
      setState(() {
        intSettings[key] = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
        color: Theme.of(context).primaryColor,
      ),
      width: screenSize.size.width / 5 * 4.5,
      child: Column(
        children: [
          Container(
              width: screenSize.size.width / 5 * 4.5,
              margin: EdgeInsets.all(screenSize.size.width / 5 * 0.2),
              child: Text(
                "Paramètres de l'agenda",
                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
                textAlign: TextAlign.left,
              )),
          SwitchListTile(
            value: boolSettings["lighteningOverride"],
            title: Text("Ignorer la réduction de stockage hors ligne", style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
            subtitle: Text(
              "Stocke plus de semaines hors ligne mais augmente la taille de l'application",
              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.16),
            ),
            onChanged: (value) async {
              setState(() {
                boolSettings["lighteningOverride"] = value;
              });

              await setSetting("lighteningOverride", value);
            },
            secondary: Icon(
              MdiIcons.zipBox,
              color: ThemeUtils.textColor(),
            ),
          ),
          SwitchListTile(
            value: boolSettings["reverseWeekNames"],
            title: Text("Inverser semaines A et B", style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
            onChanged: (value) async {
              setState(() {
                boolSettings["reverseWeekNames"] = value;
              });

              await setSetting("reverseWeekNames", value);
            },
            secondary: Icon(
              MdiIcons.calendarWeek,
              color: ThemeUtils.textColor(),
            ),
          ),
          ListTile(
            title: Text("Me rappeler les cours", style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
            subtitle: Text(
              "${(intSettings["lessonReminderDelay"]).toString()} minutes avant",
              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.16),
            ),
            onTap: () async {
              var value = await CustomDialogs.showNumberChoiceDialog(context, text: "la durée");
              if (value != null) {
                setState(() {
                  intSettings["lessonReminderDelay"] = value;
                });

                await setIntSetting("lessonReminderDelay", value);
              }
            },
            leading: Icon(
              MdiIcons.clockAlert,
              color: ThemeUtils.textColor(),
            ),
          ),
          if (Platform.isAndroid)
            ListTile(
              title: Text("Notification constante", style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
              subtitle: Text(
                boolSettings["agendaOnGoingNotification"] ? "Activée" : "Désactivée",
                style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.16),
              ),
              onTap: () async {
                await CustomDialogs.showPersistantNotificationDialog(context);
                getSettings();
                setState(() {});
              },
              leading: Icon(
                MdiIcons.viewAgendaOutline,
                color: ThemeUtils.textColor(),
              ),
            ),
        ],
      ),
    );
  }
}
