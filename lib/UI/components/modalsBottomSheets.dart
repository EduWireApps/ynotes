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
import 'package:ynotes/UI/utils/themeUtils.dart';
import '../../apiManager.dart';
import '../../usefulMethods.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ynotes/main.dart';

import 'gradesChart.dart';

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
                          child: Divider(thickness: (screenSize.size.height / 3) / 75, color: isDarkModeEnabled ? Colors.white : Colors.black),
                        ),
                        Text(
                          grade.noteSur != null ? grade.noteSur : "-",
                          style: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap", fontWeight: FontWeight.w600, fontSize: (screenSize.size.width / 5) * 0.3),
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
                    width: (screenSize.size.width * 0.8),
                    margin: EdgeInsets.only(top: (screenSize.size.height / 3) / 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Moyenne de la classe :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                            Container(
                              margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                              padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                              child: Text(
                                (grade.moyenneClasse != "" && grade.moyenneClasse != null ? grade.moyenneClasse : "-"),
                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Type de devoir :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                            Container(
                              margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                              padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                              child: Text(
                                grade.typeDevoir != null ? grade.typeDevoir : "-",
                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        FittedBox(
                                  fit: BoxFit.fitWidth,
                                  
                                                  child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Date du devoir :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                              Container(
                                margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                                padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                                child: FittedBox(
                           
                                                                child: Text(
                                    grade.date != null
                                        ? (!grade.date.contains("/") ? DateFormat("dd MMMM yyyy", "fr_FR").format(DateTime.parse(grade.date)) : DateFormat("dd MMMM yyyy", "fr_FR").format(DateFormat("dd/MM/yyyy").parse(grade.date)))
                                        : "-",
                                    style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ));
      });
}

///Bottom windows with some infos on the discipline and the possibility to change the discipline color
void disciplineModalBottomSheet(context, Discipline discipline, Function callback, var widget, Function colorPicker) {
  Color colorGroup;
  if (widget.disciplinevar == null) {
    colorGroup = Colors.blueAccent;
  } else {
    if (widget.disciplinevar.color != null) {
      colorGroup = Color(widget.disciplinevar.color);
      ;
    }
  }
  MediaQueryData screenSize = MediaQuery.of(context);
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: screenSize.size.height / 10 * 3.0,
            padding: EdgeInsets.all(0),
            child: new Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.05),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: colorGroup),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        discipline.nomDiscipline,
                        style: TextStyle(fontFamily: "Asap", fontSize: 17, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
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
                              onTap: () {
                                Navigator.pop(context);
                                colorPicker(context, discipline, callback);
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
                Container(
                  height: screenSize.size.height / 10 * 2,
                  margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 0.2)),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Votre moyenne :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                            Container(
                              margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                              padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                              child: Text(
                                discipline.moyenne != null ? discipline.moyenne : "-",
                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Moyenne de la classe :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                            Container(
                              margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                              padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                              child: Text(
                                discipline.moyenneClasse != null ? discipline.moyenneClasse : "-",
                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Meilleure moyenne :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                            Container(
                              margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                              padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                              child: Text(
                                discipline.moyenneMax != null ? discipline.moyenneMax : "-",
                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Moyenne de la classe :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                            Container(
                              margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                              padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                              child: Text(
                                discipline.moyenneClasse != null ? discipline.moyenneClasse : "-",
                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ));
      });
}
