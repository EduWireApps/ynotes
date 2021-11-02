import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Paramètres"),
        body: ControllerConsumer<ApplicationSystem>(
            controller: appSys,
            builder: (context, controller, _) => YSettingsSections(sections: [
                  YSettingsSection(tiles: [
                    YSettingsTile(
                        title: "Compte",
                        leading: Icons.account_circle_rounded,
                        onTap: () => Navigator.pushNamed(context, "/settings/account")),
                    YSettingsTile(
                        title: "Notifications",
                        leading: Icons.notifications_rounded,
                        onTap: () => Navigator.pushNamed(context, "/settings/notifications")),
                    YSettingsTile(
                        title: "Assistance",
                        leading: Icons.support_rounded,
                        onTap: () => Navigator.pushNamed(context, "/settings/support")),
                    YSettingsTile(
                        title: "A propos",
                        leading: Icons.info_rounded,
                        onTap: () => Navigator.pushNamed(context, "/settings/about")),
                  ]),
                  YSettingsSection(title: "Divers", tiles: [
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
