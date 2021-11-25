import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/services/platform.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/globals.dart';
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
                      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                        YSettingsSection(title: "Dépannage", tiles: [
                          YSettingsTile(
                              title: "Réparer",
                              leading: MdiIcons.bellAlert,
                              onTap: () async {
                                if (Platform.isIOS) {
                                  await Permission.notification.request();
                                  return;
                                }

                                final batteryOptimizationStatus = await Permission.ignoreBatteryOptimizations.status;
                                if (!batteryOptimizationStatus.isGranted) {
                                  if (batteryOptimizationStatus.isDenied) {
                                    final res = await Permission.ignoreBatteryOptimizations.request();
                                    UIUtils.setSystemUIOverlayStyle();
                                    if (!res.isGranted) {
                                      await YDialogs.showInfo(
                                          context,
                                          YInfoDialog(
                                              title: "Oups !",
                                              body: Text(
                                                  "Les notifications risquent de ne pas fonctionner correctement si tu n'accordes pas cette permission à yNotes.",
                                                  style: theme.texts.body1),
                                              confirmLabel: "OK"));
                                    }
                                  }
                                  if (batteryOptimizationStatus.isPermanentlyDenied) {
                                    await YDialogs.showInfo(
                                        context,
                                        YInfoDialog(
                                            title: "Oups !",
                                            body: Text(
                                                "Tu as bloqué cette permission de façon définitive, les notifications risquent par conséquent de ne pas fonctionner correctement.",
                                                style: theme.texts.body1),
                                            confirmLabel: "OK"));
                                  }
                                }

                                final bool res = await YDialogs.getChoice(
                                    context,
                                    YChoiceDialog(
                                      title: "Permission",
                                      body: Text(
                                          "Pour pourvoir lancer yNotes au démarrage de l'appareil et ainsi régulièrement rafraichir en arrière plan, tu dois ajouter yNotes à la liste blanche de lancement en arrière plan / démarrage.",
                                          style: theme.texts.body1),
                                      confirmLabel: "OK",
                                    ));

                                if (res) {
                                  await AndroidPlatformChannel.openAutoStartSettings();
                                } else {
                                  await YDialogs.showInfo(
                                      context,
                                      YInfoDialog(
                                          title: "Oups !",
                                          body: Text("Les notifications risquent de ne pas fonctionner correctement.",
                                              style: theme.texts.body1),
                                          confirmLabel: "OK"));
                                }

                                await AppNotification.showDebugNotification();
                              }),
                          YSettingsTile(
                              title: "Consulter notre guide",
                              subtitle:
                                  "Si malgré l'outil de dépannage tu ne reçois pas de notifications correctement, consultre notre guide en ligne. Si le problème persiste, contacte le support.",
                              onTap: () async => await launch("https://support.ynotes.fr/divers/notifications"))
                        ])
                    ])
                  ],
                )));
  }
}
