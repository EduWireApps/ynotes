import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_components/ynotes_components.dart';
import 'package:sizer/sizer.dart';

import 'average_chart.dart';
import 'card.dart';
import '../data/constants.dart';
import '../data/texts.dart';

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
                              color: currentTheme.colors.neutral.shade500,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        YHorizontalSpacer(5),
                        Text(SummaryTexts.average,
                            style: TextStyle(color: currentTheme.colors.neutral.shade400, fontSize: 13.sp))
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
