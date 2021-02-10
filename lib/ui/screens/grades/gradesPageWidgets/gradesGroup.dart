
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/stats/gradesStats.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modalBottomSheets/disciplinesModalBottomSheet.dart';
import 'package:ynotes/ui/components/modalBottomSheets/gradesModalBottomSheet/gradesModalBottomSheet.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/usefulMethods.dart';

class GradesGroup extends StatefulWidget {
  final Discipline disciplinevar;
  const GradesGroup({this.disciplinevar});

  State<StatefulWidget> createState() {
    return _GradesGroupState();
  }
}

class _GradesGroupState extends State<GradesGroup> {
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    String capitalizedNomDiscipline;
    String nomsProfesseurs;
    Color colorGroup;
    void callback() {
      setState(() {
        colorGroup = Color(widget.disciplinevar.color);
      });
    }

    if (widget.disciplinevar == null) {
      colorGroup = Theme.of(context).primaryColorDark;
      nomsProfesseurs = null;
      capitalizedNomDiscipline = null;
    } else {
      String nomDiscipline = widget.disciplinevar.disciplineName.toLowerCase();
      capitalizedNomDiscipline = "${nomDiscipline[0].toUpperCase()}${nomDiscipline.substring(1)}";
      if (widget.disciplinevar.color != null) {
        colorGroup = Color(widget.disciplinevar.color);
      }
      if (widget.disciplinevar.teachers.length > 0) {
        nomsProfesseurs = widget.disciplinevar.teachers[0];
        if (nomsProfesseurs != null) {
          widget.disciplinevar.teachers.forEach((element) {
            if (widget.disciplinevar.teachers.indexOf(element) > 0) {
              nomsProfesseurs += " - " + element + " - ";
            }
          });
        }
      }
    }
    //BLOCK BUILDER
    return Container(
      width: screenSize.size.width / 5 * 3.2,
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
      child: Stack(
        children: <Widget>[
          //Label
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.0005),
              child: Material(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                color: colorGroup,
                child: InkWell(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  onTap: () {
                    if (widget.disciplinevar != null) {
                      disciplineModalBottomSheet(context, widget.disciplinevar, callback, this.widget);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(width: 0.0, color: Colors.transparent)),
                    width: screenSize.size.width / 5 * 4.5,
                    height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75,
                    child: Center(
                      child: Stack(children: <Widget>[
                        if (widget.disciplinevar != null && capitalizedNomDiscipline != null)
                          Positioned(
                            left: screenSize.size.width / 5 * 0.15,
                            top: screenSize.size.height / 10 * 0.1,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      capitalizedNomDiscipline,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "Asap",
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenSize.size.height / 10 * 0.15),
                                    ),
                                  ),
                                  if (nomsProfesseurs != null && nomsProfesseurs.length > 15)
                                    Container(
                                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.3),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.5)),
                                        width: screenSize.size.width / 5 * 2,
                                        height: screenSize.size.height / 10 * 0.3,
                                        child: ClipRRect(
                                          child: Marquee(
                                              text: nomsProfesseurs,
                                              style: TextStyle(
                                                  fontFamily: "Asap", fontSize: screenSize.size.height / 10 * 0.15)),
                                        )),
                                  if (nomsProfesseurs != null && nomsProfesseurs.length <= 15)
                                    Container(
                                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.3),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
                                        width: screenSize.size.width / 5 * 2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Text(nomsProfesseurs,
                                              style: TextStyle(
                                                  fontFamily: "Asap", fontSize: screenSize.size.height / 10 * 0.2)),
                                        )),
                                ],
                              ),
                            ),
                          ),
                        if (widget.disciplinevar == null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Shimmer.fromColors(
                                baseColor: Color(0xff5D6469),
                                highlightColor: Color(0xff8D9499),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: screenSize.size.width / 5 * 0.3, bottom: screenSize.size.width / 5 * 0.2),
                                  width: screenSize.size.width / 5 * 1.5,
                                  height: (screenSize.size.height / 10 * 8.8) / 10 * 0.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).primaryColorDark),
                                )),
                          ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Body with columns
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.55),
                width: screenSize.size.width / 5 * 4.5,
                decoration: BoxDecoration(
                  color: isDarkModeEnabled ? Color(0xff333333) : Color(0xffE2E2E2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Column(
                    children: <Widget>[
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.subdisciplineCode.length > 0)
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Ecrit",
                                style: TextStyle(
                                  fontFamily: "Asap",
                                  color: ThemeUtils.textColor(),
                                ),
                              )),
                      gradesList(0),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.subdisciplineCode.length > 0) Divider(thickness: 2),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.subdisciplineCode.length > 0)
                          Text("Oral",
                              style: TextStyle(
                                fontFamily: "Asap",
                                color: ThemeUtils.textColor(),
                              )),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.subdisciplineCode.length > 0) gradesList(1),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  List<Grade> getGradesForDiscipline(int sousMatiereIndex, String chosenPeriode) {
    List<Grade> toReturn = List();

    if (widget.disciplinevar != null) {
      widget.disciplinevar.gradesList.forEach((element) {
        if (element.periodName == periodeToUse) {
          if (widget.disciplinevar.subdisciplineCode.length > 1) {
            if (element.subdisciplineCode == widget.disciplinevar.subdisciplineCode[sousMatiereIndex]) {
              toReturn.add(element);
            }
          } else {
            toReturn.add(element);
          }
        }
      });
      return toReturn;
    } else {
      return null;
    }
  }

  //MARKS COLUMN
  gradesList(int sousMatiereIndex) {
    void callback() {
      setState(() {});
    }

    bool canShow = false;
    List<Grade> gradesForSelectedDiscipline = getGradesForDiscipline(sousMatiereIndex, periodeToUse);
    if (gradesForSelectedDiscipline == null) {
      canShow = false;
    } else {
      if (gradesForSelectedDiscipline.length > 2) canShow = true;
    }

    Color colorGroup;
    if (widget.disciplinevar == null) {
      colorGroup = Theme.of(context).primaryColorDark;
    } else {
      if (widget.disciplinevar.color != null) {
        colorGroup = Color(widget.disciplinevar.color);
      }
    }
    MediaQueryData screenSize = MediaQuery.of(context);
    ScrollController marksColumnController = ScrollController();
    return Container(
        height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
        child: ListView.builder(
            itemCount: (gradesForSelectedDiscipline != null ? gradesForSelectedDiscipline.length : 1),
            controller: marksColumnController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
                horizontal: screenSize.size.width / 5 * 0.2, vertical: (screenSize.size.height / 10 * 8.8) / 10 * 0.15),
            itemBuilder: (BuildContext context, int index) {
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd').format(now);
              if (gradesForSelectedDiscipline != null && gradesForSelectedDiscipline.length != null) {
                try {
                  if (marksColumnController != null && marksColumnController.hasClients) {
                    // marksColumnController.animateTo(localList.length * screenSize.size.width / 5 * 1.2, duration: new Duration(microseconds: 5), curve: Curves.ease);
                  }
                } catch (e) {}
                if (gradesForSelectedDiscipline[index].entryDate == formattedDate) {
                  newGrades = true;
                }
              }

              return Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: (getGradesForDiscipline(sousMatiereIndex, periodeToUse) == null)
                                ? Colors.transparent
                                : Colors.black,
                            width: 1)),
                    margin:
                        EdgeInsets.only(left: screenSize.size.width / 5 * 0.1, right: screenSize.size.width / 5 * 0.1),
                    child: Material(
                      color: (getGradesForDiscipline(sousMatiereIndex, periodeToUse) == null)
                          ? Colors.transparent
                          : colorGroup,
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                        splashColor: colorGroup,
                        onTap: () async {
                          GradesStats stats = GradesStats(gradesForSelectedDiscipline[index],
                              getAllGrades(await localApi.getGrades(), overrideLimit: true, sortByWritingDate: false));
                          gradesModalBottomSheet(context, gradesForSelectedDiscipline[index], stats,
                              widget.disciplinevar, callback, this.widget);
                        },
                        onLongPress: () {
                          CustomDialogs.showShareGradeDialog(context, gradesForSelectedDiscipline[index]);
                        },
                        child: ClipRRect(
                          child: Stack(
                            children: <Widget>[
                              if (gradesForSelectedDiscipline != null)
                                //Grade box
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //Grades
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: (screenSize.size.height / 10 * 8.8) / 10 * 0.05),
                                        child: AutoSizeText.rich(
                                          //MARK
                                          TextSpan(
                                            text: (gradesForSelectedDiscipline[index].notSignificant
                                                ? "(" + gradesForSelectedDiscipline[index].value
                                                : gradesForSelectedDiscipline[index].value),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Asap",
                                                fontWeight: FontWeight.bold,
                                                fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3),
                                            children: <TextSpan>[
                                              if (gradesForSelectedDiscipline[index].scale != "20")

                                                //MARK ON
                                                TextSpan(
                                                    text: '/' + gradesForSelectedDiscipline[index].scale,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2)),
                                              if (gradesForSelectedDiscipline[index].notSignificant == true)
                                                TextSpan(
                                                    text: ")",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //COEFF
                                      if (gradesForSelectedDiscipline[index].coefficient != "1")
                                        Container(
                                            padding: EdgeInsets.all(screenSize.size.width / 5 * 0.03),
                                            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                                            width: screenSize.size.width / 5 * 0.25,
                                            height: screenSize.size.width / 5 * 0.25,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                              color: Colors.grey.shade600,
                                            ),
                                            child: FittedBox(
                                                child: AutoSizeText(
                                              gradesForSelectedDiscipline[index].coefficient,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.bold),
                                            ))),
                                    ],
                                  ),
                                ),
                              if (getGradesForDiscipline(sousMatiereIndex, periodeToUse) == null)
                                Shimmer.fromColors(
                                    baseColor: Color(0xff5D6469),
                                    highlightColor: Color(0xff8D9499),
                                    child: Container(
                                      width: screenSize.size.width / 5 * 3.2,
                                      height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.5),
                                          color: Theme.of(context).primaryColorDark),
                                    )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (gradesForSelectedDiscipline != null)
                    if (gradesForSelectedDiscipline[index].entryDate == formattedDate)
                      Positioned(
                        right: screenSize.size.width / 5 * 0.06,
                        top: screenSize.size.height / 15 * 0.01,
                        child: Badge(
                          animationType: BadgeAnimationType.scale,
                          toAnimate: true,
                          elevation: 0,
                          position: BadgePosition.topEnd(),
                          badgeColor: Colors.blue,
                        ),
                      ),
                ],
              );
            }));
  }
}