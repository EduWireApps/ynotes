import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/stats/gradesStats.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modalBottomSheets/disciplinesModalBottomSheet.dart';
import 'package:ynotes/ui/components/modalBottomSheets/gradesModalBottomSheet/gradesModalBottomSheet.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/usefulMethods.dart';

class GradesGroup extends StatefulWidget {
  final Discipline discipline;
  final GradesController gradesController;
  const GradesGroup({this.discipline, this.gradesController});

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
        colorGroup = Color(widget.discipline.color);
      });
    }

    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColorDark;
      nomsProfesseurs = null;
      capitalizedNomDiscipline = null;
    } else {
      String nomDiscipline = widget.discipline.disciplineName.toLowerCase();
      capitalizedNomDiscipline = "${nomDiscipline[0].toUpperCase()}${nomDiscipline.substring(1)}";
      if (widget.discipline.color != null) {
        colorGroup = Color(widget.discipline.color);
      }
      if (widget.discipline.teachers.length > 0) {
        nomsProfesseurs = widget.discipline.teachers[0];
        if (nomsProfesseurs != null) {
          widget.discipline.teachers.forEach((element) {
            if (widget.discipline.teachers.indexOf(element) > 0) {
              nomsProfesseurs += " / " + element;
            }
          });
        }
      }
    }
    //BLOCK BUILDER
    return Container(
      width: screenSize.size.width / 5 * 3.2,
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
      child: Column(
        children: <Widget>[
          //Label
          Container(
            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.0005),
            child: Material(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: colorGroup,
              child: InkWell(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                onTap: () {
                  if (widget.discipline != null) {
                    disciplineModalBottomSheet(context, widget.discipline, callback, this.widget);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: (screenSize.size.height / 10 * 0.1), horizontal: screenSize.size.width / 5 * 0.1),
                  decoration: BoxDecoration(border: Border.all(width: 0.0, color: Colors.transparent)),
                  width: screenSize.size.width / 5 * 4.5,
                  child: Stack(children: <Widget>[
                    if (widget.discipline != null && capitalizedNomDiscipline != null)
                      Container(
                        child: Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: <Widget>[
                            Wrap(
                              spacing: screenSize.size.width / 5 * 0.1,
                              children: [
                                if (capitalizedNomDiscipline != null)
                                  Container(
                                    child: Text(
                                      capitalizedNomDiscipline,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "Asap",
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenSize.size.height / 10 * 0.2),
                                    ),
                                  ),
                                if (nomsProfesseurs != null)
                                  Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Text(nomsProfesseurs,
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Asap", fontSize: screenSize.size.height / 10 * 0.2)),
                                      )),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Text(
                                        "Moyenne : " +
                                            ((appSys.settings["system"]["chosenParser"] == 1)
                                                ? (widget.discipline.average ?? "-")
                                                : ((!widget.discipline.getAverage().isNaN)
                                                    ? widget.discipline.getAverage().toString()
                                                    : widget.discipline.average ?? "-")),
                                        style: TextStyle(
                                            fontFamily: "Asap",
                                            fontSize: screenSize.size.height / 10 * 0.17,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )),
                                if (widget.discipline.weight != null && widget.discipline.weight != "1")
                                  Container(
                                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.03),
                                      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.09),
                                      width: screenSize.size.width / 5 * 0.25,
                                      height: screenSize.size.width / 5 * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                        color: Colors.grey.shade600,
                                      ),
                                      child: FittedBox(
                                          child: AutoSizeText(
                                        widget.discipline.weight ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.bold),
                                      ))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (widget.discipline == null)
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
                                  borderRadius: BorderRadius.circular(8), color: Theme.of(context).primaryColorDark),
                            )),
                      ),
                  ]),
                ),
              ),
            ),
          ),

          //Body with columns
          Container(
              width: screenSize.size.width / 5 * 4.51,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (widget.discipline != null)
                      if (widget.discipline.subdisciplineCode.length > 0)
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "Ecrit",
                              style: TextStyle(
                                fontFamily: "Asap",
                                color: ThemeUtils.textColor(),
                              ),
                            )),
                    gradesList(0, widget.gradesController.period),
                    if (widget.discipline != null)
                      if (widget.discipline.subdisciplineCode.length > 0) Divider(thickness: 2),
                    if (widget.discipline != null)
                      if (widget.discipline.subdisciplineCode.length > 0)
                        Text("Oral",
                            style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(),
                            )),
                    if (widget.discipline != null)
                      if (widget.discipline.subdisciplineCode.length > 0) gradesList(1, widget.gradesController.period),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  List<Grade> getGradesForDiscipline(int sousMatiereIndex, String chosenPeriode) {
    List<Grade> toReturn = List();

    if (widget.discipline != null) {
      widget.discipline.gradesList.forEach((element) {
        if (element.periodName == chosenPeriode) {
          if (widget.discipline.subdisciplineCode.length > 1) {
            if (element.subdisciplineCode == widget.discipline.subdisciplineCode[sousMatiereIndex]) {
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

  //MARKS LIST VIEW
  gradesList(int sousMatiereIndex, String periodName) {
    void callback() {
      setState(() {});
    }

    bool canShow = false;
    List<Grade> gradesForSelectedDiscipline = getGradesForDiscipline(sousMatiereIndex, periodName);
    if (gradesForSelectedDiscipline != null) {
      gradesForSelectedDiscipline.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    }
    if (gradesForSelectedDiscipline != null) {
      gradesForSelectedDiscipline = gradesForSelectedDiscipline.reversed.toList();
    }
    if (gradesForSelectedDiscipline == null) {
      canShow = false;
    } else {
      if (gradesForSelectedDiscipline.length > 2) canShow = true;
    }

    Color colorGroup;
    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColorDark;
    } else {
      if (widget.discipline.color != null) {
        colorGroup = Color(widget.discipline.color);
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
                horizontal: screenSize.size.width / 5 * 0.1, vertical: (screenSize.size.height / 10 * 8.8) / 10 * 0.15),
            itemBuilder: (BuildContext context, int index) {
              if (gradesForSelectedDiscipline != null && gradesForSelectedDiscipline.length != null) {
                try {
                  if (marksColumnController != null && marksColumnController.hasClients) {
                    // marksColumnController.animateTo(localList.length * screenSize.size.width / 5 * 1.2, duration: new Duration(microseconds: 5), curve: Curves.ease);
                  }
                } catch (e) {}
                if (DateFormat('yyyy-MM-dd').format(gradesForSelectedDiscipline[index].entryDate) ==
                    DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                  newGrades = true;
                }
              }

              return Badge(
                animationType: BadgeAnimationType.scale,
                toAnimate: true,
                elevation: 0,
                showBadge: (gradesForSelectedDiscipline != null) &&
                    (DateFormat('yyyy-MM-dd').format(gradesForSelectedDiscipline[index].entryDate) ==
                            DateFormat('yyyy-MM-dd').format(DateTime.now()) &&
                        !gradesForSelectedDiscipline[index].simulated),
                position: BadgePosition.topEnd(top: 0, end: 0),
                badgeColor: Colors.blue,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 0, color: Colors.transparent)),
                  margin: EdgeInsets.only(
                      left: screenSize.size.width / 5 * 0.025, right: screenSize.size.width / 5 * 0.025),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: getGradesForDiscipline(sousMatiereIndex, periodName) == null
                        ? Colors.transparent
                        : (gradesForSelectedDiscipline[index].simulated ? Colors.blue : Colors.transparent),
                    strokeWidth: 1,
                    radius: Radius.circular(11),
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(11)), side: BorderSide.none),
                      borderOnForeground: false,
                      color: (getGradesForDiscipline(sousMatiereIndex, periodName) == null)
                          ? Colors.transparent
                          : ((gradesForSelectedDiscipline[index].simulated != null &&
                                  gradesForSelectedDiscipline[index].simulated)
                              ? Colors.blue.withOpacity(0.7)
                              : colorGroup),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                        splashColor: colorGroup,
                        onTap: () async {
                          GradesStats stats = GradesStats(
                              gradesForSelectedDiscipline[index],
                              getAllGrades(widget.gradesController.disciplines(),
                                  overrideLimit: true, sortByWritingDate: false));
                          gradesModalBottomSheet(context, gradesForSelectedDiscipline[index], stats, widget.discipline,
                              callback, this.widget, widget.gradesController);
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
                                  decoration: BoxDecoration(
                                    //don't show it if simulator enabled
                                    border: gradesForSelectedDiscipline[index].simulated
                                        ? null
                                        : Border.all(width: 1.2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //Grades
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: (screenSize.size.height / 10 * 8.8) / 10 * 0.02),
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
                                      if (gradesForSelectedDiscipline[index].weight != "1")
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
                                              gradesForSelectedDiscipline[index].weight,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.bold),
                                            ))),
                                    ],
                                  ),
                                ),
                              if (widget.discipline == null)
                                Shimmer.fromColors(
                                    baseColor: Color(0xff5D6469),
                                    highlightColor: Color(0xff8D9499),
                                    child: Container(
                                      width: screenSize.size.width / 5 * 3.8,
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
                ),
              );
            }));
  }
}
