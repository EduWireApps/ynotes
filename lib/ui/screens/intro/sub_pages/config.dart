import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/services.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/utilities.dart';

class IntroConfigPage extends StatefulWidget {
  const IntroConfigPage({Key? key}) : super(key: key);

  @override
  _IntroConfigPageState createState() => _IntroConfigPageState();
}

class _IntroConfigPageState extends State<IntroConfigPage> {
  Future<void> notificationSetting(BuildContext context, Function fn) async {
    final res =
        await SystemService.handlePermission(context, permission: Permission.notification, name: "Notifications");
    if (res) {
      fn();
      await SettingsService.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Configuration", removeLeading: true),
        body: Column(
          children: [
            YSettingsSections(
              sections: [
                if (Platform.isAndroid || Platform.isIOS)
                  ChangeNotifierConsumer<Settings>(
                      controller: SettingsService.settings,
                      builder: (context, settings, _) {
                        return YSettingsSection(tiles: [
                          YSettingsTile.switchTile(
                            title: "Nouvel email",
                            switchValue: settings.notifications.newEmail,
                            onSwitchValueChanged: (bool value) async =>
                                await notificationSetting(context, () => settings.notifications.newEmail = value),
                            disabledOnTap: () => YSnackbars.info(context,
                                title: "Paramètre désactivé",
                                message:
                                    "Tu as activé l'économiseur de batterie, qui désactive l'envoi de notifications."),
                            enabled: !settings.global.batterySaver,
                          ),
                          YSettingsTile.switchTile(
                            title: "Nouvelle note",
                            switchValue: settings.notifications.newGrade,
                            onSwitchValueChanged: (bool value) async =>
                                await notificationSetting(context, () => settings.notifications.newGrade = value),
                            disabledOnTap: () => YSnackbars.info(context,
                                title: "Paramètre désactivé",
                                message:
                                    "Tu as activé l'économiseur de batterie, qui désactive l'envoi de notifications."),
                            enabled: !settings.global.batterySaver,
                          )
                        ]);
                      }),
                YSettingsSection(title: "Divers", tiles: [
                  if (schoolApi.authModule.account!.isParent) const AccountSwitcherTile(),
                  const ThemeSwitcherTile()
                ])
              ],
            ),
            YVerticalSpacer(YScale.s6),
            Padding(
              padding: YPadding.px(YScale.s2),
              child: YButton(
                  onPressed: () async {
                    schoolApi.authModule.loginFromOffline();
                    // controller.loginController.login();
                    for (final module in schoolApi.modules) {
                      module.fetch();
                    }
                    // controller.api!.getEvents(DateTime.now(), forceReload: false);
                    // controller.gradesController.refresh(force: true);
                    // controller.homeworkController.refresh(force: true);
                    await KVS.write(key: "agreedTermsAndConfiguredApp", value: "true");
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  text: "C'EST PARTI !",
                  block: true),
            ),
          ],
        ));
  }
}
