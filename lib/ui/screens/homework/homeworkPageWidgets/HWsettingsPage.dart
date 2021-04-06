import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/usefulMethods.dart';

class HomeworkSettingPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeworkSettingPageState();
  }
}

class _HomeworkSettingPageState extends State<HomeworkSettingPage> {
  //Settings

  initState() {
    super.initState();
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
            value: appSys.settings["user"]["homeworkPage"]["isExpandedByDefault"],
            title: Text("Étendre les devoirs",
                style: TextStyle(
                    fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.25)),
            subtitle: Text(
              "Afficher les détails des devoirs par défaut.",
              style: TextStyle(
                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: screenSize.size.height / 10 * 0.2),
            ),
            onChanged: (value) async {
              appSys.setSetting(["user", "homeworkPage", "isExpandedByDefault"], value);
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
}
