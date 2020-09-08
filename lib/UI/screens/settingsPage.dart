import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/logsPage.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import '../../usefulMethods.dart';
import 'package:dio/src/response.dart' as dioResponse;
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

bool isFirstAvatarSelected;
final storage = new FlutterSecureStorage();

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  //Settings
  var boolSettings = {"nightmode": false, "batterySaver": false, "notificationNewMail": false, "notificationNewGrade": false, "lighteningOverride": false};

  AnimationController leftToRightAnimation;
  AnimationController rightToLeftAnimation;
  //Avatar's animations :
  Animation<double> movingRow;
  //To use by the actual image when switching
  Animation<double> avatarSize;

  //Disable new grades when battery saver is enabled
  bool disableNotification;
  @override
  void initState() {
    setState(() {
      isFirstAvatarSelected = true;
    });
    getUsername();
    getSettings();
    super.initState();
    leftToRightAnimation = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    rightToLeftAnimation = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
  }

  void getSettings() async {
    await Future.forEach(boolSettings.keys, (key) async {
      var value = await getSetting(key);
      setState(() {
        boolSettings[key] = value;
      });
    });
  }

  void getUsername() async {
    var actualUserAsync = await ReadStorage("userFullName");
    setState(() {
      actualUser = actualUserAsync;
    });
  }

  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction
    leftToRightAnimation.dispose();
    rightToLeftAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
//animation left to right

    return new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: new Text("Paramètres"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SettingsList(
          backgroundColor: Theme.of(context).backgroundColor,
          sections: [
            SettingsSection(
              title: 'Mon compte',
              tiles: [
                SettingsTile(
                  title: 'Compte actuellement connecté',
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                  subtitle: '${actualUser.length > 0 ? actualUser : "Invité"}',
                  leading: Icon(MdiIcons.account, color: isDarkModeEnabled ? Colors.white : Colors.black),
                  onTap: () {},
                ),
                SettingsTile(
                  title: 'Déconnexion',
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: Colors.red),
                  leading: Icon(
                    MdiIcons.logout,
                    color: Colors.red,
                  ),
                  onTap: () {
                    showExitDialog(context);
                  },
                )
              ],
            ),
            SettingsSection(
              title: 'Apparence/Comportement',
              tiles: [
                SettingsTile.switchTile(
                  title: 'Mode nuit',
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                  leading: Icon(MdiIcons.themeLightDark, color: isDarkModeEnabled ? Colors.white : Colors.black),
                  switchValue: boolSettings["nightmode"],
                  onToggle: (value) async {
                    setState(() {
                      Provider.of<AppStateNotifier>(context, listen: false).updateTheme(value);
                      boolSettings["nightmode"] = value;
                    });

                    await setSetting("nightmode", value);
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Economiseur de batterie',
                  subtitle: "Réduit les interactions reseaux",
                  titleTextStyle: TextStyle(
                    fontFamily: "Asap",
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                  ),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                  leading: Icon(MdiIcons.batteryHeart, color: isDarkModeEnabled ? Colors.white : Colors.black),
                  switchValue: boolSettings["batterySaver"],
                  onToggle: (value) async {
                    setState(() {
                      boolSettings["batterySaver"] = value;
                    });

                    await setSetting("batterySaver", value);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Notifications',
              tiles: [
                SettingsTile.switchTile(
                  title: 'Notification de nouveau mail',
                  enabled: !boolSettings["batterySaver"],
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                  switchValue: boolSettings["notificationNewMail"],
                  onToggle: (bool value) async {
                    setState(() {
                      boolSettings["notificationNewMail"] = value;
                    });

                    await setSetting("notificationNewMail", value);
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Notification de nouvelle note',
                  enabled: !boolSettings["batterySaver"],
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                  switchValue: boolSettings["notificationNewGrade"],
                  onToggle: (bool value) async {
                    setState(() {
                      boolSettings["notificationNewGrade"] = value;
                    });

                    await setSetting("notificationNewGrade", value);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Paramètres scolaires',
              tiles: [
                SettingsTile(
                  title: 'Choisir mes spécialités',
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                  leading: Icon(MdiIcons.formatListBulleted, color: isDarkModeEnabled ? Colors.white : Colors.black),
                  onTap: () {
                    CustomDialogs.showSpecialtiesChoice(context);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Assistance',
              tiles: [
                SettingsTile(
                  title: 'Afficher les logs',
                  leading: Icon(MdiIcons.bug, color: isDarkModeEnabled ? Colors.white : Colors.black),
                  onTap: () {
                    Navigator.of(context).push(router(LogsPage()));
                  },
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                ),
                SettingsTile(
                  title: 'Signaler un bug',
                  subtitle: 'Ou nous recommander quelque chose',
                  leading: Icon(MdiIcons.commentAlert, color: isDarkModeEnabled ? Colors.white : Colors.black),
                  onTap: () {
                    Wiredash.of(context).show();
                  },
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                ),
              ],
            ),
            SettingsSection(
              title: 'Autres paramètres',
              tiles: [
                SettingsTile(
                  title: 'Réinitialiser le tutoriel',
                  leading: Icon(MdiIcons.restore, color: isDarkModeEnabled ? Colors.white : Colors.black),
                  onTap: () {
                    HelpDialog.resetEveryHelpDialog();
                  },
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                ),
                SettingsTile(
                  title: 'A propos de cette application',
                  leading: Icon(MdiIcons.information, color: isDarkModeEnabled ? Colors.white : Colors.black),
                  onTap: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();

                    showAboutDialog(
                        context: this.context,
                        applicationIcon: Image(
                          image: AssetImage('assets/appico/foreground.png'),
                          width: screenSize.size.width / 5 * 0.7,
                        ),
                        applicationName: "yNotes",
                        applicationVersion: packageInfo.version + "+" + packageInfo.buildNumber,
                        applicationLegalese: "Developpé avec amour en France.\nAPI Pronote adaptée à l'aide de l'API pronotepy développée par Bain sous licence MIT.\nJe remercie la participation des bêta testeurs et des développeurs ayant participé au développement de l'application.");
                  },
                  titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                  subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                ),
                if (!kReleaseMode)
                  SettingsTile(
                    title: 'Bouton magique',
                    leading: Icon(MdiIcons.testTube, color: isDarkModeEnabled ? Colors.white : Colors.black),
                    onTap: () async {
                      await localApi.getNextHomework(forceReload: true);
                    },
                    titleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                    subtitleTextStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                  ),
              ],
            ),
          ],
        ));
  }
}

showExitDialog(BuildContext context) {
  // set up the AlertDialog
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          elevation: 50,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
            "Confirmation",
            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
          ),
          content: Text(
            "Voulez vous vraiment vous deconnecter ?",
            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
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
                await exitApp();
                try {
                  Provider.of<AppStateNotifier>(context, listen: false).updateTheme(false);
                } catch (e) {}
                Navigator.of(context).pushReplacement(router(login()));
              },
            )
          ]);
    },
  );
}
