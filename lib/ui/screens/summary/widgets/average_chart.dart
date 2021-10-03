import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/stats/grades_stats.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SummaryChart extends StatefulWidget {
  const SummaryChart({
    Key? key,
  }) : super(key: key);
  @override
  SummaryChartState createState() => SummaryChartState();
}

class SummaryChartState extends State<SummaryChart> with LayoutMixin {
  List<double>? lastAverages;
  List<double>? _averages = [];
  int maxGradesCount = 10;

  LineChartData avgData() {
    return LineChartData(
      clipData: FlClipData.horizontal(),
      backgroundColor: Colors.transparent,
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.colors.primary.lightColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: theme.colors.primary.lightColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          interval: 1.0,
          showTitles: true,
          reservedSize: 5.vw.clamp(0, 90),
          getTextStyles: (value) => TextStyle(
            color: theme.colors.foregroundLightColor,
            fontWeight: FontWeight.bold,
            fontSize: YScale.s3,
          ),
          getTitles: (value) {
            double max = getMax();
            double min = getMin();
            if (value.roundToDouble() == max.roundToDouble()) {
              return max.toStringAsFixed(0);
            }
            if (value.roundToDouble() == min.roundToDouble()) {
              return min.toStringAsFixed(0);
            }
            return '';
          },
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: theme.colors.primary.lightColor, width: 1)),
      minX: 0,
      maxX: ((_averages ?? []).length > maxGradesCount ? maxGradesCount : (_averages ?? []).length).toDouble() - 1,
      minY: (getMin() > 0 ? ((getMin() ?? 1) - 1) : getMin()).round().toDouble(),
      maxY: (getMax() + 1).round().toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(((_averages ?? []).length > maxGradesCount ? maxGradesCount : (_averages ?? []).length),
              (index) => FlSpot(index.toDouble(), double.parse((_averages ?? [])[index].toStringAsFixed(2)))),
          isCurved: true,
          colors: [theme.colors.primary.backgroundColor],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    maxGradesCount = isLargeScreen ? 12 : 6;

    return ChangeNotifierProvider<GradesController>.value(
        value: appSys.gradesController,
        child: Consumer<GradesController>(builder: (context, model, child) {
          GradesStats stats = GradesStats(
              allGrades: getAllGrades(appSys.gradesController.disciplines(showAll: true),
                  overrideLimit: true, sortByWritingDate: true));
          lastAverages = stats.lastAverages();
          return (_averages != null && ((_averages ?? []).isNotEmpty))
              ? LineChart(
                  avgData(),
                )
              : Container();
        }));
  }

  @override
  void didUpdateWidget(SummaryChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    initGrades();
  }

  getMax() {
    List<double> values = (_averages ?? []);
    //Reduce values size
    values = values.sublist(0, ((_averages ?? []).length > maxGradesCount ? maxGradesCount : (_averages ?? []).length));
    values.removeWhere((element) => element == -1000.0);
    if (values.isNotEmpty) {
      return (values).reduce(max);
    } else {
      return 20;
    }
  }

  getMin() {
    List<double> values = (_averages ?? []);
    //Reduce values size
    values = values.sublist(0, ((_averages ?? []).length > maxGradesCount ? maxGradesCount : (_averages ?? []).length));
    values.removeWhere((element) => element == -1000.0);
    if (values.isNotEmpty) {
      return values.reduce(min);
    } else {
      return 0;
    }
  }

  initGrades() {
    if (lastAverages != null) {
      setState(() {
        (_averages ?? []).clear();
        (_averages ?? []).addAll(lastAverages!);
        if ((_averages ?? []).length > maxGradesCount) {
          _averages = (_averages ?? []).sublist((_averages ?? []).length - maxGradesCount, (_averages ?? []).length);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initGrades();

    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          maxGradesCount = isLargeScreen ? 18 : 10;
          initGrades();
        }));
  }
}
