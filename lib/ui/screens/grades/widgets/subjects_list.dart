import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes/ui/screens/grades/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SubjectsList extends StatelessWidget {
  final GradesModule module;
  final Period period;
  final bool simulate;
  const SubjectsList(this.module, this.period, this.simulate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: YPadding.px(YScale.s4),
          child: const SubjectsFiltersManager(),
        ),
        YVerticalSpacer(YScale.s2),
        ...period.sortedSubjects
            .where((e) {
              return (module.currentFilter.entityId == "all" || module.currentFilter.subjects.contains(e));
            })
            .map((subject) => _SubjectContainer(subject, period, simulate))
            .toList()
      ],
    );
  }
}

class _SubjectContainer extends StatelessWidget {
  final Subject subject;
  final Period period;
  final bool simulate;
  const _SubjectContainer(this.subject, this.period, this.simulate, {Key? key}) : super(key: key);

  List<Grade> get grades {
    final List<Grade> _grades = subject.sortedGrades;
    for (final g in _grades) {
      g.load();
    }
    return _grades.where((grade) => (simulate ? true : !grade.custom)).toList();
  }

  double get _average => schoolApi.gradesModule.calculateAverageFromGrades(grades, bySubject: true);

  @override
  Widget build(BuildContext context) {
    final BorderRadius _borderRadius = BorderRadius.vertical(
        top: Radius.circular(YScale.s2),
        bottom: grades.isEmpty ? Radius.circular(YScale.s2) : const Radius.circular(0));
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: theme.colors.backgroundLightColor, borderRadius: YBorderRadius.lg),
      margin: EdgeInsets.symmetric(horizontal: YScale.s4, vertical: YScale.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: _borderRadius,
            child: InkWell(
              onTap: () {
                YModalBottomSheets.show(
                    context: context,
                    child:
                        SubjectDetailsSheet(subject: subject, average: _average, period: period, simulate: simulate));
              },
              borderRadius: _borderRadius,
              hoverColor: subject.color.lightColor,
              highlightColor: subject.color.lightColor,
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: YScale.s2, horizontal: YScale.s4),
                decoration: BoxDecoration(
                  color: subject.color.backgroundColor,
                  borderRadius: _borderRadius,
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    Text(_average.isNaN ? "-" : _average.display(),
                        style: theme.texts.body1.copyWith(
                            color: subject.color.foregroundColor,
                            fontWeight: YFontWeight.bold,
                            fontSize: YFontSize.xl)),
                    YHorizontalSpacer(YScale.s4),
                    Expanded(
                      child: Text(
                        subject.name,
                        style: theme.texts.body1
                            .copyWith(color: subject.color.foregroundColor, fontWeight: YFontWeight.medium),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    YHorizontalSpacer(YScale.s2),
                    Icon(Icons.info_rounded, color: subject.color.foregroundColor, size: YFontSize.lg),
                  ],
                ),
              ),
            ),
          ),
          if (grades.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: YScale.s3, vertical: YScale.s4),
              child: Wrap(
                spacing: YScale.s2,
                runSpacing: YScale.s2,
                children: [
                  ...grades,
                  // CustomGrade(coefficient: 1.5, outOf: 20, value: 14, subjectId: "", periodId: "periodId")
                ].map((grade) => _GradeContainer(grade, subject)).toList(),
              ),
            )
        ],
      ),
    );
  }
}

class _GradeContainer extends StatefulWidget {
  final Grade grade;
  final Subject subject;
  const _GradeContainer(
    this.grade,
    this.subject, {
    Key? key,
  }) : super(key: key);

  @override
  State<_GradeContainer> createState() => _GradeContainerState();
}

class _GradeContainerState extends State<_GradeContainer> {
  YTColor get color => widget.subject.color;

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

  bool get simulate => widget.grade.custom;
  bool highlight = false;

  Color get textColor => highlight ? color.foregroundColor : theme.colors.foregroundColor;

  @override
  Widget build(BuildContext context) {
    final BorderRadius _borderRadius = YBorderRadius.xl;
    return DottedBorder(
      color: simulate ? color.backgroundColor : Colors.transparent,
      radius: Radius.circular(YScale.s4),
      padding: YPadding.p(YScale.s1),
      strokeWidth: YScale.s0p5,
      borderType: BorderType.RRect,
      dashPattern: [YScale.s1, YScale.s0p5],
      child: Material(
        color: simulate ? color.backgroundColor : theme.colors.backgroundColor,
        borderRadius: _borderRadius,
        child: InkWell(
          onTap: () {
            YModalBottomSheets.show(context: context, child: GradeDetailsSheet(widget.grade, simulate));
          },
          borderRadius: _borderRadius,
          highlightColor: simulate ? color.lightColor.withOpacity(.5) : color.backgroundColor,
          onHighlightChanged: (bool value) {
            setState(() {
              highlight = value;
            });
          },
          hoverColor: color.lightColor,
          child: Ink(
              padding: YPadding.p(YScale.s1),
              decoration:
                  BoxDecoration(color: theme.colors.backgroundColor.withOpacity(.25), borderRadius: _borderRadius),
              child: SizedBox(
                width: YScale.s8,
                height: YScale.s8,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    AutoSizeText(
                      widget.grade.value.display,
                      style: TextStyle(
                        fontWeight: YFontWeight.semibold,
                        color: simulate ? color.foregroundColor : textColor,
                        fontSize: YFontSize.base,
                      ),
                      softWrap: false,
                    ),
                    if (widget.grade.value.valueType != gradeValueType.string && widget.grade.value.coefficient != 1)
                      Positioned(
                          top: -YScale.s2p5,
                          right: -YScale.s2p5,
                          child: bubble(widget.grade.value.coefficient.display(), true)),
                    if (widget.grade.value.valueType != gradeValueType.string && widget.grade.value.outOf != 20)
                      Positioned(
                          bottom: -YScale.s2p5, right: -YScale.s2p5, child: bubble("/${widget.grade.value.outOf.display()}"))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
