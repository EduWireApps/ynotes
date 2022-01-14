import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/legacy/theme_utils.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

Future<Grade?> simulatorModalBottomSheet(
  GradesController? gradesController,
  BuildContext context,
) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SimulatorModalBottomSheet(
          gradesController: gradesController,
        );
      });
}

class SimulatorModalBottomSheet extends StatefulWidget {
  final GradesController? gradesController;

  const SimulatorModalBottomSheet({
    Key? key,
    this.gradesController,
  }) : super(key: key);
  @override
  _SimulatorModalBottomSheetState createState() => _SimulatorModalBottomSheetState();
}

class _SimulatorModalBottomSheetState extends State<SimulatorModalBottomSheet> {
  //Grade attributes

  //Chosen discipline
  Discipline? disciplineChoice;
  double? gradeValue;
  double gradeOn = 20;
  double gradeWeight = 1;

  //Chose "coefficient"
  bool open = false;

//Chose "coefficient"
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Wrap(alignment: WrapAlignment.center, children: [
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                color: Theme.of(context).primaryColor),
            padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenSize.size.height / 10 * 0.1),
                const DragHandle(),
                SizedBox(height: screenSize.size.height / 10 * 0.1),
                editorFields(context)
              ],
            )),
      )
    ]);
  }

  Widget dropdown(List<Discipline>? disciplines) {
    var screenSize = MediaQuery.of(context);

    List<Discipline?>? choices;
    //Add disciplines in choices
    if (disciplines != null) {
      choices = [];
      choices.clear();
      for (var element in disciplines) {
        choices.add(element);
      }
      choices.add(null);
      CustomLogger.log("BOTTOM SHEET", "(Simulator) Choices: $choices");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Matière",
          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
        ),
        Container(
          child: (disciplines == null)
              ? Text(
                  "Pas de periode",
                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                  height: YScale.s12,
                  decoration:
                      BoxDecoration(borderRadius: YBorderRadius.md, color: theme.colors.secondary.backgroundColor),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Theme.of(context).primaryColorDark,
                            ),
                            child: (choices == null)
                                ? Text(
                                    "Pas de matières",
                                    style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                  )
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton<Discipline>(
                                      value: disciplineChoice,
                                      iconEnabledColor: ThemeUtils.textColor(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Asap",
                                        color: ThemeUtils.textColor(),
                                      ),
                                      onChanged: (Discipline? newValue) {
                                        setState(() {
                                          disciplineChoice = newValue;
                                        });
                                      },
                                      focusColor: Theme.of(context).primaryColor,
                                      items:
                                          choices.toSet().map<DropdownMenuItem<Discipline>>((Discipline? discipline) {
                                        return DropdownMenuItem<Discipline>(
                                          value: discipline,
                                          child: Center(
                                            child: Text(
                                              discipline != null ? discipline.disciplineName! : "-",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: "Asap",
                                                color: ThemeUtils.textColor(),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ))
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  ///Returns a widget containing free fields to edit a grade
  Widget editorFields(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return SizedBox(
      height: screenSize.size.height / 5 * 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: screenSize.size.height / 5 * 0.1),
            height: screenSize.size.height / 5 * 0.5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: dropdown(widget.gradesController!.disciplines())),
                YHorizontalSpacer(YScale.s2p5),
                Expanded(child: weightSelector()),
              ],
            ),
          ),
          YVerticalSpacer(YScale.s4),
          gradeOnSelector(),
          Container(
            margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.25),
            child: YButton(
                onPressed: () async {
                  CustomLogger.log("BOTTOM SHEET", "(Simulator) Period name: ${disciplineChoice!.periodName}");

                  if (gradeValue != null && disciplineChoice != null) {
                    if (gradeValue! > gradeOn) {
                      CustomDialogs.showAnyDialog(context, "La note doit être inférieure à la note maximale possible");
                    } else {
                      Grade finalGrade = Grade(
                          date: DateTime.now(),
                          entryDate: DateTime.now(),
                          value: gradeValue.toString(),
                          scale: gradeOn.toString(),
                          simulated: true,
                          notSignificant: false,
                          letters: false,
                          subdisciplineCode: (disciplineChoice!.subdisciplineCodes != null &&
                                  disciplineChoice!.subdisciplineCodes!.isNotEmpty)
                              ? disciplineChoice!.subdisciplineCodes![0]
                              : null,
                          weight: gradeWeight.toString(),
                          periodName: disciplineChoice!.periodName,
                          periodCode: widget.gradesController!.periods!
                              .firstWhere((period) => period.name == disciplineChoice!.periodName)
                              .id
                              .toString(),
                          disciplineName: disciplineChoice!.disciplineName,
                          disciplineCode: disciplineChoice!.disciplineCode);
                      Navigator.of(context).pop(finalGrade);
                    }
                  } else {
                    CustomDialogs.showAnyDialog(context, "Remplissez tous les champs");
                  }
                },
                text: "Ajouter",
                icon: MdiIcons.flaskEmptyPlus,
                color: YColor.info),
          )
        ],
      ),
    );
  }

  Widget gradeOnSelector() {
    var screenSize = MediaQuery.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: YButton(
                onPressed: () async {
                  var temp = await CustomDialogs.showNumberChoiceDialog(context, isDouble: true, text: "votre note");
                  if (temp != null) {
                    setState(() {
                      gradeValue = temp;
                    });
                  }
                },
                text: gradeValue != null ? gradeValue.toString() : "--",
                color: YColor.secondary)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
          child: Text(
            "/",
            style: TextStyle(
                fontFamily: "Asap",
                color: ThemeUtils.textColor(),
                fontSize: YFontSize.xl,
                fontWeight: YFontWeight.bold),
          ),
        ),
        Expanded(
            child: YButton(
          onPressed: () async {
            var temp = await CustomDialogs.showNumberChoiceDialog(context, isDouble: true, text: "la note maximale");
            if (temp != null) {
              setState(() {
                gradeOn = temp;
              });
            }
          },
          text: gradeOn.toString(),
          color: YColor.secondary,
        )),
      ],
    );
  }

  Widget weightSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Coefficient",
          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
          textAlign: TextAlign.center,
        ),
        YButton(
            onPressed: () async {
              var temp = await CustomDialogs.showNumberChoiceDialog(context, isDouble: true, text: "coefficient");
              if (temp != null) {
                setState(() {
                  gradeWeight = temp;
                });
              }
            },
            text: gradeWeight.toString(),
            color: YColor.secondary,
            block: true),
      ],
    );
  }
}
