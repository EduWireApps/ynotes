import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

import 'widgets.dart';

class Grades extends StatefulWidget {
  const Grades({Key? key}) : super(key: key);

  @override
  _GradesState createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  final GradesController controller = appSys.gradesController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.refresh(force: true);
    });
  }

  // We get all grades and sort them by entryDate
  List<Grade> get grades =>
      (getAllGrades(controller.disciplines(), overrideLimit: true, sortByWritingDate: false) ?? [])
        ..sort((a, b) => a.entryDate!.compareTo(b.entryDate!));

  List<ChartElement> get chartElements {
    final List<Grade> fetchedGrades = grades;
    // We prepare the map used to store grades by week
    final Map<int, List<Grade>> gradesByWeekMap = {};
    // We put all grades in the map
    for (var grade in fetchedGrades) {
      if (gradesByWeekMap.containsKey(grade.entryDate!.weekyear)) {
        gradesByWeekMap[grade.entryDate!.weekyear]!.add(grade);
      } else {
        gradesByWeekMap[grade.entryDate!.weekyear] = [grade];
      }
    }
    // We turn the map into a list of lists
    final List<List<Grade>> gradesByWeekList = gradesByWeekMap.entries.map((e) => e.value).toList();
    // We return the chart elements
    return gradesByWeekList.asMap().entries.map((entry) {
      final int i = entry.key;
      int index = entry.key;
      List<Grade> grades = [];
      // We add grades from the previous weeks to the lsit
      while (!index.isNegative) {
        grades = [...grades, ...gradesByWeekList[index]];
        index -= 1;
      }
      // We only keep grades that are significant
      grades = grades.where((g) => (g.notSignificant ?? false) == false).toList();
      // Will keep the averages of the disciplines
      final List<double> avgs = [];
      // We iterate through each discipline
      for (final discipline in controller.disciplines()!) {
        // We get the grades for the current discipline
        final List<Grade> _grades =
            grades.where((element) => element.disciplineCode == discipline.disciplineCode).toList();
        // We caculate the weighted average from the grades and it to the averages list
        if (_grades.isNotEmpty) {
          double n = 0.0;
          double d = 0.0;
          for (var g in _grades) {
            n += (20 * double.parse(g.value!.replaceAll(",", ".")) / double.parse(g.scale!.replaceAll(",", "."))) *
                double.parse(g.weight!.replaceAll(",", "."));
            d += double.parse(g.weight!.replaceAll(",", "."));
          }
          avgs.add(double.parse((n / d).toStringAsFixed(2)));
        }
      }
      // We calculate the average of the averages
      double sum = 0.0;
      for (var element in avgs) {
        sum += element;
      }
      final double avg = double.parse((sum / avgs.length).toStringAsFixed(2));
      return ChartElement(
          value: avg,
          text:
              "${gradesByWeekList[i].last.date!.day.toString().padLeft(2, '0')}/${gradesByWeekList[i].last.date!.month.toString().padLeft(2, '0')}");
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<GradesController>(
        controller: controller,
        builder: (context, controller, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (chartElements.isNotEmpty)
                Padding(
                    padding: EdgeInsets.fromLTRB(YScale.s4, YScale.s4, YScale.s8, YScale.s4),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Notes", style: theme.texts.title),
                      YVerticalSpacer(YScale.s8),
                      SizedBox(
                        height: r<double>(def: YScale.s28, lg: YScale.s36, xl: YScale.s48),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          if (grades.isNotEmpty) Expanded(child: GradesChart(chartElements)),
                          YHorizontalSpacer(r<double>(def: YScale.s6, lg: YScale.s12)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(chartElements.last.value.toString(),
                                  style: theme.texts.title.copyWith(
                                      fontSize: r<double>(def: YFontSize.xl2, lg: YFontSize.xl3, xl: YFontSize.xl4),
                                      fontWeight: YFontWeight.extrabold)),
                              Text("Moyenne", style: theme.texts.body2),
                              YVerticalSpacer(YScale.s4),
                              Text(
                                  "+${(chartElements.last.value - chartElements[chartElements.length - 2].value).toStringAsFixed(2)}",
                                  style: theme.texts.title.copyWith(color: theme.colors.success.backgroundColor)),
                              Text("Semaine dernière", style: theme.texts.body2),
                            ],
                          )
                        ]),
                      )
                    ])),
              const YDivider()
            ],
          );
        });
  }
}
