import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/stats/grades_stats.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/column_generator.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/useful_methods.dart';

import 'disciplines_modal_bottom_sheet.dart';
import 'grades_modal_bottom_sheet.dart';

class GradesGroup extends StatefulWidget {
  final Discipline? discipline;
  final GradesController? gradesController;
  const GradesGroup({this.discipline, this.gradesController});
  State<StatefulWidget> createState() {
    return _GradesGroupState();
  }
}

class _GradesGroupState extends State<GradesGroup> {
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    String? capitalizedNomDiscipline;
    String? nomsProfesseurs;
    Color? colorGroup;
    void callback() {
      setState(() {
        colorGroup = Color(widget.discipline!.color!);
      });
    }

    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColorDark;
      nomsProfesseurs = null;
      capitalizedNomDiscipline = null;
    } else {
      String nomDiscipline = widget.discipline!.disciplineName!.toLowerCase();
      capitalizedNomDiscipline = "${nomDiscipline[0].toUpperCase()}${nomDiscipline.substring(1)}";
      if (widget.discipline!.color != null) {
        colorGroup = Color(widget.discipline!.color!);
      }
      if (widget.discipline!.teachers!.length > 0) {
        nomsProfesseurs = widget.discipline!.teachers![0];
        if (nomsProfesseurs != null) {
          widget.discipline!.teachers!.forEach((element) {
            if (widget.discipline!.teachers!.indexOf(element) > 0) {
              nomsProfesseurs = nomsProfesseurs! + " / " + element!;
            }
          });
        }
      }
    }

    double impact = 0.0;
    bool largeScreen = screenSize.size.width > 500;
    double getWidthConstraints() {
      if (largeScreen) {
        if (screenSize.size.width > 800) {
          return ((screenSize.size.width - 310) / 2.2);
        } else {
          return 480;
        }
      } else {
        return 1500;
      }
    }

    //BLOCK BUILDER
    return ChangeNotifierProvider<GradesController>.value(
      value: appSys.gradesController,
      child: Consumer<GradesController>(builder: (context, model, _widget) {
        if (getGradesForDiscipline(0) != null && getGradesForDiscipline(0)!.length > 0) {
          List<Grade> grades = getGradesForDiscipline(0)!;
          grades.sort((a, b) => b.entryDate!.compareTo(a.entryDate!));
          GradesStats stats = GradesStats(grade: grades.first, allGrades: grades);
          impact = stats.calculateAverageImpact();
        }
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: getWidthConstraints()),
          child: Column(
            children: <Widget>[
              //Label
              Container(
                child: Material(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(largeScreen ? 25 : 15),
                      topRight: Radius.circular(largeScreen ? 25 : 15)),
                  color: colorGroup,
                  child: InkWell(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(largeScreen ? 25 : 15),
                        topRight: Radius.circular(largeScreen ? 25 : 15)),
                    onTap: () {
                      if (widget.discipline != null) {
                        disciplineModalBottomSheet(context, widget.discipline, callback, this.widget);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: (screenSize.size.height / 10 * 0.1), horizontal: screenSize.size.width / 5 * 0.1),
                      decoration: BoxDecoration(border: Border.all(width: 0.0, color: Colors.transparent)),
                      child: Stack(children: <Widget>[
                        if (widget.discipline != null && capitalizedNomDiscipline != null)
                          Container(
                            child: Row(
                              children: [
                                buildVariation(impact),
                                SizedBox(
                                  width: screenSize.size.width / 5 * 0.1,
                                ),
                                Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Text(
                                        ((appSys.settings.system.chosenParser == 1)
                                            ? (widget.discipline!.average ?? "-")
                                            : ((!widget.discipline!.getAverage().isNaN)
                                                ? widget.discipline!.getAverage().toString()
                                                : widget.discipline!.average ?? "-")),
                                        style: TextStyle(fontFamily: "Asap", fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                SizedBox(
                                  width: screenSize.size.width / 5 * 0.1,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      capitalizedNomDiscipline,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "Asap",
                                          fontWeight: FontWeight.w400,
                                          fontSize: screenSize.size.height / 10 * 0.2),
                                    ),
                                  ),
                                ),
                                Icon(MdiIcons.information, color: ThemeUtils.textColor(revert: true).withOpacity(0.8))
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
                                  margin: EdgeInsets.only(left: 0, bottom: 10),
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

              //Body with columns
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(largeScreen ? 25 : 15),
                    bottomRight: Radius.circular(largeScreen ? 25 : 15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(largeScreen ? 25 : 15),
                    bottomRight: Radius.circular(largeScreen ? 25 : 15),
                  ),
                  child: ColumnBuilder(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    itemCount: (widget.discipline?.subdisciplineCodes != null &&
                            widget.discipline!.subdisciplineCodes!.length > 0)
                        ? widget.discipline!.subdisciplineCodes!.length
                        : 1,
                    itemBuilder: (context, index) {
                      return gradesList(index);
                    },
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget buildVariation(double impact) {
    getIcon() {
      if (impact.isNaN || impact == 0) {
        return MdiIcons.minusThick;
      }
      if (impact < 0) {
        return MdiIcons.chevronDown;
      } else {
        return MdiIcons.chevronUp;
      }
    }

    getAdaptedColor() {
      if (impact.isNaN || impact == 0) {
        return Color(0xffA7E5C1);
      }
      if (impact < 0) {
        return Color(0xffDCBDBD);
      } else {
        return Color(0xffA7E5C1);
      }
    }

    getAdaptedIconColor() {
      if (impact.isNaN || impact == 0) {
        return Color(0xffC59A1A);
      }
      if (impact < 0) {
        return Color(0xffEB5757);
      } else {
        return Color(0xff219653);
      }
    }

    return Container(
      width: 28,
      height: 28,
      padding: EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: getAdaptedColor(), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
              child: Icon(
            getIcon(),
            color: getAdaptedIconColor(),
          )),
        ],
      ),
    );
  }

  List<Grade>? getGradesForDiscipline(int sousMatiereIndex) {
    List<Grade> toReturn = [];

    if (widget.discipline != null) {
      widget.discipline!.gradesList!.forEach((element) {
        if (widget.discipline!.subdisciplineCodes!.length > 1) {
          if (element.subdisciplineCode == widget.discipline!.subdisciplineCodes![sousMatiereIndex]) {
            toReturn.add(element);
          }
        } else {
          toReturn.add(element);
        }
      });
      return toReturn;
    } else {
      return null;
    }
  }

  //MARKS LIST VIEW
  gradesList(int sousMatiereIndex) {
    void callback() {
      setState(() {});
    }

    // ignore: unused_local_variable
    bool canShow = false;
    List<Grade>? gradesForSelectedDiscipline = getGradesForDiscipline(sousMatiereIndex);
    if (gradesForSelectedDiscipline != null) {
      gradesForSelectedDiscipline.sort((a, b) => b.entryDate!.compareTo(a.entryDate!));
    }
    if (gradesForSelectedDiscipline != null) {
      gradesForSelectedDiscipline = gradesForSelectedDiscipline.reversed.toList();
    }

    // ignore: unused_local_variable
    Color? colorGroup;
    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColorDark;
    } else {
      if (widget.discipline!.color != null) {
        colorGroup = Color(widget.discipline!.color!);
      }
    }

    MediaQueryData screenSize = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Used to fullfill size
        Divider(
          thickness: 0,
          height: 0,
          indent: 0,
          endIndent: 0,
          color: Colors.transparent,
        ),
        if (widget.discipline?.subdisciplineNames != null &&
            widget.discipline!.subdisciplineNames!.length - 1 >= sousMatiereIndex &&
            gradesForSelectedDiscipline != null &&
            gradesForSelectedDiscipline.length > 0)
          if (sousMatiereIndex > 0)
            Divider(
              thickness: 2,
            ),
        if (widget.discipline?.subdisciplineNames != null &&
            widget.discipline!.subdisciplineNames!.length - 1 >= sousMatiereIndex &&
            gradesForSelectedDiscipline != null &&
            gradesForSelectedDiscipline.length > 0)
          Center(
              child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    widget.discipline!.subdisciplineNames![sousMatiereIndex] ?? "N/A",
                    style: TextStyle(
                      fontFamily: "Asap",
                      color: ThemeUtils.textColor(),
                    ),
                  ))),
        Wrap(
          spacing: screenSize.size.width / 5 * 0.05,
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: List.generate(gradesForSelectedDiscipline?.length ?? 0, (index) {
            if (gradesForSelectedDiscipline != null) {
              return Material(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Theme.of(context).primaryColorDark,
                  hoverColor: Theme.of(context).primaryColorDark,
                  highlightColor: Theme.of(context).primaryColorDark,
                  onLongPress: () {
                    CustomDialogs.showShareGradeDialog(context, gradesForSelectedDiscipline![index]);
                  },
                  onTap: () {
                    GradesStats stats = GradesStats(
                       grade: gradesForSelectedDiscipline![index],
                        allGrades:getAllGrades(widget.gradesController!.disciplines(),
                            overrideLimit: true, sortByWritingDate: false));
                    gradesModalBottomSheet(context, gradesForSelectedDiscipline[index], stats, widget.discipline,
                        callback, this.widget, widget.gradesController);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //Grades
                        AutoSizeText.rich(
                          //MARK
                          TextSpan(
                            text: (gradesForSelectedDiscipline[index].notSignificant!
                                ? "(" + gradesForSelectedDiscipline[index].value!
                                : gradesForSelectedDiscipline[index].value),
                            style: TextStyle(
                                color: (gradesForSelectedDiscipline[index].simulated ?? false)
                                    ? Colors.blue
                                    : ThemeUtils.textColor(),
                                fontFamily: "Asap",
                                fontWeight: FontWeight.bold,
                                fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3),
                            children: <TextSpan>[
                              if (gradesForSelectedDiscipline[index].scale != "20")

                                //MARK ON
                                TextSpan(
                                    text: '/' + gradesForSelectedDiscipline[index].scale!,
                                    style: TextStyle(
                                        color: (gradesForSelectedDiscipline[index].simulated ?? false)
                                            ? Colors.blue
                                            : ThemeUtils.textColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2)),
                              if (gradesForSelectedDiscipline[index].notSignificant == true)
                                TextSpan(
                                    text: ")",
                                    style: TextStyle(
                                        color: (gradesForSelectedDiscipline[index].simulated ?? false)
                                            ? Colors.blue
                                            : ThemeUtils.textColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3)),
                            ],
                          ),
                          style: TextStyle(
                              decoration: (CalendarTime(gradesForSelectedDiscipline[index].entryDate).isToday &&
                                      !(gradesForSelectedDiscipline[index].simulated ?? false))
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationThickness: 1.9,
                              decorationColor: Colors.blue),
                        ),
                        //COEFF
                        if (gradesForSelectedDiscipline[index].weight != "1")
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: AutoSizeText(
                                  gradesForSelectedDiscipline[index].weight!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      color: (gradesForSelectedDiscipline[index].simulated ?? false)
                                          ? Colors.blue
                                          : ThemeUtils.textColor(),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
        ),
      ],
    );
  }
}
