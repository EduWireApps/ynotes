import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/utils/bugreport_utils.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';

class SettingsSupportPage extends StatefulWidget {
  const SettingsSupportPage({Key? key}) : super(key: key);

  @override
  _SettingsSupportPageState createState() => _SettingsSupportPageState();
}

class _SettingsSupportPageState extends State<SettingsSupportPage> {
  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Assistance"),
        body: ControllerConsumer<ApplicationSystem>(
            controller: appSys,
            builder: (context, controller, _) => Column(
                  children: [
                    YSettingsSections(sections: [
                      YSettingsSection(tiles: [
                        YSettingsTile.switchTile(
                            title: "Secouer pour signaler",
                            switchValue: controller.settings.user.global.shakeToReport,
                            onSwitchValueChanged: (bool value) async {
                              controller.settings.user.global.shakeToReport = value;
                              await appSys.saveSettings();
                              BugReportUtils.updateShakeFeatureStatus();
                            }),
                        YSettingsTile(
                            title: "Logs",
                            leading: MdiIcons.file,
                            onTap: () => Navigator.pushNamed(context, "/settings/logs")),
                      ]),
                    ])
                  ],
                )));
  }
}
