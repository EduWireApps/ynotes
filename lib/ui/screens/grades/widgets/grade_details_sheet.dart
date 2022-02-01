import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class GradeDetailsSheet extends StatefulWidget {
  final Grade grade;
  final bool simulate;
  const GradeDetailsSheet(this.grade, this.simulate, {Key? key}) : super(key: key);

  @override
  _GradeDetailsSheetState createState() => _GradeDetailsSheetState();
}

class _GradeDetailsSheetState extends State<GradeDetailsSheet> {
  Grade get grade => widget.grade;
  Subject get subject => grade.subject.value!;

  double get impactOnOverallAverage {
    final Period period = grade.period.value!;
    period.load();
    final grades = period.sortedGrades.where((grade) => widget.simulate ? true : !grade.custom).toList();
    final List<int> ids = grades.map<int>((g) => g.id!).toList();
    final int index = ids.indexOf(grade.id!);
    return schoolApi.gradesModule.calculateAverageFromGrades(grades.sublist(0, index + 1), bySubject: true) -
        schoolApi.gradesModule.calculateAverageFromGrades(grades.sublist(0, index), bySubject: true);
  }

  double get impactOnSubjectAverage {
    subject.load();
    final grades = subject.sortedGrades
        .where((grade) =>
            (widget.simulate ? true : !grade.custom) &&
            grade.period.value?.entityId == this.grade.period.value!.entityId)
        .toList();

    final List<int> ids = grades.map<int>((g) => g.id!).toList();
    final int index = ids.indexOf(grade.id!);
    return schoolApi.gradesModule.calculateAverageFromGrades(grades.sublist(0, index + 1)) -
        schoolApi.gradesModule.calculateAverageFromGrades(grades.sublist(0, index));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s4),
      child: Column(
        children: [
          _GradeContainer(grade),
          YVerticalSpacer(YScale.s2),
          Text(grade.name, style: theme.texts.title),
          YVerticalSpacer(YScale.s1),
          Text(subject.name, style: theme.texts.body1.copyWith(color: subject.color.backgroundColor)),
          YVerticalSpacer(YScale.s6),
          _ClassData(grade: grade),
          YVerticalSpacer(YScale.s8),
          _Stats(impactOnOverallAverage: impactOnOverallAverage, impactOnSubjectAverage: impactOnSubjectAverage),
          if (grade.custom)
            Padding(
                padding: YPadding.pt(YScale.s4),
                child: YButton(
                  onPressed: () async {
                    await schoolApi.gradesModule.removeCustomGrade(grade);
                    Navigator.pop(context);
                  },
                  text: "SUPPRIMER",
                  color: YColor.danger,
                  variant: YButtonVariant.outlined,
                ))
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({
    Key? key,
    required this.impactOnOverallAverage,
    required this.impactOnSubjectAverage,
  }) : super(key: key);

  final double impactOnOverallAverage;
  final double impactOnSubjectAverage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        container("dans la moyenne générale", impactOnOverallAverage),
        YHorizontalSpacer(YScale.s4),
        container("dans la moyenne de la matière", impactOnSubjectAverage),
      ],
    );
  }

  Widget container(String label, double value) {
    return Container(
      padding: YPadding.p(YScale.s2),
      width: YScale.s28,
      child: Column(
        children: [
          _DiffText(value),
          YVerticalSpacer(YScale.s1),
          Text(
            label,
            style: theme.texts.body2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DiffText extends StatelessWidget {
  final double value;
  const _DiffText(this.value, {Key? key}) : super(key: key);

  String get sign => value >= 0 ? "+" : "";

  Color get color => value >= 0 ? theme.colors.success.backgroundColor : theme.colors.danger.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Text("$sign${value.asFixed(2).display()}",
        style: theme.texts.body1.copyWith(fontWeight: YFontWeight.semibold, color: color));
  }
}

class _ClassData extends StatelessWidget {
  const _ClassData({
    Key? key,
    required this.grade,
  }) : super(key: key);

  final Grade grade;

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: YScale.s4,
        runSpacing: YScale.s2,
        children: [
          ["CLASSE", grade.classAverage.display()],
          ["MAX", grade.classMax.display()],
          ["MIN", grade.classMin.display()]
        ].map((e) => _Data(label: e[0], value: e[1])).toList());
  }
}

class _Data extends StatelessWidget {
  final String label;
  final String value;

  const _Data({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: theme.colors.backgroundLightColor, borderRadius: YBorderRadius.xl),
      padding: YPadding.p(YScale.s2),
      width: YScale.s16,
      child: Column(
        children: [
          Text(label, style: theme.texts.body2),
          YVerticalSpacer(YScale.s1),
          Text(value,
              style: theme.texts.body1.copyWith(fontWeight: YFontWeight.semibold, color: theme.colors.foregroundColor)),
        ],
      ),
    );
  }
}

class _GradeContainer extends StatelessWidget {
  final Grade grade;
  const _GradeContainer(
    this.grade, {
    Key? key,
  }) : super(key: key);

  YTColor get color => grade.subject.value!.color;

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
    final BorderRadius _borderRadius = YBorderRadius.xl;
    return Container(
        padding: YPadding.p(YScale.s1),
        decoration: BoxDecoration(color: color.backgroundColor, borderRadius: _borderRadius),
        child: SizedBox(
          width: YScale.s10,
          height: YScale.s10,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AutoSizeText(
                grade.value.display(),
                style: TextStyle(
                  fontWeight: YFontWeight.semibold,
                  color: color.foregroundColor,
                  fontSize: YFontSize.xl,
                ),
                softWrap: false,
              ),
              if (grade.coefficient != 1)
                Positioned(top: -YScale.s2p5, right: -YScale.s2p5, child: bubble(grade.coefficient.display(), true)),
              if (grade.outOf != 20)
                Positioned(bottom: -YScale.s2p5, right: -YScale.s2p5, child: bubble("/${grade.outOf.display()}"))
            ],
          ),
        ));
  }
}
