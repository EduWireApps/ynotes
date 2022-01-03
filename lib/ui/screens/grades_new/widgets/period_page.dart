import 'package:flutter/material.dart';
import 'package:ynotes/core_new/api.dart';
import 'package:ynotes/extensions.dart';
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
            children: [_Stats(module, period), YVerticalSpacer(YScale.s8), _SubjectsList(module, period)],
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

class _SubjectsList extends StatelessWidget {
  final GradesModule module;
  final Period period;
  const _SubjectsList(this.module, this.period, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: YPadding.px(YScale.s4),
          child: Row(
            children: [
              YButton(
                  onPressed: () async {
                    final List<YConfirmationDialogOption<SubjectsFilter>> options = module.filters
                        .map((filter) => YConfirmationDialogOption(value: filter, label: filter.name))
                        .toList();
                    final SubjectsFilter? res = await YDialogs.getConfirmation<SubjectsFilter>(
                        context,
                        YConfirmationDialog(
                          title: "Filtre",
                          options: options,
                          initialValue: module.currentFilter,
                        ));
                    if (res != null) {
                      await module.setCurrentFilter(res);
                    }
                  },
                  text: module.currentFilter!.name,
                  color: YColor.secondary),
              YHorizontalSpacer(YScale.s2),
              YIconButton(
                  icon: Icons.add_rounded,
                  onPressed: () async {
                    final SubjectsFilter? res =
                        await YModalBottomSheets.show<SubjectsFilter>(context: context, child: _Sheet(module));
                    if (res != null) {
                      // TODO: add filter (method required)
                      YSnackbars.success(context, message: 'Filtre "${res.name}" ajouté !');
                      // TODO: set current filter
                    }
                  }),
            ],
          ),
        ),
        YVerticalSpacer(YScale.s4),
      ],
    );
  }
}

class _Sheet extends StatefulWidget {
  final GradesModule module;
  const _Sheet(
    this.module, {
    Key? key,
  }) : super(key: key);

  @override
  State<_Sheet> createState() => _SheetState();
}

class _SheetState extends State<_Sheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Subject> _subjects = [];
  String name = "";

  void submit(bool value) {
    _formKey.currentState!.save();
    final SubjectsFilter filter = SubjectsFilter(name: name, subjectsIds: _subjects.map((s) => s.id).toList());
    Navigator.pop(context, filter);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s4),
      child: Column(
        children: [
          Text("Ajouter un filtre", style: theme.texts.title),
          YVerticalSpacer(YScale.s6),
          YForm(
              formKey: _formKey,
              fields: [
                YFormField(
                  type: YFormFieldInputType.text,
                  label: "Nom",
                  properties: YFormFieldProperties(),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ est obligatoire... Comment tu vas retrouver ton filtre sinon ?";
                    }
                    if (widget.module.filters.map((e) => e.name).toList().contains(value)) {
                      return "Ce nom est déjà utilisé";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      name = value!;
                    });
                  },
                )
              ],
              onSubmit: submit),
          YVerticalSpacer(YScale.s4),
          YButton(
              onPressed: () async {
                final List<YListDialogOption> options = widget.module.subjects
                    .map((subject) => YListDialogOption(
                        value: _subjects.map((e) => e.name).toList().contains(subject.name), label: subject.name))
                    .toList();
                final res = await YDialogs.getList(
                    context,
                    YListDialog(
                      title: "Choisis des matières",
                      options: options,
                    ));
                if (res != null) {
                  setState(() {
                    _subjects.clear();
                    for (var e in res) {
                      if (e.value) {
                        _subjects.add(widget.module.subjects.firstWhere((s) => s.name == e.label));
                      }
                    }
                  });
                }
              },
              text: "Matières (${_subjects.length})",
              color: YColor.secondary,
              block: true),
          YVerticalSpacer(YScale.s10),
          YButton(
            onPressed: () {
              final bool valid = _formKey.currentState!.validate();
              submit(valid);
            },
            text: "AJOUTER",
            block: true,
            isDisabled: _subjects.isEmpty,
            onPressedDisabled: () {
              YSnackbars.error(context, message: "Ajoute au moins une matière");
            },
          )
        ],
      ),
    );
  }
}
