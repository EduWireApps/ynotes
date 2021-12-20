import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
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
        body: ControllerConsumer<ApplicationSystem>(
            controller: appSys,
            builder: (context, controller, _) => Column(
                  children: [
                    ControllerConsumer<LoginController>(
                        controller: controller.loginController,
                        builder: (context, controller, _) => AccountLoginStatus(controller: controller)),
                    YVerticalSpacer(YScale.s4),
                    Container(
                      color: theme.colors.backgroundLightColor,
                      padding: YPadding.p(YScale.s4),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${controller.currentSchoolAccount?.name ?? ''} ${controller.currentSchoolAccount?.surname ?? ''}",
                            style: theme.texts.body1
                                .copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold),
                          ),
                          YVerticalSpacer(YScale.s1),
                          Text(
                            "${controller.currentSchoolAccount?.schoolName ?? ''} · ${controller.currentSchoolAccount?.studentClass ?? ''}",
                            style: theme.texts.body1.copyWith(color: theme.colors.foregroundLightColor),
                          ),
                        ],
                      ),
                    ),
                    YSettingsSections(sections: [
                      YSettingsSection(tiles: [
                        if ((controller.account?.managableAccounts?.length ?? 0) > 1)
                          YSettingsTile(
                              title: "Changer de compte",
                              subtitle: "${appSys.account!.managableAccounts!.length} disponibles",
                              onTap: () async {
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
                                  Phoenix.rebirth(context);
                                }
                              }),
                        YSettingsTile(
                          title: "Spécialités",
                          subtitle:
                              "Si tu es en classe de Première ou Terminale, sélectionner tes spécialités te permet d'avoir accès à des filtres supplémentaires",
                          onTap: () => CustomDialogs.showSpecialtiesChoice(context),
                        ),
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
                                await appSys.exitApp();
                                appSys.api = null;
                                appSys.buildControllers();
                                Phoenix.rebirth(context);
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
                                await controller.offline.clearAll();
                                controller.api = apiManager(controller.offline);
                              }
                            })
                      ]),
                    ])
                  ],
                )));
  }
}
