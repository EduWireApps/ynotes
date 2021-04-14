import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/ui/components/modalBottomSheets/disciplinesModalBottomSheet.dart';
import 'package:ynotes/ui/components/modalBottomSheets/gradesModalBottomSheet/stats.dart';
import 'package:ynotes/ui/components/modalBottomSheets/keyValues.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/stats/gradesStats.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

void gradesModalBottomSheet(
  context,
  Grade grade,
  GradesStats stats,
  Discipline discipline,
  Function callback,
  var widget,
  GradesController gradesController,
) {
  MediaQueryData screenSize = MediaQuery.of(context);

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return GradesModalBottomSheetContainer(
          grade: grade,
          stats: stats,
          discipline: discipline,
          callback: callback,
          gradesController: gradesController,
        );
      });
}

class GradesModalBottomSheetContainer extends StatefulWidget {
  const GradesModalBottomSheetContainer(
      {Key key, this.grade, this.stats, this.discipline, this.callback, this.gradesController})
      : super(key: key);

  final Grade grade;
  final GradesStats stats;
  final Discipline discipline;
  final Function callback;
  final GradesController gradesController;
  @override
  _GradesModalBottomSheetContainerState createState() => _GradesModalBottomSheetContainerState();
}

class _GradesModalBottomSheetContainerState extends State<GradesModalBottomSheetContainer> {
  bool open = false;
  @override
  Widget build(BuildContext context) {
    Color colorGroup;
    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColor;
    } else {
      if (widget.discipline.color != null) {
        colorGroup = Color(widget.discipline.color);
      }
    }
    MediaQueryData screenSize = MediaQuery.of(context);
    return Wrap(
      children: [
        new AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                Container(
                  height: (screenSize.size.height / 10 * 1.7),
                  child: new Stack(
                    children: <Widget>[
                      //Grade
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.all(0),
                          height: screenSize.size.height / 10 * 1.5,
                          width: (screenSize.size.width / 5) * 1.5,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.only(bottomRight: Radius.circular(25), topLeft: Radius.circular(25)),
                            border: Border.all(width: 0.000, color: Colors.transparent),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FittedBox(
                                child: Text(
                                  widget.grade.value != null ? widget.grade.value : "-",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ThemeUtils.textColor(),
                                      fontFamily: "Asap",
                                      fontWeight: FontWeight.w600,
                                      fontSize: (screenSize.size.width / 5) * 0.3),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.4),
                                child: Divider(
                                    height: (screenSize.size.height / 3) / 75,
                                    thickness: (screenSize.size.height / 3) / 75,
                                    color: ThemeUtils.textColor()),
                              ),
                              FittedBox(
                                child: Text(
                                  widget.grade.scale != null ? widget.grade.scale : "-",
                                  style: TextStyle(
                                      color: ThemeUtils.textColor(),
                                      fontFamily: "Asap",
                                      fontWeight: FontWeight.w600,
                                      fontSize: (screenSize.size.width / 5) * 0.3),
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
                          height: screenSize.size.height / 10 * 1.5,
                          width: (screenSize.size.width / 5) * 3.5,
                          child: FittedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: [
                                    if (widget.gradesController.isSimulating)
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        iconSize: screenSize.size.width / 5 * 0.4,
                                        color: Colors.blue,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          widget.gradesController.simulationRemove(widget.grade);
                                        },
                                      ),
                                    Material(
                                      color: colorGroup,
                                      borderRadius: BorderRadius.circular(15),
                                      child: InkWell(
                                        radius: 45,
                                        onTap: () {
                                          Navigator.pop(context);
                                          disciplineModalBottomSheet(
                                              context, widget.discipline, widget.callback, widget);
                                        },
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(widget.discipline.disciplineName,
                                              style: TextStyle(
                                                  fontFamily: "Asap", fontSize: 15, fontWeight: FontWeight.w100)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: (screenSize.size.width / 5) * 3,
                                  child: AutoSizeText(
                                    widget.grade.testName != null ? widget.grade.testName : "-",
                                    minFontSize: 18,
                                    style: TextStyle(
                                        fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          buildKeyValuesInfo(context, "Moyenne de la classe :", [
                            widget.grade.classAverage != "" && widget.grade.classAverage != null
                                ? widget.grade.classAverage
                                : "-"
                          ]),
                          if (widget.grade.max != "" && widget.grade.max != null)
                            SizedBox(
                              height: (screenSize.size.height / 3) / 25,
                            ),
                          if (widget.grade.max != "" && widget.grade.max != null)
                            buildKeyValuesInfo(context, "Note la plus haute",
                                [widget.grade.max != "" && widget.grade.max != null ? widget.grade.max : "-"]),
                          if (widget.grade.max != "" && widget.grade.max != null)
                            SizedBox(
                              height: (screenSize.size.height / 3) / 25,
                            ),
                          if (widget.grade.max != "" && widget.grade.max != null)
                            buildKeyValuesInfo(context, "Note la plus basse",
                                [widget.grade.min != "" && widget.grade.min != null ? widget.grade.min : "-"]),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          buildKeyValuesInfo(context, "Type de devoir :",
                              [widget.grade.testType != null ? widget.grade.testType : "-"]),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: buildKeyValuesInfo(context, "Date du devoir :", [
                              widget.grade.date != null
                                  ? DateFormat("dd MMMM yyyy", "fr_FR").format(widget.grade.date)
                                  : "-"
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      open = !open;
                    });
                  },
                  child: Card(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                      color: ThemeUtils.darken(Theme.of(context).primaryColorDark, forceAmount: 0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                      child: Container(
                        width: screenSize.size.width / 5 * 4.5,
                        height: screenSize.size.height / 10 * 0.6,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.size.width / 5 * 0.2, vertical: screenSize.size.height / 10 * 0.1),
                        child: FittedBox(
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              //Plus button

                              Container(
                                width: screenSize.size.width / 5 * 0.4,
                                height: screenSize.size.width / 5 * 0.4,
                                child: RawMaterialButton(
                                  onPressed: () async {
                                    setState(() {
                                      open = !open;
                                    });
                                  },
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: screenSize.size.width / 5 * 0.3,
                                          height: screenSize.size.width / 5 * 0.3,
                                          padding: EdgeInsets.all(
                                            screenSize.size.width / 5 * 0.05,
                                          ),
                                          child: FittedBox(
                                            child: new Icon(
                                              Icons.bar_chart,
                                              color: ThemeUtils.textColor(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 1.0,
                                  fillColor: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(width: screenSize.size.width / 5 * 0.1),
                              Container(
                                height: screenSize.size.height / 10 * 0.2,
                                child: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "SpaceStats",
                                        style: TextStyle(
                                            fontFamily: "Asap",
                                            color: ThemeUtils.textColor(),
                                            textBaseline: TextBaseline.ideographic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ),
                Card(
                    margin: EdgeInsets.only(
                        top: screenSize.size.height / 10 * 0.1, bottom: screenSize.size.height / 10 * 0.1),
                    color: ThemeUtils.darken(Theme.of(context).primaryColorDark, forceAmount: 0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      width: screenSize.size.width / 5 * 4.5,
                      height: screenSize.size.height / 10 * (open ? 4 : 0),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.size.width / 5 * 0.2, vertical: screenSize.size.height / 10 * 0.1),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Tooltip(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11), color: Theme.of(context).primaryColorLight),
                              margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.7),
                              message:
                                  "Indique le nombre de points d'impact sur la moyenne de la matière au moment de l'obtention de cette note.",
                              textStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                              child: ImpactStat(
                                impact: widget.stats.calculateAverageImpact(),
                                label: "points de moyenne pour la matière (à l'obtention).",
                              ),
                            ),
                            SizedBox(height: screenSize.size.height / 10 * 0.1),
                            Tooltip(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11), color: Theme.of(context).primaryColorLight),
                              margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.7),
                              message:
                                  "Indique le nombre de points d'impact sur la moyenne générale au moment de l'obtention de cette note.",
                              textStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                              child: ImpactStat(
                                impact: widget.stats.calculateGlobalAverageImpact(),
                                label: "points de moyenne générale (à l'obtention).",
                              ),
                            ),
                            SizedBox(height: screenSize.size.height / 10 * 0.1),
                            Tooltip(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11), color: Theme.of(context).primaryColorLight),
                              margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.7),
                              message:
                                  "Indique le nombre de points d'impact sur la moyenne générale avec ou sans la note.",
                              textStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                              child: ImpactStat(
                                impact: widget.stats.calculateGlobalAverageImpactOverall(),
                                label: "points de moyenne générale (tout le temps).",
                              ),
                            ),
                            SizedBox(height: screenSize.size.height / 10 * 0.1),
                            Text(
                              "A venir...",
                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.5)),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            )),
      ],
    );
  }
}
