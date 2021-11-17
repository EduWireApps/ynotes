import 'package:auto_size_text/auto_size_text.dart';
import 'package:battery_optimization/battery_optimization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class PersistantNotificationConfigDialog extends StatefulWidget {
  const PersistantNotificationConfigDialog({Key? key}) : super(key: key);

  @override
  _PersistantNotificationConfigDialogState createState() => _PersistantNotificationConfigDialogState();
}

class _PersistantNotificationConfigDialogState extends State<PersistantNotificationConfigDialog> {
  String perm = "Permissions accordées.";
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: ThemeUtils.darken(Theme.of(context).primaryColorDark, forceAmount: 0.01),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      contentPadding: const EdgeInsets.only(top: 0.0),
      content: SizedBox(
        height: screenSize.size.height / 10 * 7,
        width: screenSize.size.width / 5 * 4.7,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                color: ThemeUtils.darken(Theme.of(context).primaryColorDark, forceAmount: 0.12),
              ),
              height: screenSize.size.height / 10 * 2.8,
              width: screenSize.size.width / 5 * 4.7,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                      child: Image(
                          width: screenSize.size.width / 5 * 4,
                          height: screenSize.size.height / 10 * 1.8,
                          fit: BoxFit.scaleDown,
                          image: AssetImage(
                              'assets/images/pageItems/persistantNotification/persisIllu${appSys.themeName == "sombre" ? "Dark" : "Light"}.png'))),
                  SizedBox(
                    width: screenSize.size.width / 5 * 4.4,
                    child: AutoSizeText.rich(
                      const TextSpan(
                        text: "Soyez averti des cours en cours grâce à une",
                        children: <TextSpan>[
                          TextSpan(
                              text: ' notification toujours présente', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' dans le panneau de contrôle de votre appareil.'),
                        ],
                      ),
                      style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                    ),
                  )
                ],
              ),
            ),
            SwitchListTile(
              value: appSys.settings.user.agendaPage.agendaOnGoingNotification,
              title: Text("Activée",
                  style: TextStyle(
                      fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
              onChanged: (value) async {
                if ((await Permission.ignoreBatteryOptimizations.isGranted)) {
                  appSys.settings.user.agendaPage.agendaOnGoingNotification = value;
                  appSys.saveSettings();

                  setState(() {});
                  if (value) {
                    await AppNotification.setOnGoingNotification();
                  } else {
                    await AppNotification.cancelOnGoingNotification();
                  }
                } else {
                  if (await CustomDialogs.showAuthorizationsDialog(
                          context,
                          "la configuration d'optimisation de batterie",
                          "Pouvoir s'exécuter en arrière plan sans être automatiquement arrêté par Android.") ??
                      false) {
                    if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
                      appSys.settings.user.agendaPage.agendaOnGoingNotification = value;
                      appSys.saveSettings();
                      setState(() {});
                      if (value) {
                        await AppNotification.setOnGoingNotification();
                      } else {
                        await AppNotification.cancelOnGoingNotification();
                      }
                    }
                  }
                }
              },
              secondary: Icon(
                MdiIcons.power,
                color: ThemeUtils.textColor(),
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            SwitchListTile(
              value: appSys.settings.user.agendaPage.enableDNDWhenOnGoingNotifEnabled,
              title: Text("Activer le mode ne pas déranger à l'entrée en cours",
                  style: TextStyle(
                      fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.20)),
              onChanged: (value) async {
                final status = await Permission.accessNotificationPolicy.status;
                if (!status.isGranted) {
                  final res = await Permission.accessNotificationPolicy.request();
                  UIUtils.setSystemUIOverlayStyle();
                  if (!res.isGranted) {
                    await YDialogs.showInfo(
                        context,
                        YInfoDialog(
                          title: "Oups !",
                          body: Text("Pour utiliser cette fonctionnalité, tu dois accorder cette permission à yNotes.",
                              style: theme.texts.body1),
                          confirmLabel: "OK",
                        ));
                    return;
                  }
                }
                appSys.settings.user.agendaPage.enableDNDWhenOnGoingNotifEnabled = value;
                await appSys.saveSettings();
                setState(() {});
              },
              secondary: Icon(
                MdiIcons.moonWaningCrescent,
                color: ThemeUtils.textColor(),
              ),
            ),
            SwitchListTile(
              value: appSys.settings.user.agendaPage.disableAtDayEnd,
              title: Text("Desactiver en fin de journée",
                  style: TextStyle(
                      fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.20)),
              onChanged: (value) async {
                appSys.settings.user.agendaPage.disableAtDayEnd = value;
                appSys.saveSettings();
                setState(() {});
              },
              secondary: Icon(
                MdiIcons.powerOff,
                color: ThemeUtils.textColor(),
              ),
            ),
            ListTile(
              title: Text("Réparer les permissions",
                  style: TextStyle(
                      fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.21)),
              subtitle: Text(
                perm,
                style: TextStyle(
                    fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.16),
              ),
              onTap: () async {
                if (!((await BatteryOptimization.isIgnoringBatteryOptimizations()) ?? false) &&
                    await (CustomDialogs.showAuthorizationsDialog(
                            context,
                            "la configuration d'optimisation de batterie",
                            "Pouvoir s'exécuter en arrière plan sans être automatiquement arrêté par Android.")
                        as Future<bool>)) {
                  await BatteryOptimization.openBatteryOptimizationSettings();
                }
                await getAuth();
              },
              leading: Icon(
                MdiIcons.autoFix,
                color: ThemeUtils.textColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAuth() async {
    await BatteryOptimization.isIgnoringBatteryOptimizations().then((onValue) {
      setState(() {
        if (onValue!) {
          setState(() {
            perm = "";
          });
        } else {
          setState(() {
            perm = "L'application n'ignore pas les optimisations de batterie !";
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAuth();
  }
}
