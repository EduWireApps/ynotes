import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class GradeContainer extends StatelessWidget {
  final Grade grade;

  const GradeContainer(this.grade, {Key? key}) : super(key: key);

  String get date {
    final date = grade.entryDate!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (date == today) {
      return "Aujourd'hui";
    } else if (date == yesterday) {
      return "Hier";
    } else {
      return DateFormat("EEEE dd MMMM", "fr_FR").format(grade.entryDate!).capitalize();
    }
  }

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
    return InkWell(
      onTap: () => Navigator.pushNamed(context, "/grades"),
      borderRadius: YBorderRadius.xl,
      child: Ink(
          width: min(75.vw, YScale.s72),
          padding: YPadding.p(YScale.s3),
          decoration: BoxDecoration(
            color: theme.colors.backgroundLightColor,
            borderRadius: YBorderRadius.xl,
          ),
          child: Row(children: [
            Container(
                padding: YPadding.p(YScale.s1),
                decoration: BoxDecoration(
                    color: Color(appSys.gradesController
                        .disciplines()!
                        .firstWhere((e) => e.disciplineCode == grade.disciplineCode)
                        .color!),
                    borderRadius: YBorderRadius.lg),
                child: SizedBox(
                  width: YScale.s10,
                  height: YScale.s10,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      AutoSizeText(
                        grade.value!,
                        style: TextStyle(
                          fontWeight: YFontWeight.semibold,
                          color: theme.colors.foregroundColor,
                          fontSize: YFontSize.xl,
                        ),
                        softWrap: false,
                      ),
                      if (grade.weight! != "1")
                        Positioned(top: -YScale.s3, right: -YScale.s2, child: bubble(grade.weight!, true)),
                      if (grade.scale! != "20")
                        Positioned(bottom: -YScale.s3, right: -YScale.s2, child: bubble("/${grade.scale!}"))
                    ],
                  ),
                )),
            YHorizontalSpacer(YScale.s3),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(grade.testName!,
                      style: theme.texts.body1
                          .copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold),
                      overflow: TextOverflow.ellipsis),
                  Text(grade.disciplineName!,
                      style: theme.texts.body1.copyWith(fontSize: YFontSize.sm), overflow: TextOverflow.ellipsis),
                  YVerticalSpacer(YScale.s1),
                  Text(date, style: theme.texts.body2, overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          ])),
    );
  }
}
