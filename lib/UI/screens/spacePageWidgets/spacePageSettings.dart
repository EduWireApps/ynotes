import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:flutter/src/scheduler/binding.dart';
import 'package:ynotes/background.dart';
import '../../../usefulMethods.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'dart:async';

import 'dart:io';

class SpacePageGlobalSettings extends StatefulWidget {
  @override
  _SpacePageGlobalSettingsState createState() => _SpacePageGlobalSettingsState();
}

class _SpacePageGlobalSettingsState extends State<SpacePageGlobalSettings> {
  var boolSettings = {"organisationIsDefault": false};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSettings();
  }

  void getSettings() async {
    await Future.forEach(boolSettings.keys, (key) async {
      var value = await getSetting(key);
      setState(() {
        boolSettings[key] = value;
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
                "Paramètres globaux",
                style: TextStyle(
                    fontFamily: "Asap",
                    fontWeight: FontWeight.bold,
                    color: isDarkModeEnabled ? Colors.white : Colors.black),
                textAlign: TextAlign.left,
              )),
          SwitchListTile(
            value: boolSettings["organisationIsDefault"],
            title: Text("Toujours afficher le menu Organisation par défaut",
                style: TextStyle(
                    fontFamily: "Asap",
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                    fontSize: screenSize.size.height / 10 * 0.21)),
            onChanged: (value) async {
              setState(() {
                boolSettings["organisationIsDefault"] = value;
              });

              await setSetting("organisationIsDefault", value);
            },
            secondary: Icon(
              MdiIcons.viewAgenda,
              color: isDarkModeEnabled ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class OrganisationSettings extends StatefulWidget {
  @override
  _OrganisationSettingsState createState() => _OrganisationSettingsState();
}

class _OrganisationSettingsState extends State<OrganisationSettings> {
  @override
  void initState() {
    // TODO: implement initState

    getSettings();
  }

  //Settings
  var boolSettings = {"lighteningOverride": false, "agendaOnGoingNotification": false};
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
                "Paramètres de la section organisation",
                style: TextStyle(
                    fontFamily: "Asap",
                    fontWeight: FontWeight.bold,
                    color: isDarkModeEnabled ? Colors.white : Colors.black),
                textAlign: TextAlign.left,
              )),
          SwitchListTile(
            value: boolSettings["lighteningOverride"],
            title: Text("Ignorer la réduction de stockage hors ligne",
                style: TextStyle(
                    fontFamily: "Asap",
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                    fontSize: screenSize.size.height / 10 * 0.21)),
            subtitle: Text(
              "Stocke plus de semaines hors ligne mais augmente la taille de l'application",
              style: TextStyle(
                  fontFamily: "Asap",
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                  fontSize: screenSize.size.height / 10 * 0.16),
            ),
            onChanged: (value) async {
              setState(() {
                boolSettings["lighteningOverride"] = value;
              });

              await setSetting("lighteningOverride", value);
            },
            secondary: Icon(
              MdiIcons.zipBox,
              color: isDarkModeEnabled ? Colors.white : Colors.black,
            ),
          ),
          ListTile(
            title: Text("Me rappeler les cours",
                style: TextStyle(
                    fontFamily: "Asap",
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                    fontSize: screenSize.size.height / 10 * 0.21)),
            subtitle: Text(
              "${(intSettings["lessonReminderDelay"]).toString()} minutes avant",
              style: TextStyle(
                  fontFamily: "Asap",
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                  fontSize: screenSize.size.height / 10 * 0.16),
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
              color: isDarkModeEnabled ? Colors.white : Colors.black,
            ),
          ),
          SwitchListTile(
            value: boolSettings["agendaOnGoingNotification"],
            title: Text("Notification constante (beta)",
                style: TextStyle(
                    fontFamily: "Asap",
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                    fontSize: screenSize.size.height / 10 * 0.21)),
            onChanged: (value) async {
              setState(() {
                boolSettings["agendaOnGoingNotification"] = value;
              });

              await setSetting("agendaOnGoingNotification", value);
              if (value) {
                await LocalNotification.setOnGoingNotification();
              } else {
                await LocalNotification.cancelOnGoingNotification();
              }
            },
            secondary: Icon(
              MdiIcons.viewAgendaOutline,
              color: isDarkModeEnabled ? Colors.white : Colors.black,
            ),
          ),
          
        ],
      ),
    );
  }
}
