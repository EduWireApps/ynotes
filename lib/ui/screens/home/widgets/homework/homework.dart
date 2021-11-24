import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/data/homework/homework.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

List<List<Homework>> groupHomeworkByDate(List<Homework> homeworkList) {
  final List<DateTime> dates = [];
  for (var hw in homeworkList) {
    if (!dates.contains(hw.date) && hw.date != null) {
      dates.add(hw.date!);
    }
  }
  final List<DateTime> formattedDates =
      dates.map((date) => DateTime.parse(DateFormat("yyyy-MM-dd").format(date))).toSet().toList();
  return formattedDates
      .map((date) => homeworkList.where((hw) => CalendarTime(hw.date).isSameDayAs(date)).toList())
      .toList();
}

class Homeworks extends StatefulWidget {
  const Homeworks({Key? key}) : super(key: key);

  @override
  _HomeworksState createState() => _HomeworksState();
}

class _HomeworksState extends State<Homeworks> {
  final controller = appSys.homeworkController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.refresh(force: true);
    });
  }

  List<Homework> get homework => controller.homework(showAll: true) ?? [];
  List<List<Homework>> get homeworkByDate => groupHomeworkByDate(homework);

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<HomeworkController>(
        controller: controller,
        builder: (context, controller, _) {
          return homework.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: YPadding.p(YScale.s4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Devoirs", style: theme.texts.title),
                            YVerticalSpacer(YScale.s6),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: YBorderRadius.xl, color: theme.colors.backgroundLightColor),
                              child: Column(children: [
                                Padding(
                                  padding: YPadding.p(YScale.s3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Pour demain",
                                          style: theme.texts.body1.copyWith(
                                              color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold)),
                                      Text(
                                          "${homeworkByDate.first.where((hw) => hw.done!).length}/${homeworkByDate.first.length}",
                                          style: theme.texts.body1.copyWith(
                                              color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold))
                                    ],
                                  ),
                                ),
                                Column(
                                    children: homeworkByDate.first.asMap().entries.map((entry) {
                                  final int index = entry.key;
                                  final Homework hw = entry.value;
                                  return ListTile(
                                    leading: Text("$index."),
                                    title: Text(hw.discipline!,
                                        style: theme.texts.body1
                                            .copyWith(decoration: hw.done! ? TextDecoration.lineThrough : null),
                                        overflow: TextOverflow.ellipsis),
                                    subtitle: hw.rawContent != null
                                        ? Text(parse(hw.rawContent!).documentElement!.text,
                                            style: theme.texts.body2, overflow: TextOverflow.ellipsis)
                                        : null,
                                    trailing: YCheckbox(
                                        value: hw.done!,
                                        onChanged: (bool value) async {
                                          await HomeworkOffline(appSys.offline).updateSingleHW(hw);
                                          controller.refresh();
                                        }),
                                  );
                                }).toList())
                              ]),
                            )
                          ],
                        )),
                    const YDivider()
                  ],
                )
              : Container();
        });
  }
}
