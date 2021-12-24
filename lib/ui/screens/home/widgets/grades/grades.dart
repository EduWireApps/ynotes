import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/core_new/api.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/home/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class GradesSection extends StatefulWidget {
  const GradesSection({Key? key}) : super(key: key);

  @override
  _GradesSectionState createState() => _GradesSectionState();
}

class _GradesSectionState extends State<GradesSection> {
  final GradesModule module = schoolApi.gradesModule;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      module.fetch();
    });
  }

  // We get all grades and sort them by entryDate
  List<Grade> get grades => module.grades.where((grade) => grade.significant).toList();
/*
  double calculateGlobalAverage(List<Grade> grades) {
    // Will keep the averages of the disciplines
    final List<double> avgs = [];
    grades = grades.where((grade) => double.tryParse(grade.value!.replaceAll(",", ".")) != null).toList();
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
        if (d != 0.0) {
          avgs.add(double.parse((n / d).toStringAsFixed(2)));
        }
      }
    }
    // We calculate the average of the averages
    double sum = 0.0;
    for (var element in avgs) {
      sum += element;
    }
    return double.parse((sum / avgs.length).toStringAsFixed(2));
  }*/

  List<ChartElement> get chartElements {
    final List<Grade> fetchedGrades = grades;
    // We prepare the map used to store grades by week
    final Map<int, List<Grade>> gradesByWeekMap = {};
    // We put all grades in the map
    for (final grade in fetchedGrades) {
      if (gradesByWeekMap.containsKey(grade.entryDate.weekyear)) {
        gradesByWeekMap[grade.entryDate.weekyear]!.add(grade);
      } else {
        gradesByWeekMap[grade.entryDate.weekyear] = [grade];
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
      // final double avg = module.calculateAverageFromGrades(grades);
      final double avg = module.calculateAverageFromGrades(grades, bySubject: true);
      return ChartElement(
          value: avg,
          text:
              "${gradesByWeekList[i].last.date.day.toString().padLeft(2, '0')}/${gradesByWeekList[i].last.date.month.toString().padLeft(2, '0')}");
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<GradesModule>(
        controller: module,
        builder: (context, module, _) {
          return chartElements.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  if (module.currentPeriod != null)
                                    _DiffText(module.calculateAverageFromPeriod(module.currentPeriod!) -
                                        module.calculateAverageFromGrades(grades.sublist(0, grades.length - 1),
                                            bySubject: true)),
                                  Text("Dernière note", style: theme.texts.body2),
                                ],
                              )
                            ]),
                          )
                        ])),
                    if (module.currentPeriod != null)
                      Padding(
                          padding: YPadding.py(YScale.s4),
                          child: ScrollConfiguration(
                            behavior: DragScrollBehavior(),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  YHorizontalSpacer(YScale.s4),
                                  ...module.currentPeriod!
                                      .grades(module.grades)
                                      .map((grade) => Row(
                                            children: [GradeContainer(grade), YHorizontalSpacer(YScale.s4)],
                                          ))
                                      .toList()
                                ],
                              ),
                            ),
                          )),
                    const YDivider(),
                  ],
                )
              : EmptyState(
                  iconRoutePath: "/grades",
                  onPressed: () async => await module.fetch(online: true),
                  text: "Pas de notes... Et bah alors ça bosse pas ? ;)",
                  loading: module.isFetching);
        });
  }
}

class _DiffText extends StatelessWidget {
  final double value;
  const _DiffText(this.value, {Key? key}) : super(key: key);

  String get sign => value >= 0 ? "+" : "";

  Color get color => value >= 0 ? theme.colors.success.backgroundColor : theme.colors.danger.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Text("$sign${value.toStringAsFixed(2)}", style: theme.texts.title.copyWith(color: color));
  }
}
