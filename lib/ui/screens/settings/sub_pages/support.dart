import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: YScale.s2),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: theme.colors.danger.backgroundColor,
                                  borderRadius: YBorderRadius.xl),
                              padding: EdgeInsets.symmetric(
                                  vertical: YScale.s1p5, horizontal: YScale.s6),
                              child: Column(
                                children: [
                                  Text(
                                    LoginContent.login.endOfSupportFlag,
                                    style: theme.texts.body1.copyWith(
                                        color: theme
                                            .colors.danger.foregroundColor),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              )),
                        ),
                        YSettingsTile(
                            title: "Logs",
                            leading: MdiIcons.file,
                            onTap: () =>
                                Navigator.pushNamed(context, "/settings/logs")),
                      ]),
                    ])
                  ],
                )));
  }
}
