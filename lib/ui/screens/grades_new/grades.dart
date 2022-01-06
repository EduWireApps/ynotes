import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/core_new/api.dart';
import 'package:ynotes/ui/components/NEW/components.dart';
import 'package:ynotes/ui/screens/grades_new/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({Key? key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final GradesModule module = schoolApi.gradesModule;
  bool simulate = false;

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<GradesModule>(
        controller: module,
        builder: (context, module, _) {
          return ZApp(
              page: YPage(
            onRefresh: () => module.fetch(online: true),
            appBar: YAppBar(title: "Notes", actions: [
              if (simulate) const YBadge(text: "SIMULATEUR"),
              YHorizontalSpacer(YScale.s2),
              const YBadge(text: "BETA", color: YColor.danger)
            ]),
            useBottomNavigation: false,
            navigationInitialIndex: module.periods.indexOf(module.currentPeriod!),
            navigationElements: module.periods
                .map((period) => YNavigationElement(label: period.name, widget: PeriodPage(module, period, simulate)))
                .toList(),
            onPageChanged: (int value) {
              module.setCurrentPeriod(module.periods[value]);
            },
            floatingButtons: simulate
                ? [
                    YFloatingButton(
                        icon: Icons.add_rounded,
                        onPressed: () async {
                          final Grade? grade =
                              await YModalBottomSheets.show(context: context, child: _AddCustomGradeSheet(module));
                          if (grade != null) {
                            await module.addCustomGrade(grade);
                          }
                        }),
                    YFloatingButton(
                        icon: Icons.close_rounded,
                        onPressed: () {
                          setState(() {
                            simulate = false;
                          });
                        })
                  ]
                : [
                    YFloatingButton(
                        icon: MdiIcons.flask,
                        onPressed: () {
                          setState(() {
                            simulate = true;
                          });
                        })
                  ],
          ));
        });
  }
}

class _AddCustomGradeSheet extends StatefulWidget {
  final GradesModule module;
  const _AddCustomGradeSheet(this.module, {Key? key}) : super(key: key);

  @override
  __AddCustomGradeSheetState createState() => __AddCustomGradeSheetState();
}

class __AddCustomGradeSheetState extends State<_AddCustomGradeSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double value = double.nan;
  double outOf = 20;
  double coefficient = 1;
  Subject? subject;

  void submit(bool value) {
    _formKey.currentState!.save();
    final Grade grade = Grade.custom(
        coefficient: coefficient,
        outOf: outOf,
        value: this.value,
        subjectId: subject!.id,
        periodId: widget.module.currentPeriod!.id);
    Navigator.pop(context, grade);
  }

  double? parseValue(String value) => double.tryParse(value.replaceAll(",", "."));

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: YPadding.p(YScale.s4),
        child: Column(
          children: [
            Text("Ajouter une note", style: theme.texts.title),
            YVerticalSpacer(YScale.s6),
            YForm(
                formKey: _formKey,
                fields: [
                  YFormField(
                    type: YFormFieldInputType.number,
                    label: "Note",
                    properties: YFormFieldProperties(),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Ce champ est obligatoire... T'as déjà vu une note sans note toi ?";
                      }
                      final double? parsedValue = parseValue(value);
                      if (parsedValue == null) {
                        return "Ce champ doit être un nombre valide";
                      }
                      if (parsedValue < 0 || parsedValue > outOf) {
                        return "Ce champ doit être compris entre 0 et $outOf";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        this.value = parseValue(value) ?? double.nan;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        this.value = parseValue(value!) ?? double.nan;
                      });
                    },
                  ),
                  YFormField(
                    type: YFormFieldInputType.number,
                    label: "Sur",
                    defaultValue: outOf.toInt().toString(),
                    properties: YFormFieldProperties(),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Ce champ est obligatoire";
                      }
                      final double? parsedValue = parseValue(value);
                      if (parsedValue == null) {
                        return "Ce champ doit être un nombre valide";
                      }
                      if (parsedValue <= 0 || parsedValue < this.value) {
                        return "Ce champ doit être supérieur à 0 et supérieur ou égal à ${this.value}";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        outOf = parseValue(value!) ?? double.nan;
                      });
                    },
                  ),
                  YFormField(
                    type: YFormFieldInputType.number,
                    label: "Coefficient",
                    defaultValue: coefficient.toInt().toString(),
                    properties: YFormFieldProperties(),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Ce champ est obligatoire";
                      }
                      final double? parsedValue = parseValue(value);
                      if (parsedValue == null) {
                        return "Ce champ doit être un nombre valide";
                      }
                      if (parsedValue < 0) {
                        return "Ce champ ne peut être inférieur à 0";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        coefficient = parseValue(value!) ?? double.nan;
                      });
                    },
                  ),
                ],
                onSubmit: submit),
            YVerticalSpacer(YScale.s4),
            YButton(
                onPressed: () async {
                  final List<YConfirmationDialogOption<Subject>> options = widget.module.subjects
                      .map((subject) => YConfirmationDialogOption(value: subject, label: subject.name))
                      .toList();
                  final res = await YDialogs.getConfirmation(
                      context,
                      YConfirmationDialog(
                        title: "Choisis une matière",
                        options: options,
                        initialValue: subject,
                      ));
                  if (res != null) {
                    setState(() {
                      subject = res;
                    });
                  }
                },
                text: "Matière : ${subject?.name ?? "Aucune"}",
                color: YColor.secondary,
                block: true),
            YVerticalSpacer(YScale.s10),
            YButton(
              onPressed: () {
                final bool valid = _formKey.currentState!.validate();
                if (valid) {
                  submit(valid);
                }
              },
              text: "AJOUTER",
              block: true,
              isDisabled: value.isNaN || subject == null,
              onPressedDisabled: () {
                YSnackbars.error(context, message: "La note et la matière doivent être renseignées");
              },
            )
          ],
        ));
  }
}
