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
                          _buildKeyValuesInfo(context, "Moyenne de la classe :", [grade.moyenneClasse != "" && grade.moyenneClasse != null ? grade.moyenneClasse : "-"]),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          _buildKeyValuesInfo(context, "Type de devoir :", [grade.typeDevoir != null ? grade.typeDevoir : "-"]),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          _buildKeyValuesInfo(context, "Date du devoir :", [grade.date != null ? (!grade.date.contains("/") ? DateFormat("dd MMMM yyyy", "fr_FR").format(DateTime.parse(grade.date)) : DateFormat("dd MMMM yyyy", "fr_FR").format(DateFormat("dd/MM/yyyy").parse(grade.date))) : "-"]),
                        ],
                      ),
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenSize.size.width * 0.8),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.05),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: colorGroup),
                          padding: EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text(
                              discipline.nomDiscipline,
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
                  ),
                ),
                Container(
                  height: screenSize.size.height / 10 * 2,
                  margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 0.2)),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildKeyValuesInfo(context, "Votre moyenne", [discipline.moyenne]),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        _buildKeyValuesInfo(context, "Moyenne de la classe", [discipline.moyenneClasse]),
                        SizedBox(
                          height: (screenSize.size.height / 3) / 25,
                        ),
                        _buildKeyValuesInfo(context, "Moyenne la plus élevée", [discipline.moyenneMax]),
                        if (discipline.moyenneMin != null)
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                        if (discipline.moyenneMin != null) _buildKeyValuesInfo(context, "Moyenne la plus basse", [discipline.moyenneMin]),
                      ],
                    ),
                  ),
                )
              ],
            ));
      });
}

///Bottom windows with some infos on the discipline and the possibility to change the discipline color
void agendaEventBottomSheet(context) {
  Color colorGroup;

  MediaQueryData screenSize = MediaQuery.of(context);
  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: screenSize.size.height / 10 * 4,
            padding: EdgeInsets.all(2),
            child: FittedBox(
              child: new Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                      width: screenSize.size.width / 5 * 3.5,
                      child: AutoSizeText(
                        "Quel évènement voulez-vous créer ?",
                        style: TextStyle(fontFamily: "Asap", fontSize: 26, fontWeight: FontWeight.w400, color: isDarkModeEnabled ? Colors.white : Colors.black),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: screenSize.size.height / 10 * 0.1,
                  ),
                  _buildEventChoiceButton(context, "Récréation", Colors.green.shade200, MdiIcons.coffeeOutline),
                  _buildEventChoiceButton(context, "Activité extra scolaire", Colors.blue.shade200, MdiIcons.piano),
                ],
              ),
            ));
      });
}

_buildEventChoiceButton(BuildContext context, String content, Color color, IconData icon) {
  MediaQueryData screenSize = MediaQuery.of(context);
  return Container(
    margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
      boxShadow: [
        BoxShadow(
          color: darken(Theme.of(context).primaryColor).withOpacity(0.8),
          spreadRadius: 0.2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        child: InkWell(
          splashColor: darken(color),
          onTap: () async {},
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(1.4, 0.0), // 10% of the width, so there are ten blinds.
                  colors: [darken(color, forceAmount: 0.3), color], // whitish to gray
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              width: screenSize.size.width / 5 * 4,
              height: screenSize.size.height / 10 * 1,
              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.25),
              child: Stack(
                children: [
                  Transform.rotate(
                    angle: -0.1,
                    child: Transform.translate(
                        offset: Offset(-screenSize.size.width / 5 * 0.5, -screenSize.size.height / 10 * 0.2),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              icon,
                              color: darken(color, forceAmount: 0.8).withOpacity(0.2),
                              size: screenSize.size.width / 5 * 1.2,
                            ))),
                  ),
                  Center(
                    child: AutoSizeText(content, style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w700, fontSize: 28), textAlign: TextAlign.center),
                  ),
                ],
              )),
        ),
      ),
    ),
  );
}

void lessonDetails(context, Lesson lesson, Color color) {
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenSize.size.width * 0.8),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.05),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: color),
                          padding: EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text(
                              lesson.matiere ?? "",
                              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: screenSize.size.height / 10 * 2,
                  margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 0.2)),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildKeyValuesInfo(context, "Horaires", ["${DateFormat("hh:mm").format(lesson.start)} - ${DateFormat("hh:mm").format(lesson.end)}"]),
                        if (lesson.room != null)
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                        if (lesson.room != null) _buildKeyValuesInfo(context, "Salle", [lesson.room]),
                        if (lesson.teachers != null)
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                        if (lesson.teachers != null) _buildKeyValuesInfo(context, "Professeur${lesson.teachers.length > 1 ? "s" : ""}", lesson.teachers),
                        if (lesson.groups != null)
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                        if (lesson.groups != null)
                         _buildKeyValuesInfo(context, "Groupes", lesson.groups),
                        
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                   
                         _buildKeyValuesInfo(context, "Statut", [lesson.status??"Normal"]),
                      ],
                    ),
                  ),
                )
              ],
            ));
      });
}

_buildKeyValuesInfo(BuildContext context, String key, List<String> values) {
  if (values != null) {
    MediaQueryData screenSize = MediaQuery.of(context);
    if (values.length == 1) {
      return FittedBox(
        child: Container(
          width: screenSize.size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(key ?? "", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
              Container(
                margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                child: Text(
                  values[0] ?? "",
                  style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: screenSize.size.height / 10 * 0.7,
        width: screenSize.size.width,
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(key, style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
              SizedBox(
                height: screenSize.size.height / 10 * 0.05,
              ),
              Container(
                height: screenSize.size.height / 10 * 0.4,
                child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: values.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                          padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                          child: Text(
                            values[index],
                            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      );
    }
  } else {
    return Container();
  }
}
