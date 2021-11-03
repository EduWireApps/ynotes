import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/services/platform.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/theme.dart';

class SettingsNotificationsPage extends StatefulWidget {
  const SettingsNotificationsPage({Key? key}) : super(key: key);

  @override
  _SettingsNotificationsPageState createState() => _SettingsNotificationsPageState();
}

class _SettingsNotificationsPageState extends State<SettingsNotificationsPage> {
  Future<void> notificationSetting({required ApplicationSystem controller, required Function fn}) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final notificationPermission = await Permission.notification.request();
      final batteryPermission = await Permission.ignoreBatteryOptimizations.request();
      UIUtils.setSystemUIOverlayStyle();
      if (notificationPermission.isGranted && batteryPermission.isGranted) {
        fn();
        appSys.saveSettings();
      } else {
        YDialogs.showInfo(
            context,
            YInfoDialog(
                title: "Oups !",
                body: Text("Tu n'as pas accordé à yNotes toutes les permissions nécessaires.",
                    style: theme.texts.body1)));
      }
    } else {
      fn();
      appSys.saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Notifications"),
        body: ControllerConsumer<ApplicationSystem>(
            controller: appSys,
            builder: (context, controller, _) => Column(
                  children: [
                    YSettingsSections(sections: [
                      YSettingsSection(tiles: [
                        YSettingsTile.switchTile(
                          title: "Nouvel email",
                          switchValue: controller.settings.user.global.notificationNewMail,
                          onSwitchValueChanged: (bool value) async => await notificationSetting(
                              controller: controller,
                              fn: () => controller.settings.user.global.notificationNewMail = value),
                          disabledOnTap: () => YSnackbars.info(context,
                              title: "Paramètre désactivé",
                              message:
                                  "Tu as activé l'économiseur de batterie, qui désactive l'envoi de notifications."),
                          enabled: !controller.settings.user.global.batterySaver,
                        ),
                        YSettingsTile.switchTile(
                          title: "Nouvelle note",
                          switchValue: controller.settings.user.global.notificationNewGrade,
                          onSwitchValueChanged: (bool value) async => await notificationSetting(
                              controller: controller,
                              fn: () => controller.settings.user.global.notificationNewGrade = value),
                          disabledOnTap: () => YSnackbars.info(context,
                              title: "Paramètre désactivé",
                              message:
                                  "Tu as activé l'économiseur de batterie, qui désactive l'envoi de notifications."),
                          enabled: !controller.settings.user.global.batterySaver,
                        )
                      ]),
                      // TODO: rework
                      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                        YSettingsSection(tiles: [
                          YSettingsTile(
                              title: "Je ne reçois pas de notifications",
                              leading: MdiIcons.bellAlert,
                              onTap: () async {
                                if (Platform.isIOS) {
                                  await Permission.notification.request();
                                  return;
                                }

                                //Check battery optimization setting
                                if (!await Permission.ignoreBatteryOptimizations.isGranted &&
                                    await CustomDialogs.showAuthorizationsDialog(
                                        context,
                                        "la configuration d'optimisation de batterie",
                                        "Pouvoir s'exécuter en arrière plan sans être automatiquement arrêté par Android.")) {
                                  await Permission.ignoreBatteryOptimizations.request().isGranted;
                                }

                                if (await CustomDialogs.showAuthorizationsDialog(
                                        context,
                                        "la liste blanche de lancement en arrière plan / démarrage",
                                        "Pouvoir lancer yNotes au démarrage de l'appareil et ainsi régulièrement rafraichir en arrière plan.") ??
                                    false) {
                                  await AndroidPlatformChannel.openAutoStartSettings();
                                }
                                await AppNotification.showDebugNotification();
                                YSnackBar(context,
                                    title: "Toujours pas de notifications ?",
                                    message: "Consulte notre guide",
                                    color: YColor.info,
                                    action: YSnackbarAction(
                                        text: "Voir",
                                        onPressed: () async =>
                                            await launch("https://support.ynotes.fr/divers/notifications")));
                              })
                        ])
                    ])
                  ],
                )));
  }
}
