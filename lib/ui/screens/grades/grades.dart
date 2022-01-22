import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes/ui/screens/grades/widgets/widgets.dart';
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
    return ChangeNotifierConsumer<GradesModule>(
        controller: module,
        builder: (context, module, _) {
          final bool empty = module.grades.isEmpty && module.currentPeriod == null;
          Future<void> refresh() async {
            final res = await module.fetch(online: true);
            if (res.error != null) {
              YSnackbars.error(context, message: res.error!);
            }
          }

          return ZApp(
              page: YPage(
            onRefresh: refresh,
            appBar: YAppBar(
              title: "Notes",
              actions: [
                if (simulate) const YBadge(text: "SIMULATEUR"),
                YHorizontalSpacer(YScale.s2),
                const YBadge(text: "ALPHA", color: YColor.danger),
                if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                  YIconButton(icon: Icons.refresh_rounded, onPressed: refresh),
              ],
              bottom: empty && module.isFetching ? const YLinearProgressBar() : null,
            ),
            useBottomNavigation: false,
            scrollable: !empty,
            navigationInitialIndex: module.currentPeriod == null ? 0 : module.periods.indexOf(module.currentPeriod!),
            navigationElements: empty
                ? null
                : module.periods
                    .map((period) =>
                        YNavigationElement(label: period.name, widget: PeriodPage(module, period, simulate)))
                    .toList(),
            body: !empty
                ? null
                : Padding(
                    padding: YPadding.p(YScale.s4),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(AppRouter.routes.where((element) => element.path == "/grades").first.icon,
                              color: theme.colors.foregroundColor, size: YScale.s32),
                          YVerticalSpacer(YScale.s4),
                          Text(
                            "Pas de notes !",
                            style: theme.texts.body1,
                            textAlign: TextAlign.center,
                          ),
                          YVerticalSpacer(YScale.s6),
                          YButton(
                              onPressed: refresh,
                              text: "Rafraîchir".toUpperCase(),
                              color: YColor.secondary,
                              isDisabled: module.isFetching)
                        ],
                      ),
                    ),
                  ),
            onPageChanged: (int value) {
              module.setCurrentPeriod(module.periods[value]);
            },
            floatingButtons: empty
                ? null
                : simulate
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
