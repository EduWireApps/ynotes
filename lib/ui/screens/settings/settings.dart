import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/offline.dart';
import 'package:ynotes/core/utilities.dart';

import 'package:ynotes/core/services.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes/core/api.dart';

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
        body: ChangeNotifierConsumer<Settings>(
            controller: SettingsService.settings,
            builder: (context, settings, _) => YSettingsSections(sections: [
                  YSettingsSection(tiles: [
                    YSettingsTile(
                        title: "Compte",
                        leading: Icons.account_circle_rounded,
                        onTap: () =>
                            Navigator.pushNamed(context, "/settings/account")),
                    YSettingsTile(
                      title: "Notifications",
                      leading: Icons.notifications_rounded,
                      onTap: () => Navigator.pushNamed(
                          context, "/settings/notifications"),
                      enabled: false,
                      disabledOnTap: () => YSnackbars.info(context,
                          message:
                              "Notifications indisponibles pour le moment"),
                    ),
                    YSettingsTile(
                        title: "Assistance",
                        leading: Icons.support_rounded,
                        onTap: () =>
                            Navigator.pushNamed(context, "/settings/support")),
                  ]),
                  YSettingsSection(title: "Divers", tiles: [
                    const ThemeSwitcherTile(),
                    YSettingsTile.switchTile(
                      title: "Economiseur de batterie",
                      subtitle:
                          "Réduit les interactions réseaux, désactive les notifications.",
                      switchValue: settings.global.batterySaver,
                      onSwitchValueChanged: (bool value) async {
                        settings.global.batterySaver = value;
                        await SettingsService.update();
                      },
                    ),
                  ]),
                  YSettingsSection(title: "Informations", tiles: [
                    YSettingsTile(
                        title: "Note de mise à jour",
                        leading: MdiIcons.file,
                        onTap: () => UIU.showPatchNotes(context, force: true)),
                    YSettingsTile(
                      title: "A propos de cette application",
                      leading: Icons.info_rounded,
                      onTap: () => AppDialogs.showAboutDialog(context),
                    ),
                    YSettingsTile(
                      title: "Donateurs",
                      leading: FontAwesomeIcons.handHoldingUsd,
                      onTap: () =>
                          Navigator.pushNamed(context, "/settings/donors"),
                    ),
                  ]),
                  if (!kReleaseMode)
                    YSettingsSection(title: "[DEV ONLY]", tiles: [
                      YSettingsTile(
                          title: "Send notification 0",
                          onTap: () async {
                            await NotificationService.show(GradeNotification(
                                grade: schoolApi.gradesModule.grades.last,
                                subjects: schoolApi.gradesModule.subjects));
                          }),
                      YSettingsTile(
                          title: "Open error page",
                          onTap: () => Navigator.pushNamed(context, "")),
                      YSettingsTile(
                          title: "Clear subject filters",
                          onTap: () {
                            Offline.isar.writeTxnSync(
                                (isar) => isar.subjectsFilters.clearSync());
                          }),
                      YSettingsTile(
                          title: "Secure Logger",
                          subtitle: "Print secure logger categories",
                          onTap: () async {
                            Logger.log("Test", "test");
                            Logger.log("SECURE LOGGER",
                                "Categories: ${LogsManager.categories()}");
                          }),
                    ])
                ])));
  }
}
