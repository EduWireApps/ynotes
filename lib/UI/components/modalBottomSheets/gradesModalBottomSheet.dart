import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ynotes/UI/components/modalBottomSheets/disciplinesModalBottomSheet.dart';
import 'package:ynotes/UI/components/modalBottomSheets/utils.dart';
import 'package:ynotes/UI/utils/themeUtils.dart';
import '../../../apiManager.dart';
import '../../../usefulMethods.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ynotes/main.dart';

import '../gradesChart.dart';

void gradesModalBottomSheet(context, Grade grade, Discipline discipline, Function callback, var widget, Function colorPicker) {
  MediaQueryData screenSize = MediaQuery.of(context);
  Color colorGroup;
  if (widget.disciplinevar == null) {
    colorGroup = Theme.of(context).primaryColor;
  } else {
    if (widget.disciplinevar.color != null) {
      colorGroup = Color(widget.disciplinevar.color);
    }
  }
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      context: context,
      builder: (BuildContext bc) {
        return new Container(
            height: (screenSize.size.height / 10 * 3.5),
            padding: EdgeInsets.all(0),
            child: new Stack(
              children: <Widget>[
                //Grade
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    height: (screenSize.size.height / 3) / 2.5,
                    width: (screenSize.size.width / 5) * 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), topLeft: Radius.circular(25)),
                      border: Border.all(width: 0.000, color: Colors.transparent),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FittedBox(
                          child: Text(
                            grade.valeur != null ? grade.valeur : "-",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap", fontWeight: FontWeight.w600, fontSize: (screenSize.size.width / 5) * 0.3),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.4),
                          child: Divider(height: (screenSize.size.height / 3) / 75, thickness: (screenSize.size.height / 3) / 75, color: isDarkModeEnabled ? Colors.white : Colors.black),
                        ),
                        FittedBox(
                          child: Text(
                            grade.noteSur != null ? grade.noteSur : "-",
                            style: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap", fontWeight: FontWeight.w600, fontSize: (screenSize.size.width / 5) * 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Description
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (screenSize.size.width / 5) * 0.5,
                    ),
                    height: (screenSize.size.height / 3) / 2.5,
                    width: (screenSize.size.width / 5) * 3.5,
                    child: FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: colorGroup,
                            borderRadius: BorderRadius.circular(15),
                            child: InkWell(
                              radius: 45,
                              onTap: () {
                                Navigator.pop(context);
                                disciplineModalBottomSheet(context, discipline, callback, widget, colorPicker);
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(discipline.nomDiscipline, style: TextStyle(fontFamily: "Asap", fontSize: 15, fontWeight: FontWeight.w100)),
                              ),
                            ),
                          ),
                          Container(
                            width: (screenSize.size.width / 5) * 3,
                            child: AutoSizeText(
                              grade.devoir != null ? grade.devoir : "-",
                              minFontSize: 18,
                              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //Align(alignment: Alignment.center, child: Container(height: (screenSize.size.height / 10 * 4), width: screenSize.size.width, child: gradesChart())),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: (screenSize.size.height / 3) / 1.5,
                    width: screenSize.size.width,
                    margin: EdgeInsets.only(top: (screenSize.size.height / 3) / 10),
                    child: FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildKeyValuesInfo(context, "Moyenne de la classe :", [grade.moyenneClasse != "" && grade.moyenneClasse != null ? grade.moyenneClasse : "-"]),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          buildKeyValuesInfo(context, "Type de devoir :", [grade.typeDevoir != null ? grade.typeDevoir : "-"]),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          buildKeyValuesInfo(context, "Date du devoir :", [grade.date != null ? (!grade.date.contains("/") ? DateFormat("dd MMMM yyyy", "fr_FR").format(DateTime.parse(grade.date)) : DateFormat("dd MMMM yyyy", "fr_FR").format(DateFormat("dd/MM/yyyy").parse(grade.date))) : "-"]),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
      });
}