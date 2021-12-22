import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';

class AgendaSettings extends StatefulWidget {
  const AgendaSettings({Key? key}) : super(key: key);

  @override
  _AgendaSettingsState createState() => _AgendaSettingsState();
}

class _AgendaSettingsState extends State<AgendaSettings> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Column(
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
          value: appSys.settings.user.agendaPage.lighteningOverride,
          title: Text("Ignorer la réduction de stockage hors ligne",
              style: TextStyle(
                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
          subtitle: Text(
            "Stocke plus de semaines hors ligne mais augmente la taille de l'application",
            style: TextStyle(
                fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.16),
          ),
          onChanged: (value) async {
            appSys.settings.user.agendaPage.lighteningOverride = value;
            appSys.saveSettings();
            setState(() {});
          },
          secondary: Icon(
            MdiIcons.zipBox,
            color: ThemeUtils.textColor(),
          ),
        ),
        SwitchListTile(
          value: appSys.settings.user.agendaPage.reverseWeekNames,
          title: Text("Inverser semaines A et B",
              style: TextStyle(
                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
          onChanged: (value) async {
            appSys.settings.user.agendaPage.reverseWeekNames = value;
            appSys.saveSettings();
            setState(() {});
          },
          secondary: Icon(
            MdiIcons.calendarWeek,
            color: ThemeUtils.textColor(),
          ),
        ),
        ListTile(
          title: Text("Me rappeler les cours",
              style: TextStyle(
                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
          subtitle: Text(
            "${(appSys.settings.user.agendaPage.lessonReminderDelay).toString()} minutes avant",
            style: TextStyle(
                fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.16),
          ),
          onTap: () async {
            var value = await CustomDialogs.showNumberChoiceDialog(context, text: "la durée");
            if (value != null) {
              appSys.settings.user.agendaPage.lessonReminderDelay = value;
              appSys.saveSettings();

              setState(() {});
            }
          },
          leading: Icon(
            MdiIcons.clockAlert,
            color: ThemeUtils.textColor(),
          ),
        ),
        if (!kIsWeb && Platform.isAndroid)
          ListTile(
            title: Text("Notification constante",
                style: TextStyle(
                    fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
            subtitle: Text(
              appSys.settings.user.agendaPage.agendaOnGoingNotification ? "Activée" : "Désactivée",
              style: TextStyle(
                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.16),
            ),
            onTap: () async {
              await CustomDialogs.showPersistantNotificationDialog(context);
            },
            leading: Icon(
              MdiIcons.viewAgendaOutline,
              color: ThemeUtils.textColor(),
            ),
          ),
      ],
    );
  }

  @override
  // ignore: must_call_super
  void initState() {}
}
