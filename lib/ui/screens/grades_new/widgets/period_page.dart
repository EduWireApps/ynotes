import 'package:flutter/material.dart';
import 'package:ynotes/core_new/api.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/ui/screens/grades_new/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class PeriodPage extends StatelessWidget {
  final GradesModule module;
  final Period period;

  const PeriodPage(this.module, this.period, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return period.grades(module.grades).isEmpty
        ? Text(
            "no grades",
            style: theme.texts.body1,
          )
        : Column(
            children: [_Stats(module, period), YVerticalSpacer(YScale.s8), SubjectsList(module, period)],
          );
  }
}

class _Stats extends StatelessWidget {
  final GradesModule module;
  final Period period;

  const _Stats(this.module, this.period, {Key? key}) : super(key: key);

  Future<void> _open() async {
    // TODO: open stats page
  }

  List<Grade> get grades =>
      period.grades(module.grades.where((grade) => grade.significant && grade is! CustomGrade).toList()).toList();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colors.backgroundColor,
      child: InkWell(
        onTap: _open,
        child: Ink(
          padding: YPadding.p(YScale.s4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Moyenne", style: theme.texts.body2),
                  Text(
                    module.calculateAverageFromGrades(grades, bySubject: true).display(),
                    style: theme.texts.data1
                        .copyWith(fontSize: r<double>(def: YFontSize.xl2, lg: YFontSize.xl3, xl: YFontSize.xl4)),
                  ),
                ],
              ),
              YHorizontalSpacer(YScale.s4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Évolution", style: theme.texts.body2),
                  _DiffText(module.calculateAverageFromPeriod(period) -
                      module.calculateAverageFromGrades(grades.sublist(0, grades.length - 1), bySubject: true))
                ],
              ),
              YHorizontalSpacer(YScale.s4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Classe", style: theme.texts.body2),
                  Text(
                    period.classAverage.display(),
                    style: theme.texts.body1.copyWith(
                        fontSize: r<double>(def: YFontSize.lg, lg: YFontSize.xl, xl: YFontSize.xl2),
                        color: theme.colors.foregroundColor),
                  ),
                ],
              ),
              YHorizontalSpacer(YScale.s4),
              Expanded(child: Container()),
              YButton(
                onPressed: _open,
                text: "Stats",
                color: YColor.secondary,
              )
            ],
          ),
        ),
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
        style: theme.texts.body1
            .copyWith(fontSize: r<double>(def: YFontSize.lg, lg: YFontSize.xl, xl: YFontSize.xl2), color: color));
  }
}
