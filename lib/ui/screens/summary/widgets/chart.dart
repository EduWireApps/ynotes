import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';

class SummaryChart extends StatefulWidget {
  final List<Grade>? lastGrades;

  SummaryChart(
    this.lastGrades, {
    Key? key,
  }) : super(key: key);
  @override
  SummaryChartState createState() => SummaryChartState();
}

class SummaryChartState extends State<SummaryChart> with LayoutMixin {
  List<Grade>? _grades = [];
  List<Color> gradientColors = [
    const Color(0xff3a4398),
    const Color(0xff5c66c1),
  ];
  int maxGradesCount = 10;

  LineChartData avgData() {
    var screenSize = MediaQuery.of(context);
    return LineChartData(
      clipData: FlClipData.horizontal(),
      backgroundColor: Colors.transparent,
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          interval: 1.0,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
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
          reservedSize: screenSize.size.width / 5 * 0.2,
          margin: screenSize.size.width / 5 * 0.05,
        ),
      ),
      axisTitleData: FlAxisTitleData(topTitle: AxisTitle()),
      borderData: FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: ((_grades ?? []).length > maxGradesCount ? maxGradesCount : (_grades ?? []).length).toDouble(),
      minY: getMin() > 0 ? ((getMin() ?? 1) - 1) : getMin(),
      maxY: getMax() + 2,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate((_grades ?? []).length > maxGradesCount ? maxGradesCount : (_grades ?? []).length,
              (index) => FlSpot(index.toDouble(), toDouble((_grades ?? [])[index]))),
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[0]).lerp(0.2)!,
            ColorTween(begin: gradientColors[1], end: gradientColors[1]).lerp(0.2)!,
          ],
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
    maxGradesCount = isLargeScreen ? 18 : 10;

    var screenSize = MediaQuery.of(context);
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: (_grades != null && ((_grades ?? []).length != 0))
          ? Container(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenSize.size.width / 5 * 4.2,
                    height: 100,
                    child: LineChart(
                      avgData(),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.emoticonConfused,
                        color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                        child: AutoSizeText(
                          "Pas de données.",
                          style: TextStyle(fontFamily: "Asap", color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
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
    if (widget.lastGrades != null) {
      setState(() {
        (_grades ?? []).clear();
        (_grades ?? []).addAll(widget.lastGrades!);
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
