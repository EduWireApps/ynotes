import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/data/homework/homework.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class HomeworkElement extends StatelessWidget {
  final Homework homework;
  const HomeworkElement(this.homework, {Key? key}) : super(key: key);

  String get day {
    String d = DateFormat("EEEE", "fr_FR").format(homework.date!);
    if (d == "lundi") {
      d = "Lun.";
    } else if (d == "mardi") {
      d = "Mar.";
    } else if (d == "mercredi") {
      d = "Mer.";
    } else if (d == "jeudi") {
      d = "Jeu.";
    } else if (d == "vendredi") {
      d = "Ven.";
    } else if (d == "samedi") {
      d = "Sam.";
    } else if (d == "dimanche") {
      d = "Dim.";
    }
    return d;
  }

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<GradesController>(
        controller: appSys.gradesController,
        builder: (context, controller, _) {
          return InkWell(
              onTap: () => Navigator.pushNamed(context, "/homework"),
              child: Ink(
                  color: theme.colors.backgroundLightColor,
                  padding: EdgeInsets.symmetric(vertical: YScale.s2, horizontal: YScale.s4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(day, style: theme.texts.body2),
                      YHorizontalSpacer(YScale.s4),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      homework.discipline!,
                                      style: theme.texts.body1.copyWith(
                                          color: controller.disciplines() != null &&
                                                  controller.disciplines()!.isNotEmpty &&
                                                  controller.disciplines()!.firstWhereOrNull(
                                                          (e) => e.disciplineCode == homework.disciplineCode) !=
                                                      null
                                              ? Color(controller
                                                  .disciplines()!
                                                  .firstWhereOrNull((e) => e.disciplineCode == homework.disciplineCode)!
                                                  .color!)
                                              : null,
                                          fontWeight: YFontWeight.semibold,
                                          decoration: homework.done! ? TextDecoration.lineThrough : null),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (homework.isATest!)
                                    Row(
                                      children: [
                                        YHorizontalSpacer(YScale.s2),
                                        Container(
                                          height: YScale.s4,
                                          padding: YPadding.px(YScale.s1),
                                          decoration: BoxDecoration(
                                            color: theme.colors.danger.backgroundColor,
                                            borderRadius: YBorderRadius.full,
                                          ),
                                          child: Text(
                                            "Évalué",
                                            style: theme.texts.body2.copyWith(
                                                fontWeight: YFontWeight.bold,
                                                color: theme.colors.danger.foregroundColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),
                            if (homework.rawContent != null)
                              Text(
                                parse(homework.rawContent!)
                                    .documentElement!
                                    .text
                                    .replaceAll("\n\n", ". ")
                                    .replaceAll("\n", ""),
                                style: theme.texts.body2,
                                overflow: TextOverflow.ellipsis,
                              )
                          ],
                        ),
                      ),
                      YHorizontalSpacer(YScale.s4),
                      YCheckbox(
                          color: YColor.success,
                          value: homework.done!,
                          onChanged: (bool value) async {
                            Homework hw = homework;
                            hw.done = value;
                            await HomeworkOffline(appSys.offline).updateSingleHW(hw);
                            appSys.homeworkController.refresh();
                          })
                    ],
                  )));
        });
  }
}
