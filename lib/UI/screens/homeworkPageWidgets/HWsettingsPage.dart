import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/usefulMethods.dart';

class HomeworkSettingPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeworkSettingPageState();
  }
}

class _HomeworkSettingPageState extends State<HomeworkSettingPage> {
  //Settings
  var boolSettings = {
    "isExpandedByDefault": false,
  };
  var intSettings = {};
  void getSettings() async {
    await Future.forEach(boolSettings.keys, (key) async {
      var value = await getSetting(key);
      setState(() {
        boolSettings[key] = value;
      });
    });

    await Future.forEach(intSettings.keys, (key) async {
      int value = await getIntSetting(key);
      setState(() {
        intSettings[key] = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
        color: Theme.of(context).primaryColor,
      ),
      width: screenSize.size.width / 5 * 4.5,
      child: Column(
        children: [
          Container(
              width: screenSize.size.width / 5 * 4.5,
              margin: EdgeInsets.all(screenSize.size.width / 5 * 0.2),
              child: Text(
                "Paramètres des devoirs",
                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
                textAlign: TextAlign.left,
              )),
          SwitchListTile(
            value: boolSettings["isExpandedByDefault"],
            title: Text("Étendre les devoirs", style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.25)),
            subtitle: Text(
              "Afficher les détails des devoirs par défaut.",
              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.2),
            ),
            onChanged: (value) async {
              setState(() {
                boolSettings["isExpandedByDefault"] = value;
              });

              await setSetting("isExpandedByDefault", value);
            },
            secondary: Icon(
              MdiIcons.arrowExpand,
              color: ThemeUtils.textColor(),
            ),
          )
        ],
      ),
    );
  }

  /*Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Paramètres des devoirs",
            style: TextStyle(
              fontSize: screenSize.size.height / 10 * 0.3,
              fontFamily: "Asap",
              color: ThemeUtils.textColor(),
            ),
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.3,
          ),
          FutureBuilder(
              future:   boolSettings["isExpandedByDefault"] ,
              initialData: false,
              builder: (context, snapshot) {
                return SwitchListTile(
                  value:   boolSettings["isExpandedByDefault"] ,
                  title: Text("Étendre les devoirs",
                      style: TextStyle(
                          fontFamily: "Asap",
                          color: ThemeUtils.textColor(),
                          fontSize: screenSize.size.height / 10 * 0.25)),
                  subtitle: Text(
                    "Afficher les détails des devoirs par défaut.",
                    style: TextStyle(
                        fontFamily: "Asap",
                        color: ThemeUtils.textColor(),
                        fontSize: screenSize.size.height / 10 * 0.2),
                  ),
                  onChanged: (value) {
                    setState(() {
                boolSettings["isExpandedByDefault"] = value;
              });

              await setSetting("isExpandedByDefault", value);
                  },
                  secondary: Icon(
                    MdiIcons.arrowExpand,
                    color: ThemeUtils.textColor(),
                  ),
                );
              }),
          Container(
            margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2),
            height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75,
            width: screenSize.size.width / 5 * 2,
            child: RaisedButton(
              color: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              onPressed: () {
                widget.animateToPage(1);
              },
              child: Text(
                "Retour",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontFamily: "Asap", color:isDarkModeEnabled?Colors.white:Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }*/
}
