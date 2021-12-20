import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class IntroConfigPage extends StatefulWidget {
  const IntroConfigPage({Key? key}) : super(key: key);

  @override
  _IntroConfigPageState createState() => _IntroConfigPageState();
}

class _IntroConfigPageState extends State<IntroConfigPage> {
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
        appBar: const YAppBar(title: "Configuration", removeLeading: true),
        body: ControllerConsumer<ApplicationSystem>(
            controller: appSys,
            builder: (context, controller, _) => Column(
                  children: [
                    YSettingsSections(
                      sections: [
                        if (Platform.isAndroid || Platform.isIOS)
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
                        YSettingsSection(title: "Divers", tiles: [
                          if (controller.account!.isParentMainAccount)
                            YSettingsTile(
                                title: "Compte",
                                subtitle: (controller.currentSchoolAccount?.name) ?? "(non choisi)",
                                onTap: () async {
                                  if (controller.account != null && controller.account!.managableAccounts != null) {
                                    final SchoolAccount? res = await YDialogs.getConfirmation<SchoolAccount>(
                                        context,
                                        YConfirmationDialog(
                                            title: "Choisis un compte",
                                            initialValue: controller.currentSchoolAccount,
                                            options: controller.account!.managableAccounts!
                                                .map((account) => YConfirmationDialogOption(
                                                    value: account, label: account.name ?? "Sans nom"))
                                                .toList()));
                                    if (res != null) {
                                      controller.currentSchoolAccount = res;
                                      controller.saveSettings();
                                    }
                                  }
                                }),
                          YSettingsTile.switchTile(
                            title: 'Mode nuit',
                            switchValue: theme.isDark,
                            onSwitchValueChanged: (bool value) async {
                              controller.updateTheme(value ? "sombre" : "clair");
                              appSys.saveSettings();
                            },
                          ),
                          YSettingsTile(
                            title: "Spécialités",
                            subtitle:
                                "Si tu es en classe de Première ou Terminale, sélectionner tes spécialités te permet d'avoir accès à des filtres supplémentaires",
                            onTap: () => CustomDialogs.showSpecialtiesChoice(context),
                          )
                        ])
                      ],
                    ),
                    YVerticalSpacer(YScale.s6),
                    Padding(
                      padding: YPadding.px(YScale.s2),
                      child: YButton(
                          onPressed: () async {
                            controller.loginController.login();
                            controller.api!.getEvents(DateTime.now(), forceReload: false);
                            controller.gradesController.refresh(force: true);
                            controller.homeworkController.refresh(force: true);
                            await KVS.write(key: "agreedTermsAndConfiguredApp", value: "true");
                            Navigator.pushReplacementNamed(context, "/home");
                          },
                          text: "Allons-y !",
                          block: true),
                    ),
                  ],
                )));
  }
}
