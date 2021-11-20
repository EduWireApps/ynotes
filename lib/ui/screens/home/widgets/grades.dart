import 'package:fl_chart/fl_chart.dart';
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
    controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<GradesController>(
        controller: controller,
        builder: (context, controller, _) {
          final List<Grade> grades =
              (getAllGrades(controller.disciplines(showAll: true), overrideLimit: true, sortByWritingDate: false) ?? [])
                ..sort((a, b) => a.date!.compareTo(b.date!));
          final DateTime now = DateTime.now();
          // grades from now - 1 month
          final List<Grade> gradesOfMonth =
              grades.where((grade) => grade.date!.compareTo(DateTime(now.year, now.month - 1, now.day)) >= 0).toList();
          // for (var y in x) {
          //   print("${y.testName} ${y.date} ${y.value}");
          // }
          print(now.weekyear);
          final List<Grade> remainingGrades = grades.reversed.toList().sublist(0, grades.length - gradesOfMonth.length);
          Map<int, List<Grade>> gradesByWeekMap = {};
          for (var grade in gradesOfMonth) {
            if (gradesByWeekMap.containsKey(grade.date!.weekyear)) {
              gradesByWeekMap[grade.date!.weekyear]!.add(grade);
            } else {
              gradesByWeekMap[grade.date!.weekyear] = [grade];
            }
          }
          print(gradesByWeekMap);
          final List<List<Grade>> gradesByWeekList = gradesByWeekMap.entries.map((e) => e.value).toList();
          print(gradesByWeekList);
          final List<double> averages = gradesByWeekList.asMap().entries.map((entry) {
            int index = entry.key;
            List<Grade> localGrades = remainingGrades;
            while (!index.isNegative) {
              localGrades = [...localGrades, ...gradesByWeekList[index]];
              index -= 1;
            }
            localGrades = localGrades.where((g) => (g.notSignificant ?? false) == false).toList();
            double n = 0.0;
            double d = 0.0;
            for (var g in localGrades) {
              n += double.parse(g.value!.replaceAll(",", ".")) * double.parse(g.value!.replaceAll(",", "."));
              d += double.parse(g.value!.replaceAll(",", "."));
            }
            return double.parse((n / d).toStringAsFixed(2));
          }).toList();
          print(averages); // TODO: check why the values are not correct
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: YPadding.p(YScale.s4),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("notes"),
                    SizedBox(
                      height: 200,
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        if (gradesOfMonth.isNotEmpty) Expanded(child: _Chart(gradesOfMonth)),
                        Expanded(child: Text("data"))
                      ]),
                    )
                  ])),
              const YDivider()
            ],
          );
        });
  }
}

class _Chart extends StatelessWidget {
  final List<Grade> grades;
  const _Chart(this.grades, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(showTitles: true, getTitles: (value) => grades[value.toInt()].testName ?? ""),
        leftTitles: SideTitles(
          interval: 1.0,
          showTitles: true,
          getTextStyles: (value) => theme.texts.body2,
          // getTitles: (value) {
          //   double max = getMax();
          //   double min = getMin();
          //   if (value.roundToDouble() == max.roundToDouble()) {
          //     return max.toStringAsFixed(0);
          //   }
          //   if (value.roundToDouble() == min.roundToDouble()) {
          //     return min.toStringAsFixed(0);
          //   }
          //   return '';
          // },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(grades.length,
              (index) => FlSpot(index.toDouble(), double.parse(grades[index].value!.replaceAll(",", ".")))),
          isCurved: true,
          colors: [theme.colors.primary.backgroundColor],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    ));
  }
}
