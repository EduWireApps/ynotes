import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/summary/data/constants.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

import '../data/texts.dart';
import 'average_chart.dart';
import 'card.dart';

class SummaryAverage extends StatefulWidget {
  const SummaryAverage({Key? key}) : super(key: key);

  @override
  SummaryAverageState createState() => SummaryAverageState();
}

class SummaryAverageState extends State<SummaryAverage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(sidePadding),
      child: ChangeNotifierProvider<GradesController>.value(
          value: appSys.gradesController,
          child: Consumer<GradesController>(builder: (context, model, child) {
            return SummaryCard(
                child: SizedBox(
              height: 12.h,
              child: Column(
                children: [
                  Container(
                    height: 3.h,
                    margin: EdgeInsets.only(top: 0.2.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          (!model.average.isNaN ? model.average.toStringAsFixed(2).replaceAll(".", ",") : "-"),
                          style: TextStyle(
                              color: theme.colors.foregroundColor,
                              fontSize: YScale.s12,
                              height: .4,
                              fontWeight: FontWeight.w700),
                        ),
                        YHorizontalSpacer(.2.h),
                        Expanded(
                          child: Text(SummaryTexts.average,
                              style: TextStyle(color: theme.colors.foregroundLightColor, fontSize: YScale.s6)),
                        )
                      ],
                    ),
                  ),
                  YVerticalSpacer(0.3.h),
                  SizedBox(height: 8.h, child: const SummaryChart())
                ],
              ),
            ));
          })),
    );
  }
}
