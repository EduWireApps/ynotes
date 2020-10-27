import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/usefulMethods.dart';

class HomeworkSettingPage extends StatefulWidget {
  final Function animateToPage;

  const HomeworkSettingPage(this.animateToPage);
  State<StatefulWidget> createState() {
    return _HomeworkSettingPageState();
  }
}

class _HomeworkSettingPageState extends State<HomeworkSettingPage> {
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Paramètres des devoirs",
            style: TextStyle(
              fontSize: screenSize.size.height / 10 * 0.3,
              fontFamily: "Asap",
              color: isDarkModeEnabled ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.3,
          ),
          FutureBuilder(
              future: getSetting("isExpandedByDefault"),
              initialData: false,
              builder: (context, snapshot) {
                return SwitchListTile(
                  value: snapshot.data,
                  title: Text("Étendre les devoirs",
                      style: TextStyle(
                          fontFamily: "Asap",
                          color: isDarkModeEnabled ? Colors.white : Colors.black,
                          fontSize: screenSize.size.height / 10 * 0.25)),
                  subtitle: Text(
                    "Afficher les détails des devoirs par défaut.",
                    style: TextStyle(
                        fontFamily: "Asap",
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                        fontSize: screenSize.size.height / 10 * 0.2),
                  ),
                  onChanged: (value) {
                    setState(() {
                      setSetting("isExpandedByDefault", value);
                    });
                  },
                  secondary: Icon(
                    MdiIcons.arrowExpand,
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
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
  }
}
