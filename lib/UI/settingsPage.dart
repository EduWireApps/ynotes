import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../usefulMethods.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

bool isFirstAvatarSelected;

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  AnimationController leftToRightAnimation;
  AnimationController rightToLeftAnimation;
  //Avatar's animations :
  Animation<double> movingRow;
  //To use by the actual image when switching
  Animation<double> avatarSize;

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
    actualUser = '${actualUser[0].toUpperCase()}${actualUser.toLowerCase().substring(1)}';
    MediaQueryData screenSize = MediaQuery.of(context);
//animation left to right
    setLtr() {
      movingRow = Tween<double>(
              begin: -(screenSize.size.width / 5 * 0.55 / 2) +
                  screenSize.size.width / 5 * 0.2,
              end: ((screenSize.size.width / 5 * 0.55 / 2) +
                  screenSize.size.width / 5 * 0.2))
          .animate(
              CurvedAnimation(parent: leftToRightAnimation, curve: Curves.ease))
            ..addListener(() {
              // Empty setState because the updated value is already in the animation field
              setState(() {});
            });
    }

    //Animation right to left
    setRtl() {
      movingRow = Tween<double>(
              begin: (screenSize.size.width / 5 * 0.55 / 2) +
                  screenSize.size.width / 5 * 0.2,
              end: -((screenSize.size.width / 5 * 0.55 / 2) +
                  screenSize.size.width / 5 * 0.21))
          .animate(
              CurvedAnimation(parent: rightToLeftAnimation, curve: Curves.ease))
            ..addListener(() {
              // Empty setState because the updated value is already in the animation field
              setState(() {});
            });
    }

    if (isFirstAvatarSelected) {
      setLtr();
      leftToRightAnimation.forward();
    } else {
      setRtl();

      rightToLeftAnimation.forward();
    }

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
              Center(
                  child: Center(
                child: Transform.translate(
                  offset: Offset(movingRow.value, 0),
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
                      SizedBox(
                        width: screenSize.size.width / 5 * 0.2,
                      ),

                      ///Always the second avatar avatar
                      Material(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xff404040),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            if (isFirstAvatarSelected) {
                              setState(() {
                                isFirstAvatarSelected = false;
                              });
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              '+',
                              style: TextStyle(
                                  fontSize: screenSize.size.width / 5 * 0.4,
                                  color: isDarkModeEnabled
                                      ? Colors.white
                                      : Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            radius: (!isFirstAvatarSelected
                                ? screenSize.size.width / 5 * 0.55
                                : screenSize.size.width / 5 * 0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                              color:
                                  isDarkModeEnabled ? Colors.white : Colors.black,
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
                              color:
                                  isDarkModeEnabled ? Colors.white : Colors.black,
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
                    return SwitchListTile(
                      value: snapshot.data,
                      title: Text("Economie de données",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color:
                                  isDarkModeEnabled ? Colors.white : Colors.black,
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
                      
                      onChanged: (value) {
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
                  ListTile(leading: Icon(
                        MdiIcons.commentQuestion,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                      ), title: Text(
                        "A propos",
                        style: TextStyle(
                            fontFamily: "Asap",
                            color:
                                isDarkModeEnabled ? Colors.white : Colors.black,
                            fontSize: screenSize.size.height / 10 * 0.3),
                      
                      ),
                     onTap: ()
                     {
                    showAboutDialog(context: this.context, applicationIcon: Image(
                                  image:
                                      AssetImage('assets/appico/foreground.png'),
                                  width: screenSize.size.width / 5 * 0.7,
                                ), applicationName: "yNotes", applicationVersion: "0.1-Bêta", applicationLegalese: "Developpé avec amour en France");

                       

                     },
                      )
                  
            ],
          ),
        ),
      ),
    );
  }
}
