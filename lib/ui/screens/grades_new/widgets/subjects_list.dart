import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core_new/api.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/ui/components/NEW/components.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SubjectsList extends StatelessWidget {
  final GradesModule module;
  final Period period;
  const SubjectsList(this.module, this.period, {Key? key}) : super(key: key);

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
        ...module.subjects
            .where((e) => module.currentFilter!.subjectsIds?.contains(e.id) ?? true)
            .map((subject) => _SubjectContainer(subject))
            .toList()
      ],
    );
  }
}

class _SubjectContainer extends StatelessWidget {
  final Subject subject;
  const _SubjectContainer(this.subject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: theme.colors.backgroundLightColor, borderRadius: YBorderRadius.lg),
      margin: EdgeInsets.symmetric(horizontal: YScale.s4, vertical: YScale.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.vertical(top: Radius.circular(YScale.s2)),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.vertical(top: Radius.circular(YScale.s2)),
              child: Ink(
                padding: YPadding.p(YScale.s2),
                decoration: BoxDecoration(
                  color: subject.color.backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(YScale.s2)),
                ),
                width: double.infinity,
                child: Text(
                    schoolApi.gradesModule
                            .calculateAverageFromGrades(
                                subject.grades(
                                    schoolApi.gradesModule.currentPeriod!.grades(schoolApi.gradesModule.grades)),
                                bySubject: true)
                            .display() +
                        " " +
                        subject.name,
                    style: theme.texts.body1
                        .copyWith(color: subject.color.foregroundColor, fontWeight: YFontWeight.medium)),
              ),
            ),
          ),
          YVerticalSpacer(YScale.s24),
        ],
      ),
    );
  }
}
