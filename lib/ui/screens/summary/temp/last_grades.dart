import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/summary/temp/constants.dart';
import 'package:ynotes/ui/screens/summary/temp/texts.dart';
import 'package:ynotes_components/ynotes_components.dart';

class SummaryLastGrades extends StatefulWidget {
  const SummaryLastGrades({Key? key}) : super(key: key);

  @override
  _SummaryLastGradesState createState() => _SummaryLastGradesState();
}

class _SummaryLastGradesState extends State<SummaryLastGrades> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Texts.lastGrades,
                style:
                    TextStyle(color: currentTheme.colors.neutral.shade500, fontSize: 20, fontWeight: FontWeight.w500)),
            YButton(
              onPressed: () => Navigator.pushNamed(context, "/grades"),
              text: "Tout voir",
              type: YColor.neutral,
              variant: YButtonVariant.reverse,
              icon: Icons.arrow_forward_rounded,
              reverseIconAndText: true,
            )
          ],
        ),
      )
    ]);
  }
}
