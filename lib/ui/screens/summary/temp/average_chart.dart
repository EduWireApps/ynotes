import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_components/ynotes_components.dart';

class SummaryChart extends StatefulWidget {
  SummaryChart({
    Key? key,
  }) : super(key: key);
  @override
  SummaryChartState createState() => SummaryChartState();
}

class SummaryChartState extends State<SummaryChart> with LayoutMixin {
  List<Grade>? lastGrades;
  List<Grade>? _grades = [];
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
            color: currentTheme.colors.neutral.shade300,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: currentTheme.colors.neutral.shade300,
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
          getTextStyles: (value) => TextStyle(
            color: currentTheme.colors.neutral.shade400,
            fontWeight: FontWeight.bold,
            fontSize: 15,
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
      borderData: FlBorderData(show: true, border: Border.all(color: currentTheme.colors.neutral.shade300, width: 1)),
      minX: 0,
      maxX: ((_grades ?? []).length > maxGradesCount ? maxGradesCount : (_grades ?? []).length).toDouble() - 1,
      minY: (getMin() > 0 ? ((getMin() ?? 1) - 1) : getMin()).round().toDouble(),
      maxY: (getMax() + 1).round().toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(((_grades ?? []).length > maxGradesCount ? maxGradesCount : (_grades ?? []).length),
              (index) => FlSpot(index.toDouble(), toDouble((_grades ?? [])[index]))),
          isCurved: true,
          colors: [currentTheme.colors.primary.shade300],
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
          this.lastGrades =
              getAllGrades(model.disciplines(showAll: true), overrideLimit: true, sortByWritingDate: true);
          return (_grades != null && ((_grades ?? []).length != 0))
              ? AspectRatio(
                  aspectRatio: 3.5,
                  child: LineChart(
                    avgData(),
                  ),
                )
              : Container();
        }));
  }

  @override
  void didUpdateWidget(SummaryChart old) {
    super.didUpdateWidget(old);

    initGrades();
  }

  getMax() {
    List<double> values = (_grades ?? []).map((grade) {
      double a;
      try {
        a = double.parse(grade.value!.replaceAll(',', '.')) * 20 / double.parse(grade.scale!.replaceAll(',', '.'));
        return a;
      } catch (e) {
        //random value
        return -1000.0;
      }
    }).toList();
    //Reduce values size
    values = values.sublist(0, ((_grades ?? []).length > maxGradesCount ? maxGradesCount : (_grades ?? []).length));
    values.removeWhere((element) => element == -1000.0);
    if (values.length > 0) {
      return (values).reduce(max);
    } else {
      return 20;
    }
  }

  getMin() {
    List<double> values = (_grades ?? []).map((grade) {
      double a;
      try {
        a = double.parse(grade.value!.replaceAll(',', '.')) * 20 / double.parse(grade.scale!.replaceAll(',', '.'));
        return a;
      } catch (e) {
        //random value
        return -1000.0;
      }
    }).toList();
    //Reduce values size
    values = values.sublist(0, ((_grades ?? []).length > maxGradesCount ? maxGradesCount : (_grades ?? []).length));
    values.removeWhere((element) => element == -1000.0);
    if (values.length > 0) {
      return values.reduce(min);
    } else {
      return 0;
    }
  }

  initGrades() {
    if (this.lastGrades != null) {
      setState(() {
        (_grades ?? []).clear();
        (_grades ?? []).addAll(this.lastGrades!);
        (_grades ?? []).sort((a, b) => a.entryDate!.compareTo(b.entryDate!));
        (_grades ?? []).removeWhere(
            (element) => element.value == null || element.notSignificant! || element.simulated! || element.letters!);
        if ((_grades ?? []).length > maxGradesCount) {
          _grades = (_grades ?? []).sublist((_grades ?? []).length - maxGradesCount, (_grades ?? []).length);
        }
      });
    }
  }

  void initState() {
    super.initState();
    initGrades();

    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          maxGradesCount = isLargeScreen ? 18 : 10;
          initGrades();
        }));
  }

  toDouble(Grade grade) {
    double toReturn;
    if (!grade.letters!) {
      try {
        toReturn = (double.tryParse(grade.value!.replaceAll(",", "."))! *
            20 /
            double.tryParse(grade.scale!.replaceAll(",", "."))!);
        return double.parse(toReturn.toStringAsFixed(2));
      } catch (e) {}
    }
  }
}
