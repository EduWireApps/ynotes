// TODO: fix when homework is done
// ignore: unused_element
const _fake = null;

/*
import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/home/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class HomeworkSection extends StatefulWidget {
  const HomeworkSection({Key? key}) : super(key: key);

  @override
  _HomeworkSectionState createState() => _HomeworkSectionState();
}

class _HomeworkSectionState extends State<HomeworkSection> {
  final controller = appSys.homeworkController;

  List<Homework> get homework => controller.homework(showAll: true) ?? [];
  List<List<Homework>> get homeworkByWeek {
    final Map<int, List<Homework>> homeworkByWeekMap = {};
    for (final hw in homework) {
      if (homeworkByWeekMap.containsKey(hw.date!.weekyear)) {
        homeworkByWeekMap[hw.date!.weekyear]!.add(hw);
      } else {
        homeworkByWeekMap[hw.date!.weekyear] = [hw];
      }
    }
    return homeworkByWeekMap.entries.map((e) => e.value).toList();
  }

  bool get isCurrentWeek {
    final DateTime now = DateTime.now();
    if (now.weekday < 6) {
      if (now.weekday == 5) {
        return now.hour < 18;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  List<Homework> get week {
    final DateTime date = DateTime.now().add(Duration(days: isCurrentWeek ? 0 : 7));
    int? i;
    int index = 0;
    for (final week in homeworkByWeek) {
      if (week.first.date!.weekyear == date.weekyear) {
        i = index;
        break;
      }
      index += 1;
    }
    return i == null ? [] : homeworkByWeek[i];
  }

  Widget counter({
    required int done,
    required int total,
  }) =>
      Text("$done/$total",
          style: theme.texts.body1.copyWith(
              color: done == total ? theme.colors.success.backgroundColor : theme.colors.foregroundColor,
              fontWeight: YFontWeight.semibold));

  String get text => isCurrentWeek ? "pour cette semaine" : "pour la semaine prochaine";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierConsumer<HomeworkController>(
        controller: controller,
        builder: (context, controller, _) {
          return week.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: YPadding.p(YScale.s4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Devoirs", style: theme.texts.title),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: YBorderRadius.lg,
                                      color: theme.colors.backgroundLightColor,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: YScale.s2, vertical: YScale.s1),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "${homework.where((hw) => hw.isATest!).length}",
                                            style: TextStyle(
                                                fontWeight: homework.where((hw) => hw.isATest!).isNotEmpty
                                                    ? YFontWeight.semibold
                                                    : null)),
                                        const TextSpan(text: " évaluations")
                                      ], style: theme.texts.body2),
                                    ))
                              ],
                            ),
                            YVerticalSpacer(YScale.s6),
                            Column(children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: (Radius.circular(0.75.rem))),
                                    color: theme.colors.backgroundLightColor),
                                child: Padding(
                                  padding: YPadding.p(YScale.s4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(text.capitalize(),
                                          style: theme.texts.body1.copyWith(
                                              color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold)),
                                      counter(done: week.where((hw) => hw.done!).length, total: week.length)
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                  children: week
                                      .map((hw) => HomeworkElement(
                                            hw,
                                          ))
                                      .toList()),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(bottom: (Radius.circular(0.75.rem))),
                                      color: theme.colors.backgroundLightColor),
                                  height: YScale.s4),
                            ])
                          ],
                        )),
                  ],
                )
              : EmptyState(
                  iconRoutePath: "/homework",
                  onPressed: () async => await controller.refresh(force: true),
                  text: "Pas de devoir $text, quelle chance !",
                  loading: controller.isFetching);
        });
  }
}
*/