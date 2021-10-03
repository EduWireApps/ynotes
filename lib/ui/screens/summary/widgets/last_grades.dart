import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/grades/models.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/summary/data/constants.dart';
import 'package:ynotes/ui/screens/summary/data/texts.dart';
import 'package:ynotes/ui/screens/summary/widgets/card.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class SummaryLastGrades extends StatefulWidget {
  const SummaryLastGrades({Key? key}) : super(key: key);

  @override
  _SummaryLastGradesState createState() => _SummaryLastGradesState();
}

class _SummaryLastGradesState extends State<SummaryLastGrades> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GradesController>.value(
        value: appSys.gradesController,
        child: Consumer<GradesController>(builder: (context, model, child) {
          final allGrades =
              getAllGrades(model.disciplines(showAll: true), overrideLimit: true, sortByWritingDate: true) ?? [];
          final grades = allGrades.reversed.toList().sublist((allGrades.length - 5).clamp(0, 10000)).reversed;
          if (grades.isNotEmpty) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(SummaryTexts.lastGrades,
                        style: TextStyle(
                            color: theme.colors.foregroundColor, fontSize: YScale.s8, fontWeight: FontWeight.w500)),
                    YButton(
                      onPressed: () => Navigator.pushNamed(context, "/grades"),
                      text: SummaryTexts.seeAll,
                      color: YColor.secondary,
                      icon: Icons.arrow_forward_rounded,
                      isIconReversed: true,
                    )
                  ],
                ),
              ),
              YVerticalSpacer(YScale.s2),
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

  Widget gradeCard(BuildContext context, Grade grade) {
    final TextStyle gradeStyle =
        TextStyle(fontSize: YScale.s10, fontWeight: FontWeight.w600, color: theme.colors.foregroundColor);

    return Padding(
        padding: EdgeInsets.only(left: sidePadding),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/grades"),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 60.w, maxHeight: 150),
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
                                  color: theme.colors.foregroundLightColor,
                                  fontSize: YScale.s5,
                                  fontWeight: FontWeight.w400)),
                          if (grade.notSignificant!) Text(")", style: gradeStyle)
                        ],
                      ),
                      Expanded(child: Container()),
                      Icon(Icons.arrow_forward_outlined, color: theme.colors.foregroundLightColor)
                    ]),
                const Spacer(),
                Text(
                  grade.disciplineName ?? "",
                  style: TextStyle(
                      color: theme.colors.foregroundLightColor, fontSize: YScale.s4, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                if ((grade.testName ?? "") != "")
                  Text(
                    grade.testName ?? "",
                    style: TextStyle(
                        color: theme.colors.foregroundColor, fontSize: YScale.s6, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  )
              ],
            )),
          ),
        ));
  }
}
