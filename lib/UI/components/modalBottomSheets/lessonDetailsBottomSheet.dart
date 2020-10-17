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
import 'package:ynotes/UI/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/UI/components/modalBottomSheets/utils.dart';
import 'package:ynotes/UI/utils/themeUtils.dart';
import '../../../apiManager.dart';
import '../../../usefulMethods.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ynotes/main.dart';

import '../gradesChart.dart';

void lessonDetails(context, Lesson lesson, Color color) {
  MediaQueryData screenSize = MediaQuery.of(context);
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: screenSize.size.height / 10 * 5.0,
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
                SizedBox(
                  height: screenSize.size.height / 10 * 0.1,
                ),
                Card(
                  color: Theme.of(context).primaryColorDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  child: Container(
                    width: screenSize.size.width / 5 * 4.5,
                    child: Column(
                      children: [
                        Container(padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1), child: Text("Infos de l'évènement", style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black))),
                        Container(
                          padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          height: screenSize.size.height / 10 * 2,
                          margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 0.2)),
                          child: FittedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                buildKeyValuesInfo(context, "Horaires", ["${DateFormat.Hm().format(lesson.start)} - ${DateFormat.Hm().format(lesson.end)}"]),
                                if (lesson.room != null)
                                  SizedBox(
                                    height: (screenSize.size.height / 3) / 25,
                                  ),
                                if (lesson.room != null) buildKeyValuesInfo(context, "Salle", [lesson.room]),
                                if (lesson.teachers != null)
                                  SizedBox(
                                    height: (screenSize.size.height / 3) / 25,
                                  ),
                                if (lesson.teachers != null) buildKeyValuesInfo(context, "Professeur${lesson.teachers.length > 1 ? "s" : ""}", lesson.teachers),
                                if (lesson.groups != null)
                                  SizedBox(
                                    height: (screenSize.size.height / 3) / 25,
                                  ),
                                if (lesson.groups != null) buildKeyValuesInfo(context, "Groupes", lesson.groups),
                                SizedBox(
                                  height: (screenSize.size.height / 3) / 25,
                                ),
                                buildKeyValuesInfo(context, "Statut", [lesson.status ?? "Maintenu"]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.size.height / 10 * 0.1,
                ),
                GestureDetector(
                  onTap: () {
                    agendaEventEdit(context);
                  },
                  child: Card(
                      color: Theme.of(context).primaryColorDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                      child: Container(
                        width: screenSize.size.width / 5 * 4.5,
                        height: screenSize.size.height / 10 * 0.8,
                        padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 1.2),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //Plus button
                              Container(
                                width: screenSize.size.width / 5 * 0.4,
                                height: screenSize.size.width / 5 * 0.4,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    agendaEventEdit(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      new Icon(
                                        Icons.add,
                                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                                        size: screenSize.size.height / 10 * 0.3,
                                      ),
                                    ],
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 1.0,
                                  fillColor: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(width: screenSize.size.width / 5 * 0.1),
                              Text(
                                "Ajouter un rappel",
                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                              )
                              
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ));
      });
}
