import 'package:flutter/material.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/extensions.dart';
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
  List<Grade> get grades =>
      module.currentPeriod?.sortedGrades.where((grade) => grade.significant && !grade.custom).toList() ?? [];

  List<ChartElement> get chartElements {
    final List<Grade> fetchedGrades = grades;
    final Map<int, List<Grade>> gradesByWeekMap = {};
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
    final List<ChartElement> elements = gradesByWeekList.asMap().entries.map((entry) {
      final int i = entry.key;
      int index = entry.key;
      List<Grade> grades = [];
      // We add grades from the previous weeks to the lsit
      while (!index.isNegative) {
        grades = [...grades, ...gradesByWeekList[index]];
        index -= 1;
      }
      final double avg = module.calculateAverageFromGrades(grades, bySubject: true);
      return ChartElement(
          value: avg,
          text:
              "${gradesByWeekList[i].last.date.day.toString().padLeft(2, '0')}/${gradesByWeekList[i].last.date.month.toString().padLeft(2, '0')}");
    }).toList();
    return elements;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierConsumer<GradesModule>(
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
                              if (grades.length > 1) Expanded(child: GradesChart(chartElements)),
                              YHorizontalSpacer(r<double>(def: YScale.s6, lg: YScale.s12)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(chartElements.last.value.display(),
                                      style: theme.texts.data1.copyWith(
                                          fontSize:
                                              r<double>(def: YFontSize.xl2, lg: YFontSize.xl3, xl: YFontSize.xl4))),
                                  Text("Moyenne", style: theme.texts.body2),
                                  YVerticalSpacer(YScale.s4),
                                  if (module.currentPeriod != null)
                                    _DiffText(module.calculateAverageFromGrades(grades, bySubject: true) -
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
                                  ...module.currentPeriod!.sortedGrades
                                      .where((grade) => !grade.custom)
                                      .map((grade) => Row(
                                            children: [GradeContainer(grade), YHorizontalSpacer(YScale.s4)],
                                          ))
                                      .toList()
                                      .reversed
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
                  onPressed: () async => await module.fetch(),
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
    return Text("$sign${value.asFixed(2).display()}", style: theme.texts.title.copyWith(color: color));
  }
}
