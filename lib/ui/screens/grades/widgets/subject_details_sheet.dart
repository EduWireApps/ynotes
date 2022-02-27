import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes/ui/screens/grades/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SubjectDetailsSheet extends StatefulWidget {
  final Subject subject;
  final double average;
  final Period period;
  final bool simulate;
  const SubjectDetailsSheet(
      {Key? key, required this.subject, required this.average, required this.period, required this.simulate})
      : super(key: key);

  @override
  _SubjectDetailsSheetState createState() => _SubjectDetailsSheetState();
}

class _SubjectDetailsSheetState extends State<SubjectDetailsSheet> {
  Subject get subject => widget.subject;
  List<Grade> get grades => subject.sortedGrades.where((grade) => !grade.custom).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s4),
      child: Column(
        children: [
          _AverageContainer(subject, widget.average),
          YVerticalSpacer(YScale.s2),
          Text(
            subject.name,
            style: theme.texts.title,
            textAlign: TextAlign.center,
          ),
          YVerticalSpacer(YScale.s1),
          Text(subject.teachers,
              style: theme.texts.body1.copyWith(color: subject.color.backgroundColor), textAlign: TextAlign.center),
          YVerticalSpacer(YScale.s6),
          _ClassData(
            subject: subject,
            average: widget.average,
            simulate: widget.simulate,
          ),
          if (grades.length > 1)
            Column(
              children: [
                YVerticalSpacer(YScale.s16),
                _Chart(subject: subject, grades: grades),
                YVerticalSpacer(YScale.s10),
                _Legend(subject: subject)
              ],
            ),
          YVerticalSpacer(YScale.s6),
          YButton(
            onPressed: () async {
              final YTColor? color = await AppDialogs.showColorPickerDialog(context, color: subject.color);
              if (color != null) {
                subject.color = color;
                setState(() {});
                schoolApi.gradesModule.updateSubject(subject);
              }
            },
            text: "COULEUR",
            icon: Icons.color_lens_rounded,
            color: YColor.secondary,
          )
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Subject subject;

  const _Legend({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        line(theme.colors.primary.backgroundColor, "Notes"),
        YVerticalSpacer(YScale.s2),
        line(subject.color.backgroundColor, "Moyennes de la classe"),
      ],
    );
  }

  Widget line(Color color, String label) {
    return Row(
      children: [
        Container(width: YScale.s8, height: YScale.s1, color: color),
        YHorizontalSpacer(YScale.s2),
        Text(label, style: theme.texts.body1),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  final List<Grade> grades;
  final Subject subject;

  const _Chart({Key? key, required this.subject, required this.grades}) : super(key: key);

  List<double> get gradesValues => grades.map((e) => e.realValue).toList();
  List<double> get classAverages => grades.map((e) => e.classAverage).toList();
  double get minY => ([...gradesValues, ...classAverages].reduce(min) - .5).round().toDouble();
  double get maxY => ([...gradesValues, ...classAverages].reduce(max)).round().toDouble();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: YScale.s24,
      child: LineChart(LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: false,
        ),
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: theme.colors.backgroundLightColor,
                tooltipRoundedRadius: YScale.s2,
                getTooltipItems: (spots) => spots
                    .map((spot) => LineTooltipItem(spot.y.toString(), TextStyle(color: theme.colors.foregroundColor)))
                    .toList())),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(showTitles: false),
          leftTitles: SideTitles(
            interval: 2,
            showTitles: true,
            getTextStyles: (contect, _) => theme.texts.body2,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(gradesValues.length, (index) => FlSpot(index.toDouble(), gradesValues[index])),
            isCurved: true,
            colors: [theme.colors.primary.backgroundColor],
            barWidth: YScale.s1,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: [theme.colors.primary.lightColor.withOpacity(.2)],
            ),
          ),
          LineChartBarData(
            spots: List.generate(classAverages.length, (index) => FlSpot(index.toDouble(), classAverages[index])),
            isCurved: true,
            colors: [subject.color.backgroundColor],
            barWidth: YScale.s1,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: [subject.color.lightColor.withOpacity(.2)],
            ),
          ),
        ],
      )),
    );
  }
}

class _ClassData extends StatelessWidget {
  const _ClassData({Key? key, required this.subject, required this.average, required this.simulate}) : super(key: key);

  final Subject subject;
  final double average;
  final bool simulate;

  bool sameAverages(double a, double b) {
    if (a.isNaN && b.isNaN) {
      return true;
    } else if ((a.isNaN && !b.isNaN) || (!a.isNaN && b.isNaN)) {
      return false;
    } else {
      return a == b;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: YScale.s4, runSpacing: YScale.s2, children: [
      ...[
        ["CLASSE", subject.classAverage.display()],
        ["MAX", subject.maxAverage.display()],
        ["MIN", subject.minAverage.display()]
      ].map((e) => _Data(label: e[0], value: e[1])).toList(),
      if (!simulate && !sameAverages(average, subject.average)) const OutdatedDataWarning(),
    ]);
  }
}

class _Data extends StatelessWidget {
  final String label;
  final String value;

  const _Data({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: theme.colors.backgroundLightColor, borderRadius: YBorderRadius.xl),
      padding: YPadding.p(YScale.s2),
      width: YScale.s16,
      child: Column(
        children: [
          Text(label, style: theme.texts.body2),
          YVerticalSpacer(YScale.s1),
          Text(value,
              style: theme.texts.body1.copyWith(fontWeight: YFontWeight.semibold, color: theme.colors.foregroundColor)),
        ],
      ),
    );
  }
}

class _AverageContainer extends StatelessWidget {
  final Subject subject;
  final double average;
  const _AverageContainer(
    this.subject,
    this.average, {
    Key? key,
  }) : super(key: key);

  YTColor get color => subject.color;

  Widget bubble(String text, [bool danger = false]) {
    final Color backgroundColor = danger ? theme.colors.danger.backgroundColor : theme.colors.foregroundColor;
    final Color foregroundColor = danger ? theme.colors.danger.foregroundColor : theme.colors.backgroundColor;
    return Container(
      height: YScale.s4,
      padding: YPadding.px(YScale.s1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: YBorderRadius.full,
      ),
      child: AutoSizeText(
        text,
        style: theme.texts.body2.copyWith(fontWeight: YFontWeight.bold, color: foregroundColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius _borderRadius = YBorderRadius.xl;
    return Container(
        padding: YPadding.p(YScale.s1),
        decoration: BoxDecoration(color: color.backgroundColor, borderRadius: _borderRadius),
        child: SizedBox(
          width: YScale.s10,
          height: YScale.s10,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AutoSizeText(
                average.display(),
                style: TextStyle(
                  fontWeight: YFontWeight.semibold,
                  color: color.foregroundColor,
                  fontSize: YFontSize.xl,
                ),
                softWrap: false,
              ),
              if (subject.coefficient != 1)
                Positioned(top: -YScale.s2p5, right: -YScale.s2p5, child: bubble(subject.coefficient.display(), true)),
            ],
          ),
        ));
  }
}
