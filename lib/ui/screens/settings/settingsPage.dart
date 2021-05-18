import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/logic/appConfig/controller.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/services/platform.dart';
import 'package:ynotes/core/utils/settingsUtils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/accountPage.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/exportPage.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logsPage.dart';

import '../../../tests.dart';
import '../../../usefulMethods.dart';

bool? isFirstAvatarSelected;

final storage = new FlutterSecureStorage();
showExitDialog(BuildContext context) {
  // set up the AlertDialog
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ExitDialogWidget();
    },
  );
}

class ExitDialogWidget extends StatefulWidget {
  const ExitDialogWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ExitDialogWidgetState createState() => _ExitDialogWidgetState();
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _ExitDialogWidgetState extends State<ExitDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 50,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          "Confirmation",
          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
        ),
        content: Text(
          "Voulez vous vraiment vous deconnecter ?",
          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
        ),
        actions: [
          FlatButton(
            child: const Text(
              'ANNULER',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: const Text(
              'SE DECONNECTER',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              await appSys.exitApp();
              appSys.api!.gradesList!.clear();
              setState(() {
                appSys.api = null;
              });
              try {
                appSys.updateTheme("clair");
              } catch (e) {}
              Navigator.of(context).pushReplacement(router(login()));
            },
          )
        ]);
  }
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  late AnimationController leftToRightAnimation;
  late AnimationController rightToLeftAnimation;
  //Avatar's animations :
  Animation<double>? movingRow;
  //To use by the actual image when switching
  Animation<double>? avatarSize;

  //Disable new grades when battery saver is enabled
  bool? disableNotification;

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
//animation left to right

    return ChangeNotifierProvider<ApplicationSystem>.value(
      value: appSys,
      child: Consumer<ApplicationSystem>(builder: (context, _appSys, child) {
        return new Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              systemOverlayStyle: ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
              brightness: ThemeUtils.isThemeDark ? Brightness.dark : Brightness.light,
              backgroundColor: Theme.of(context).primaryColor,
              title: new Text("Paramètres"),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Theme(
              data: ThemeData(brightness: ThemeUtils.isThemeDark ? Brightness.dark : Brightness.light),
              child: SettingsList(
                backgroundColor: Theme.of(context).backgroundColor,
                darkBackgroundColor: Theme.of(context).backgroundColor,
                lightBackgroundColor: Theme.of(context).backgroundColor,
                contentPadding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
                sections: [
                  SettingsSection(
                    title: 'Mon compte',
                    titleTextStyle: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                    tiles: [
                      SettingsTile(
                          title: 'Compte actuellement connecté',
                          titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                          subtitleTextStyle: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.isThemeDark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black.withOpacity(0.7)),
                          subtitle: '${appSys.currentSchoolAccount?.name ?? "Invité"}',
                          leading: Icon(MdiIcons.account, color: ThemeUtils.textColor()),
                          trailing: Icon(Icons.chevron_right, color: ThemeUtils.textColor()),
                          onPressed: (context) {
                            Navigator.of(context).push(router(AccountPage()));
                          },
                          iosChevron: Icon(Icons.chevron_right)),
                    ],
                  ),
                  SettingsSection(
                    title: 'Apparence/Comportement',
                    titleTextStyle: TextStyle(color: ThemeUtils.textColor()),
                    tiles: [
                      SettingsTile.switchTile(
                        title: 'Mode nuit',
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        leading: Icon(MdiIcons.themeLightDark, color: ThemeUtils.textColor()),
                        switchValue: ThemeUtils.isThemeDark,
                        onToggle: (value) async {
                          _appSys.updateTheme(value ? "sombre" : "clair");
                        },
                      ),
                      SettingsTile.switchTile(
                        title: 'Economiseur de batterie',
                        subtitle: "Réduit les interactions reseaux",
                        titleTextStyle: TextStyle(
                          fontFamily: "Asap",
                          color: ThemeUtils.textColor(),
                        ),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        leading: Icon(MdiIcons.batteryHeart, color: ThemeUtils.textColor()),
                        switchValue: _appSys.settings!["user"]["global"]["batterySaver"],
                        onToggle: (value) async {
                          _appSys.updateSetting(_appSys.settings!["user"]["global"], "batterySaver", value);
                        },
                      ),
                      SettingsTile.switchTile(
                        title: 'Fermeture du menu coulissant',
                        subtitle: "Fermer le menu coulissant après avoir sélectionné une page",
                        titleTextStyle: TextStyle(
                          fontFamily: "Asap",
                          color: ThemeUtils.textColor(),
                        ),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        leading: Icon(MdiIcons.arrowCollapseLeft, color: ThemeUtils.textColor()),
                        switchValue: _appSys.settings!["user"]["global"]["autoCloseDrawer"],
                        onToggle: (value) async {
                          _appSys.updateSetting(_appSys.settings!["user"]["global"], "autoCloseDrawer", value);
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Notifications',
                    titleTextStyle: TextStyle(color: ThemeUtils.textColor()),
                    tiles: [
                      SettingsTile.switchTile(
                        title: 'Notification de nouveau mail',
                        enabled: !_appSys.settings!["user"]["global"]["batterySaver"],
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        switchValue: _appSys.settings!["user"]["global"]["notificationNewMail"],
                        onToggle: (bool value) async {
                          if (Platform.isIOS ||
                              value == false ||
                              (await Permission.ignoreBatteryOptimizations.isGranted) ||
                              Platform.isIOS) {
                            _appSys.updateSetting(_appSys.settings!["user"]["global"], "notificationNewMail", value);
                          } else {
                            if (await CustomDialogs.showAuthorizationsDialog(
                                    context,
                                    "la configuration d'optimisation de batterie",
                                    "Pouvoir s'exécuter en arrière plan sans être automatiquement arrêté par Android.") ??
                                false) {
                              if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
                                _appSys.updateSetting(
                                    _appSys.settings!["user"]["global"], "notificationNewMail", value);
                              }
                            }
                          }
                        },
                      ),
                      SettingsTile.switchTile(
                        title: 'Notification de nouvelle note',
                        enabled: !_appSys.settings!["user"]["global"]["batterySaver"],
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        switchValue: _appSys.settings!["user"]["global"]["notificationNewGrade"],
                        onToggle: (bool value) async {
                          if (Platform.isIOS ||
                              value == false ||
                              (await Permission.ignoreBatteryOptimizations.isGranted)) {
                            _appSys.updateSetting(_appSys.settings!["user"]["global"], "notificationNewGrade", value);
                          } else {
                            if (await CustomDialogs.showAuthorizationsDialog(
                                    context,
                                    "la configuration d'optimisation de batterie",
                                    "Pouvoir s'exécuter en arrière plan sans être automatiquement arrêté par Android.") ??
                                false) {
                              if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
                                _appSys.updateSetting(
                                    _appSys.settings!["user"]["global"], "notificationNewGrade", value);
                              }
                            }
                          }
                        },
                      ),
                      if (!Platform.isIOS)
                        SettingsTile(
                          title: 'Je ne reçois pas de notifications',
                          leading: Icon(MdiIcons.bellAlert, color: ThemeUtils.textColor()),
                          onTap: () async {
                            //Check battery optimization setting
                            if (!await Permission.ignoreBatteryOptimizations.isGranted &&
                                await CustomDialogs.showAuthorizationsDialog(
                                    context,
                                    "la configuration d'optimisation de batterie",
                                    "Pouvoir s'exécuter en arrière plan sans être automatiquement arrêté par Android.")) {
                              await Permission.ignoreBatteryOptimizations.request().isGranted;
                            }

                            if (await CustomDialogs.showAuthorizationsDialog(
                                    context,
                                    "la liste blanche de lancement en arrière plan / démarrage",
                                    "Pouvoir lancer yNotes au démarrage de l'appareil et ainsi régulièrement rafraichir en arrière plan.") ??
                                false) {
                              await AndroidPlatformChannel.openAutoStartSettings();
                            }
                            await AppNotification.showDebugNotification();
                            Flushbar(
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              backgroundColor: Colors.orange.shade200,
                              duration: Duration(seconds: 10),
                              isDismissible: true,
                              margin: EdgeInsets.all(8),
                              messageText: Text(
                                "Toujours pas de notifications ?",
                                style: TextStyle(fontFamily: "Asap"),
                              ),
                              mainButton: FlatButton(
                                onPressed: () {
                                  const url = 'https://ynotes.fr/help/notifications';
                                  launchURL(url);
                                },
                                child: Text(
                                  "Aide liée aux notifications",
                                  style: TextStyle(color: Colors.blue, fontFamily: "Asap"),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            )..show(context);
                          },
                          titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                          subtitleTextStyle: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.isThemeDark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black.withOpacity(0.7)),
                        ),
                    ],
                  ),
                  SettingsSection(
                    titleTextStyle: TextStyle(color: ThemeUtils.textColor()),
                    title: 'Paramètres scolaires',
                    tiles: [
                      SettingsTile(
                        title: 'Choisir mes spécialités',
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        leading: Icon(MdiIcons.formatListBulleted, color: ThemeUtils.textColor()),
                        iosChevron: Icon(Icons.chevron_right),
                        onTap: () {
                          CustomDialogs.showSpecialtiesChoice(context);
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    titleTextStyle: TextStyle(color: ThemeUtils.textColor()),
                    title: 'Assistance',
                    tiles: [
                      SettingsTile(
                        title: 'Afficher les logs',
                        leading: Icon(MdiIcons.bug, color: ThemeUtils.textColor()),
                        onTap: () {
                          Navigator.of(context).push(router(LogsPage()));
                        },
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        iosChevron: Icon(Icons.chevron_right),
                      ),
                      SettingsTile(
                        title: 'Signaler un bug',
                        subtitle: 'Ou nous recommander quelque chose',
                        leading: Icon(MdiIcons.commentAlert, color: ThemeUtils.textColor()),
                        onTap: () {
                          Wiredash.of(context)?.show();
                        },
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        iosChevron: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  SettingsSection(
                    titleTextStyle: TextStyle(color: ThemeUtils.textColor()),
                    title: 'Autres paramètres',
                    tiles: [
                      SettingsTile(
                        title: 'Gestionnaire de sauvegarde',
                        leading: Icon(MdiIcons.contentSave, color: ThemeUtils.textColor()),
                        onTap: () async {
                          Navigator.of(context).push(router(ExportPage()));
                        },
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        iosChevron: Icon(Icons.chevron_right),
                      ),
                      SettingsTile(
                        title: 'Réinitialiser le tutoriel',
                        leading: Icon(MdiIcons.restore, color: ThemeUtils.textColor()),
                        onTap: () async {
                          if ((await CustomDialogs.showConfirmationDialog(context, null,
                                  alternativeText: "Etes-vous sûr de vouloir réinitialiser le tutoriel ?",
                                  alternativeButtonConfirmText: "confirmer")) ??
                              false) {
                            await HelpDialog.resetEveryHelpDialog();
                          }
                          HelpDialog.resetEveryHelpDialog();
                        },
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        iosChevron: Icon(Icons.chevron_right),
                      ),
                      SettingsTile(
                        title: 'Supprimer les données hors ligne',
                        leading: Icon(MdiIcons.deleteAlert, color: ThemeUtils.textColor()),
                        onTap: () async {
                          if ((await CustomDialogs.showConfirmationDialog(context, null,
                                  alternativeText:
                                      "Etes-vous sûr de vouloir supprimer les données hors ligne ? (irréversible)")) ??
                              false) {
                            await _appSys.offline.clearAll();
                          }
                        },
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        iosChevron: Icon(Icons.chevron_right),
                      ),
                      SettingsTile(
                        title: 'Note de mise à jour',
                        leading: Icon(MdiIcons.file, color: ThemeUtils.textColor()),
                        onTap: () async {
                          CustomDialogs.showUpdateNoteDialog(context);
                        },
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        iosChevron: Icon(Icons.chevron_right),
                      ),
                      SettingsTile(
                        title: 'Forcer la restauration des anciens paramètres',
                        leading: Icon(MdiIcons.emoticonConfused, color: ThemeUtils.textColor()),
                        onTap: () async {
                          var temp = await SettingsUtils.forceRestoreOldSettings();
                          setState(() {
                            appSys.settings = temp;
                          });
                          CustomDialogs.showAnyDialog(context, "Anciens paramètres restaurés.");
                        },
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                        iosChevron: Icon(Icons.chevron_right),
                      ),
                      SettingsTile(
                        title: 'A propos de cette application',
                        leading: Icon(MdiIcons.information, color: ThemeUtils.textColor()),
                        iosChevron: Icon(Icons.chevron_right),
                        onTap: () async {
                          PackageInfo packageInfo = await PackageInfo.fromPlatform();

                          showAboutDialog(
                              context: this.context,
                              applicationIcon: Image(
                                image: AssetImage('assets/appico/foreground.png'),
                                width: screenSize.size.width / 5 * 0.7,
                              ),
                              applicationName: "yNotes",
                              applicationVersion:
                                  packageInfo.version + "+" + packageInfo.buildNumber + " T" + Tests.testVersion,
                              applicationLegalese:
                                  "Developpé avec amour en France.\nAPI Pronote adaptée à l'aide de l'API pronotepy développée par Bain sous licence MIT.\nJe remercie la participation des bêta testeurs et des développeurs ayant participé au développement de l'application.");
                        },
                        titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                        subtitleTextStyle: TextStyle(
                            fontFamily: "Asap",
                            color:
                                ThemeUtils.isThemeDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                      ),
                      if (!kReleaseMode)
                        SettingsTile(
                          title: 'Bouton magique',
                          leading: Icon(MdiIcons.testTube, color: ThemeUtils.textColor()),
                          onTap: () async {
                            await Future.delayed(Duration(seconds: 5), () => "1");
                            await AppNotification.cancelNotification(0);
                          },
                          titleTextStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                          subtitleTextStyle: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.isThemeDark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black.withOpacity(0.7)),
                          iosChevron: Icon(Icons.chevron_right),
                        ),
                    ],
                  ),
                ],
              ),
            ));
      }),
    );
  }

  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction
    leftToRightAnimation.dispose();
    rightToLeftAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      isFirstAvatarSelected = true;
    });
    super.initState();
    leftToRightAnimation = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    rightToLeftAnimation = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
  }
}
