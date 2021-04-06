import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/services/shared_preferences.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modalBottomSheets/keyValues.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/usefulMethods.dart';

///Bottom windows with some infos on the discipline and the possibility to change the discipline color
void disciplineModalBottomSheet(context, Discipline discipline, Function callback, var widget) {
  Color colorGroup;

  if (widget.discipline == null) {
    colorGroup = Colors.blueAccent;
  } else {
    if (widget.discipline.color != null) {
      colorGroup = Color(widget.discipline.color);
    }
  }
  MediaQueryData screenSize = MediaQuery.of(context);
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: [
            Column(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenSize.size.width * 0.8),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.05),
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: colorGroup),
                          padding: EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text(
                              discipline.disciplineName,
                              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                            height: (screenSize.size.height / 3) / 6,
                            width: (screenSize.size.height / 3) / 6,
                            padding: EdgeInsets.all(5),
                            child: Material(
                                borderRadius: BorderRadius.circular(80),
                                color: Colors.grey.withOpacity(0.5),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(80),
                                  radius: 25,
                                  onTap: () async {
                                    Navigator.pop(context);
                                    Color color = await CustomDialogs.showColorPicker(context, Color(discipline.color));

                                    if (color != null) {
                                      String test = color.toString();
                                      String finalColor = "#" + test.toString().substring(10, test.length - 1);
                                      final prefs = await SharedPreferences.getInstance();
                                      await prefs.setString(discipline.disciplineCode, finalColor);
                                      discipline.setcolor = color;
                                      //Call set state
                                      callback();
                                    }
                                  },
                                  splashColor: Colors.grey,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    child: Icon(
                                      Icons.color_lens,
                                      color: Colors.black26,
                                    ),
                                  ),
                                )))
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    color: ThemeUtils.darken(Theme.of(context).primaryColorDark, forceAmount: 0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    child: Container(
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      width: screenSize.size.width / 5 * 4.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildKeyValuesInfo(context, "Votre moyenne", [
                            (appSys.settings["system"]["chosenParser"] == 1)
                                ? (widget.discipline.average ?? "-")
                                : ((!widget.discipline.getAverage().isNaN)
                                    ? widget.discipline.getAverage().toString()
                                    : widget.discipline.average ?? "-")
                          ]),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          buildKeyValuesInfo(context, "Moyenne de la classe", [discipline.classAverage]),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          buildKeyValuesInfo(context, "Moyenne la plus élevée", [discipline.maxClassAverage]),
                          if (discipline.minClassAverage != null)
                            SizedBox(
                              height: (screenSize.size.height / 3) / 25,
                            ),
                          if (discipline.minClassAverage != null)
                            buildKeyValuesInfo(context, "Moyenne la plus basse", [discipline.minClassAverage]),
                          if (discipline.disciplineRank != null)
                            SizedBox(
                              height: (screenSize.size.height / 3) / 25,
                            ),
                          if (discipline.disciplineRank != null)
                            buildKeyValuesInfo(context, "Rang",
                                [discipline.disciplineRank.toString() + "/" + discipline.classNumber.toString()]),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      });
}
