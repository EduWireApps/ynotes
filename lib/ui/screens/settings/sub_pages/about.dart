import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/tests.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/utilities.dart';

class SettingsAboutPage extends StatefulWidget {
  const SettingsAboutPage({Key? key}) : super(key: key);

  @override
  _SettingsAboutPageState createState() => _SettingsAboutPageState();
}

class _SettingsAboutPageState extends State<SettingsAboutPage> {
  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "A propos"),
        body: ControllerConsumer<ApplicationSystem>(
            controller: appSys,
            builder: (context, controller, _) => Column(
                  children: [
                    YSettingsSections(sections: [
                      YSettingsSection(tiles: [
                        YSettingsTile(
                          title: "Note de mise à jour",
                          leading: MdiIcons.file,
                          onTap: () => CustomDialogs.showUpdateNoteDialog(context),
                        ),
                        YSettingsTile(
                          title: "A propos de cette application",
                          leading: Icons.info_rounded,
                          onTap: () async {
                            final PackageInfo packageInfo = await PackageInfo.fromPlatform();
                            // TODO: rework the about dialog
                            showAboutDialog(
                                context: this.context,
                                applicationIcon: Image(
                                  image: const AssetImage('assets/appico/foreground.png'),
                                  width: YScale.s12,
                                ),
                                applicationName: "yNotes",
                                applicationVersion:
                                    packageInfo.version + "+" + packageInfo.buildNumber + " T" + Tests.testVersion,
                                applicationLegalese:
                                    "Developpé avec amour en France.\nAPI Pronote adaptée à l'aide de l'API pronotepy développée par Bain sous licence MIT.\nJe remercie la participation des bêta testeurs et des développeurs ayant participé au développement de l'application.");
                          },
                        ),
                      ]),
                    ])
                  ],
                )));
  }
}
