import 'package:flutter/material.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/services.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes/ui/screens/settings/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SettingsAccountPage extends StatefulWidget {
  const SettingsAccountPage({Key? key}) : super(key: key);

  @override
  _SettingsAccountPageState createState() => _SettingsAccountPageState();
}

class _SettingsAccountPageState extends State<SettingsAccountPage> {
  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Compte"),
        body: ChangeNotifierConsumer<AuthModule>(
            controller: schoolApi.authModule,
            builder: (context, module, _) => Column(
                  children: [
                    AccountLoginStatus(module),
                    YVerticalSpacer(YScale.s4),
                    Container(
                      color: theme.colors.backgroundLightColor,
                      padding: YPadding.p(YScale.s4),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module.schoolAccount?.fullName ?? "Aucun nom",
                            style: theme.texts.body1
                                .copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold),
                          ),
                          YVerticalSpacer(YScale.s1),
                          Text(
                            "${module.schoolAccount?.school ?? ''} · ${module.schoolAccount?.className ?? ''}",
                            style: theme.texts.body1.copyWith(color: theme.colors.foregroundLightColor),
                          ),
                        ],
                      ),
                    ),
                    YSettingsSections(sections: [
                      YSettingsSection(tiles: [
                        if (schoolApi.authModule.account?.isParent ?? false) const AccountSwitcherTile(),
                        YSettingsTile(
                            title: "Gérer les filtres de matières",
                            leading: Icons.sort_rounded,
                            onTap: () => Navigator.pushNamed(context, "/settings/filters")),
                      ]),
                      YSettingsSection(tiles: [
                        YSettingsTile(
                            title: "Se déconnecter",
                            color: YColor.danger,
                            onTap: () async {
                              final bool res = await YDialogs.getChoice(
                                  context,
                                  YChoiceDialog(
                                      color: YColor.danger,
                                      title: "Attention",
                                      body: Text(
                                          "Voulez-vous vraiment vous déconnecter ? Vos données hors lignes ainsi que vos paramètres seront supprimés. Cette action est irréversible.",
                                          style: theme.texts.body1)));
                              if (res) {
                                await SystemService.exit(context);
                              }
                            }),
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
                                          "Êtes-vous sûr de vouloir supprimer les données hors ligne ? Cette action est irréversible.",
                                          style: theme.texts.body1)));
                              if (res) {
                                await schoolApi.reset();
                              }
                            })
                      ]),
                    ])
                  ],
                )));
  }
}
