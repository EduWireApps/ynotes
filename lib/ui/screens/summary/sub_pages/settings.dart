import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';

class SummaryPageSettings extends StatefulWidget {
  @override
  _SummaryPageSettingsState createState() => _SummaryPageSettingsState();
}

class _SummaryPageSettingsState extends State<SummaryPageSettings> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Column(
      children: [
        Container(
            width: screenSize.size.width / 5 * 4.5,
            margin: EdgeInsets.all(screenSize.size.width / 5 * 0.2),
            child: Text(
              "Paramètres des devoirs rapides",
              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
              textAlign: TextAlign.left,
            )),
        Container(
            margin: EdgeInsets.only(
                bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2,
                top: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
            height: (screenSize.size.height / 10 * 8.8) / 10 * 3,
            child: ListView(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              children: <Widget>[
                CupertinoSlider(
                    value: appSys.settings.user.summaryPage.summaryQuickHomework.toDouble(),
                    min: 1.0,
                    max: 11.0,
                    divisions: 11,
                    onChanged: (double newValue) async {
                      appSys.settings.user.summaryPage.summaryQuickHomework = newValue.round();
                      appSys.saveSettings();

                      setState(() {});
                    }),
                Container(
                  margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                  child: AutoSizeText(
                    "Devoirs sur :\n" +
                        (appSys.settings.user.summaryPage.summaryQuickHomework.toString() == "11"
                            ? "∞"
                            : appSys.settings.user.summaryPage.summaryQuickHomework.toString()) +
                        " jour" +
                        (appSys.settings.user.summaryPage.summaryQuickHomework > 1 ? "s" : ""),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Asap", fontSize: 15, color: ThemeUtils.textColor()),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
