import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/grades/models.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/summary/widgets/card.dart';
import 'package:ynotes/ui/screens/summary/data/constants.dart';
import 'package:ynotes/ui/screens/summary/data/texts.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_components/ynotes_components.dart';
import 'package:sizer/sizer.dart';

class SummaryLastGrades extends StatefulWidget {
  const SummaryLastGrades({Key? key}) : super(key: key);

  @override
  _SummaryLastGradesState createState() => _SummaryLastGradesState();
}

class _SummaryLastGradesState extends State<SummaryLastGrades> {
  Widget gradeCard(BuildContext context, Grade grade) {
    final TextStyle gradeStyle =
        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600, color: currentTheme.colors.neutral.shade500);

    return Padding(
        padding: EdgeInsets.only(left: sidePadding),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/grades"),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60.w),
            child: SummaryCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text((grade.notSignificant! ? "(" + grade.value! : grade.value) ?? "", style: gradeStyle),
                          Text('/' + grade.scale!,
                              style: TextStyle(
                                  color: currentTheme.colors.neutral.shade400,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400)),
                          if (grade.notSignificant!) Text(")", style: gradeStyle)
                        ],
                      ),
                      Expanded(child: Container()),
                      Icon(Icons.arrow_forward_outlined, color: currentTheme.colors.neutral.shade400)
                    ]),
                YVerticalSpacer(5),
                Text(
                  grade.disciplineName ?? "",
                  style: TextStyle(
                      color: currentTheme.colors.neutral.shade400, fontSize: 7.sp, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                Text(
                  grade.testName ?? "",
                  style: TextStyle(
                      color: currentTheme.colors.neutral.shade500, fontSize: 13.sp, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                )
              ],
            )),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GradesController>.value(
        value: appSys.gradesController,
        child: Consumer<GradesController>(builder: (context, model, child) {
          final allGrades =
              getAllGrades(model.disciplines(showAll: true), overrideLimit: true, sortByWritingDate: true) ?? [];
          final grades = allGrades.reversed.toList().sublist(allGrades.length - 5).reversed;
          if (grades.length != 0) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(SummaryTexts.lastGrades,
                        style: TextStyle(
                            color: currentTheme.colors.neutral.shade500, fontSize: 15.sp, fontWeight: FontWeight.w500)),
                    YButton(
                      onPressed: () => Navigator.pushNamed(context, "/grades"),
                      text: SummaryTexts.seeAll,
                      type: YColor.neutral,
                      variant: YButtonVariant.reverse,
                      icon: Icons.arrow_forward_rounded,
                      reverseIconAndText: true,
                    )
                  ],
                ),
              ),
              YVerticalSpacer(10),
              SingleChildScrollView(
                padding: EdgeInsets.only(right: sidePadding),
                scrollDirection: Axis.horizontal,
                child: Row(children: grades.map((grade) => gradeCard(context, grade)).toList()),
              ),
            ]);
          } else {
            return Container();
          }
        }));
  }
}
