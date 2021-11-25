import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class ChartElement {
  final double value;
  final String text;

  const ChartElement({required this.value, required this.text});
}

class GradesChart extends StatelessWidget {
  final List<ChartElement> elements;
  const GradesChart(this.elements, {Key? key}) : super(key: key);

  List<ChartElement> get els =>
      elements.reversed.toList().sublist(0, min(elements.length - 1, r<int>(def: 4, sm: 6, lg: 8))).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      minY: (els.map((e) => e.value).reduce(min) - .5).round().toDouble(),
      maxY: (els.map((e) => e.value).reduce(max) + .5).round().toDouble(),
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
        bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) => els[value.toInt()].text,
            getTextStyles: (context, _) =>
                theme.texts.body2.copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold)),
        leftTitles: SideTitles(
          interval: 1,
          showTitles: true,
          getTextStyles: (contect, _) => theme.texts.body2,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(els.length, (index) => FlSpot(index.toDouble(), els[index].value)),
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
      ],
    ));
  }
}
