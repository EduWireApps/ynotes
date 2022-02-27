import 'package:flutter/material.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes/ui/screens/grades/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class PeriodPage extends StatelessWidget {
  final GradesModule module;
  final Period period;
  final bool simulate;

  const PeriodPage(this.module, this.period, this.simulate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return period.grades.isEmpty
        ? SizedBox(
            width: double.infinity,
            child: Padding(
              padding: YPadding.p(YScale.s4),
              child: Text(
                "Aucune note disponible pour cette période",
                style: theme.texts.body1,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Column(
            children: [
              _Stats(module, period, simulate),
              YVerticalSpacer(YScale.s4),
              SubjectsList(module, period, simulate),
              const _Footer()
            ],
          );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YVerticalSpacer(YScale.s4),
        const YDivider(),
        SizedBox(
            height: YScale.s20,
            child: Padding(
              padding: YPadding.px(YScale.s4),
              child: Align(
                alignment: Alignment.center,
                child: Text("Essaie donc le simulateur !", style: theme.texts.body1),
              ),
            )),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  final GradesModule module;
  final Period period;
  final bool simulate;

  const _Stats(this.module, this.period, this.simulate, {Key? key}) : super(key: key);

  List<Grade> get grades => period.sortedGrades.where((grade) {
        final bool s = grade.significant;
        if (simulate) {
          return s;
        } else {
          return s && !grade.custom;
        }
      }).toList();

  double get average => module.calculateAverageFromGrades(grades, bySubject: true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: theme.colors.backgroundLightColor, borderRadius: YBorderRadius.lg),
                padding: EdgeInsets.symmetric(horizontal: YScale.s3, vertical: YScale.s1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Moyenne", style: theme.texts.body2),
                    Text(
                      average.display(),
                      style: theme.texts.data1.copyWith(
                          fontSize: r<double>(def: YFontSize.xl2, lg: YFontSize.xl3, xl: YFontSize.xl4),
                          color: simulate ? theme.colors.primary.backgroundColor : null),
                    ),
                  ],
                ),
              ),
              YHorizontalSpacer(YScale.s4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Évolution", style: theme.texts.body2),
                  _DiffText(module.calculateAverageFromGrades(grades, bySubject: true) -
                      module.calculateAverageFromGrades(grades.sublist(0, grades.length - 1), bySubject: true))
                ],
              ),
            ],
          ),
          YVerticalSpacer(YScale.s2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...<List<dynamic>>[
                ["Classe", period.classAverage],
                ["Max", period.maxAverage],
                ["Min", period.minAverage],
              ]
                  .map((e) => Row(
                        children: [
                          YHorizontalSpacer(YScale.s4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e[0] as String, style: theme.texts.body2),
                              Text(
                                (e[1] as double).display(),
                                style: theme.texts.body1.copyWith(
                                    fontSize: r<double>(def: YFontSize.lg, lg: YFontSize.xl, xl: YFontSize.xl2),
                                    color: theme.colors.foregroundColor),
                              ),
                            ],
                          ),
                        ],
                      ))
                  .toList(),
              if (!simulate && average != period.overallAverage)
                Row(
                  children: [
                    YHorizontalSpacer(YScale.s4),
                    const OutdatedDataWarning(),
                  ],
                )
            ],
          )
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
        style: theme.texts.body1
            .copyWith(fontSize: r<double>(def: YFontSize.lg, lg: YFontSize.xl, xl: YFontSize.xl2), color: color));
  }
}
