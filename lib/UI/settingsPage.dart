import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import '../usefulMethods.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

bool isFirstAvatarSelected;
final storage = new FlutterSecureStorage();

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  AnimationController leftToRightAnimation;
  AnimationController rightToLeftAnimation;
  //Avatar's animations :
  Animation<double> movingRow;
  //To use by the actual image when switching
  Animation<double> avatarSize;
  //Disable new grades when battery saver is enabled
  bool disableNewGradesNotification;
  @override
  void initState() {
    setState(() {
      isFirstAvatarSelected = true;
    });

    super.initState();
    leftToRightAnimation =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    rightToLeftAnimation =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    getActualUser();
  }

  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction
    leftToRightAnimation.dispose();
    rightToLeftAnimation.dispose();
    super.dispose();
  }

  getActualUser() async {
    String toGet = await storage.read(key: "userFullName");
    if (toGet != null) {
      setState(() {
        actualUser = toGet;
        actualUser =
            '${actualUser[0].toUpperCase()}${actualUser.toLowerCase().substring(1)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(actualUser);

    MediaQueryData screenSize = MediaQuery.of(context);
//animation left to right

    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: new AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: new Text("Paramètres"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              Center(
                  child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ///Always the first avatar
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.lightGreen,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          if (!isFirstAvatarSelected) {
                            setState(() {
                              isFirstAvatarSelected = true;
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Text(
                            '${actualUser[0]}',
                            style: TextStyle(
                                fontSize: screenSize.size.width / 5 * 0.4,
                                color: isDarkModeEnabled
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          radius: (isFirstAvatarSelected
                              ? screenSize.size.width / 5 * 0.55
                              : screenSize.size.width / 5 * 0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Center(
                  child: Container(
                      margin: EdgeInsets.only(
                          top: screenSize.size.height / 10 * 0.1,
                          bottom: screenSize.size.height / 10 * 0.2),
                      child: Text("Bonjour $actualUser",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: screenSize.size.height / 10 * 0.3)))),
              FutureBuilder(
                  future: getSetting("nightmode"),
                  initialData: false,
                  builder: (context, snapshot) {
                    return SwitchListTile(
                      value: snapshot.data,
                      title: Text("Mode nuit",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: screenSize.size.height / 10 * 0.3)),
                      subtitle: Text(
                        "Lisez vos notes de jour comme de nuit.",
                        style: TextStyle(
                            fontFamily: "Asap",
                            color:
                                isDarkModeEnabled ? Colors.white : Colors.black,
                            fontSize: screenSize.size.height / 10 * 0.2),
                      ),
                      onChanged: (value) {
                        setState(() {
                          Provider.of<AppStateNotifier>(context, listen: false)
                              .updateTheme(value);
                          setSetting("nightmode", value);
                        });
                      },
                      secondary: Icon(
                        Icons.lightbulb_outline,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                      ),
                    );
                  }),
              Divider(),
              FutureBuilder(
                  future: getSetting("batterySaver"),
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      setSetting("notificationNewGrade", false);
                      disableNewGradesNotification = true;
                    } else {
                      disableNewGradesNotification = false;
                    }
                    return SwitchListTile(
                      value: snapshot.data,
                      title: Text("Economie de données",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: screenSize.size.height / 10 * 0.3)),
                      subtitle: Text(
                        "Réduit les interactions réseaux au minimum pour sauver vos 15 pourcents restants.",
                        style: TextStyle(
                            fontFamily: "Asap",
                            color:
                                isDarkModeEnabled ? Colors.white : Colors.black,
                            fontSize: screenSize.size.height / 10 * 0.2),
                      ),
                      onChanged: (value) {
                        setState(() {
                          setSetting("batterySaver", value);

                          //disable the notificationNewGrade because it can't work with the battery saver enabled
                          if (value == true) {
                            setSetting("notificationNewGrade", false);
                            disableNewGradesNotification = true;
                          } else {
                            disableNewGradesNotification = false;
                          }
                        });
                      },
                      secondary: Icon(
                        Icons.battery_charging_full,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                      ),
                    );
                  }),
              Divider(),
              FutureBuilder(
                  future: getSetting("notificationNewGrade"),
                  initialData: false,
                  builder: (context, snapshot) {
                    return SwitchListTile(
                      value: snapshot.data,
                      title: Text(
                        "Notification de nouvelle note",
                        style: TextStyle(
                            fontFamily: "Asap",
                            color:
                                isDarkModeEnabled ? Colors.white : Colors.black,
                            fontSize: screenSize.size.height / 10 * 0.3),
                      ),
                      subtitle: Text(
                        (disableNewGradesNotification == true
                            ? "Ne peut fonctionner si l'économie de données est activée"
                            : ""),
                        style: TextStyle(
                            fontFamily: "Asap", color: Colors.red.shade700),
                      ),
                      onChanged: (disableNewGradesNotification == true)
                          ? null
                          : (value) {
                              setState(() {
                                setSetting("notificationNewGrade", value);
                              });
                            },
                      secondary: Icon(
                        MdiIcons.newBox,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                      ),
                    );
                  }),
              Divider(),
              ListTile(
                leading: Icon(
                  MdiIcons.selection,
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                ),
                title: Text(
                  "Mes spécialités",
                  style: TextStyle(
                      fontFamily: "Asap",
                      color: isDarkModeEnabled ? Colors.white : Colors.black,
                      fontSize: screenSize.size.height / 10 * 0.3),
                ),
                onTap: () {
                  showSpecialtiesChoice(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  MdiIcons.commentQuestion,
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                ),
                title: Text(
                  "A propos",
                  style: TextStyle(
                      fontFamily: "Asap",
                      color: isDarkModeEnabled ? Colors.white : Colors.black,
                      fontSize: screenSize.size.height / 10 * 0.3),
                ),
                onTap: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();

                  showAboutDialog(
                      context: this.context,
                      applicationIcon: Image(
                        image: AssetImage('assets/appico/foreground.png'),
                        width: screenSize.size.width / 5 * 0.7,
                      ),
                      applicationName: "yNotes",
                      applicationVersion: packageInfo.version,
                      applicationLegalese: "Developpé avec amour en France");
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  MdiIcons.exitRun,
                  color: Colors.red.shade300,
                ),
                title: Text(
                  "Se déconnecter",
                  style: TextStyle(
                      fontFamily: "Asap",
                      color: Colors.red.shade300,
                      fontSize: screenSize.size.height / 10 * 0.3),
                ),
                onTap: () async {
                  showExitDialog(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DialogSpecialties extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _DialogSpecialtiesState();
  }
}

class _DialogSpecialtiesState extends State<DialogSpecialties> {
  List chosenSpecialties = List();
  var classe;

  getChosenSpecialties() async {
    var other = await specialtiesSelectionAvailable();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("listSpecialties") != null) {
      setState(() {
        chosenSpecialties = prefs.getStringList("listSpecialties");
        classe = other;
      });
    }
  }

  setChosenSpecialties() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("listSpecialties", chosenSpecialties);
    print(prefs.getStringList("listSpecialties"));
  }

  initState() {
    super.initState();
    getChosenSpecialties();
  }

  Widget build(BuildContext context) {
    API api = APIManager();
    List disciplines = List();

    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height / 10 * 4,
      child: FutureBuilder(
          future: api.getGrades(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data
                  .where((element) => element.periode == "0")
                  .forEach((element) {
                disciplines.add(element.nomDiscipline);
              });

              return AlertDialog(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  contentPadding: EdgeInsets.only(top: 10.0),
                  content: Container(
                      height: screenSize.size.height / 10 * 4,
                      width: screenSize.size.width / 5 * 4,
                      child: Center(
                          child: ListView.builder(
                        itemCount: disciplines.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.size.height / 10 * 0.2,
                            ),
                            child: Row(
                              children: <Widget>[
                                CircularCheckBox(
                                  inactiveColor: isDarkModeEnabled
                                      ? Colors.white
                                      : Colors.black,
                                  onChanged: (value) {
                                    if (chosenSpecialties
                                        .contains(disciplines[index])) {
                                      setState(() {
                                        chosenSpecialties.removeWhere(
                                            (element) =>
                                                element == disciplines[index]);
                                      });
                                      print(chosenSpecialties);
                                      setChosenSpecialties();
                                    } else {
                                      if (chosenSpecialties.length <
                                          (classe[1] == "Première" ? 3 : 2)) {
                                        setState(() {
                                          chosenSpecialties
                                              .add(disciplines[index]);
                                        });
                                        setChosenSpecialties();
                                      }
                                    }
                                  },
                                  value: chosenSpecialties
                                      .contains(disciplines[index]),
                                ),
                                Text(
                                  disciplines[index],
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      color: isDarkModeEnabled
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ],
                            ),
                          );
                        },
                      ))));
            } else {
              return SpinKitFadingFour(
                color: Theme.of(context).primaryColorDark,
                size: screenSize.size.width / 5 * 1,
              );
            }
          }),
    );
  }
}

showSpecialtiesChoice(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        MediaQueryData screenSize;
        screenSize = MediaQuery.of(context);
        return Container(child: DialogSpecialties());
      });
}

showExitDialog(BuildContext context) {
  // set up the AlertDialog
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          elevation: 50,
          backgroundColor: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
            "Confirmation",
            style: TextStyle(
                fontFamily: "Asap",
                color: isDarkModeEnabled ? Colors.white : Colors.black),
          ),
          content: Text(
            "Voulez vous vraiment vous deconnecter ?",
            style: TextStyle(
                fontFamily: "Asap",
                color: isDarkModeEnabled ? Colors.white : Colors.black),
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
                await exit();
                Navigator.of(context).pushReplacement(router(login()));
              },
            )
          ]);
    },
  );
}
