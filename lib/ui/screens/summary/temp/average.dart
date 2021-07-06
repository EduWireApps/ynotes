import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_components/ynotes_components.dart';

import 'average_chart.dart';
import 'card.dart';
import 'constants.dart';
import 'texts.dart';

class SummaryAverage extends StatefulWidget {
  const SummaryAverage({Key? key}) : super(key: key);

  @override
  SummaryAverageState createState() => SummaryAverageState();
}

class SummaryAverageState extends State<SummaryAverage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GradesController>.value(
        value: appSys.gradesController,
        child: Consumer<GradesController>(builder: (context, model, child) {
          return Padding(
            padding: EdgeInsets.all(sidePadding),
            child: Row(
              children: [
                Expanded(
                    child: SummaryCard(
                        child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          (!model.average.isNaN ? model.average.toStringAsFixed(2).replaceAll(".", ",") : "-"),
                          style: TextStyle(
                              color: currentTheme.colors.neutral.shade500, fontSize: 35, fontWeight: FontWeight.w700),
                        ),
                        YHorizontalSpacer(5),
                        Text(Texts.average, style: TextStyle(color: currentTheme.colors.neutral.shade400, fontSize: 18))
                      ],
                    ),
                    YVerticalSpacer(10),
                    SummaryChart()
                  ],
                ))),
              ],
            ),
          );
        }));
  }
}
