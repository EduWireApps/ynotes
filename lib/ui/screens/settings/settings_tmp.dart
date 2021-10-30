import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/account.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with YPageMixin {
  Future<void> notificationSetting({required ApplicationSystem controller, required Function fn}) async {
    if (controller.settings.user.global.batterySaver) {
      YSnackbars.info(context,
          title: "Paramètre désactivé",
          message: "Tu as activé l'économiseur de batterie, qui désactive l'envoi de notifications.");
      return;
    }
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
        appBar: const YAppBar(title: "Paramètres"),
        body: ControllerConsumer<ApplicationSystem>(
            controller: appSys,
            builder: (context, controller, _) => YSettingsSections(sections: [
                  // TODO: move to a new page "account"
                  YSettingsSection(title: "Compte", tiles: [
                    YSettingsTile(
                        title: controller.currentSchoolAccount?.name ?? "Invité",
                        leading: Icons.account_circle_rounded,
                        onTap: () => openLocalPage(const YPageLocal(child: AccountPage(), title: "Compte"))),
                    YSettingsTile(
                      title: "Spécialités",
                      subtitle:
                          "Si tu es en classe de Première ou Terminale, sélectionner tes spécialités te permet d'avoir accès à des filtres supplémentaires",
                      onTap: () => CustomDialogs.showSpecialtiesChoice(context),
                    ),
                    YSettingsTile(
                        title: "Supprimer les données hors ligne",
                        color: YColor.danger,
                        onTap: () async {
                          final bool res = await YDialogs.getChoice(
                              context,
                              YChoiceDialog(
                                  color: YColor.danger,
                                  title: "Attention",
                                  body: Text(
                                      "Êtes vous sûr de vouloir supprimer les données hors ligne ? Cette action est irréversible",
                                      style: theme.texts.body1)));
                          if (res) {
                            await controller.offline.clearAll();
                            controller.api = apiManager(controller.offline);
                          }
                        })
                  ]),
                  YSettingsSection(tiles: [
                    YSettingsTile.switchTile(
                      title: 'Mode nuit',
                      switchValue: theme.isDark,
                      onSwitchValueChanged: (bool value) async {
                        controller.updateTheme(value ? "sombre" : "clair");
                        appSys.saveSettings();
                      },
                    ),
                    YSettingsTile.switchTile(
                      title: "Economiseur de batterie",
                      subtitle: "Réduit les interactions réseaux, désactive les notifications.",
                      switchValue: controller.settings.user.global.batterySaver,
                      onSwitchValueChanged: (bool value) async {
                        controller.settings.user.global.batterySaver = value;
                        appSys.saveSettings();
                      },
                    ),
                  ]),
                  // TODO: move to a new page maybe?
                  YSettingsSection(title: "Notifications", tiles: [
                    YSettingsTile.switchTile(
                      title: "Nouvel email",
                      switchValue: controller.settings.user.global.notificationNewMail,
                      onSwitchValueChanged: (bool value) async => await notificationSetting(
                          controller: controller,
                          fn: () => controller.settings.user.global.notificationNewMail = value),
                    ),
                    YSettingsTile.switchTile(
                      title: "Nouvelle note",
                      switchValue: controller.settings.user.global.notificationNewGrade,
                      onSwitchValueChanged: (bool value) async => await notificationSetting(
                          controller: controller,
                          fn: () => controller.settings.user.global.notificationNewGrade = value),
                    )
                  ]),
                  if (!kReleaseMode)
                    YSettingsSection(title: "[DEV ONLY]", tiles: [
                      YSettingsTile(
                          title: "Secure Logger",
                          subtitle: "Print secure logger categories",
                          onTap: () async {
                            CustomLogger.saveLog(object: "Test", text: "test");
                            CustomLogger.log("SECURE LOGGER", "Categories: ${await SecureLogger.getCategories()}");
                          })
                    ])
                ])));
  }
}
