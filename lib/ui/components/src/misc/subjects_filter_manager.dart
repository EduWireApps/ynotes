part of components;

class SubjectsFiltersManager extends StatelessWidget {
  const SubjectsFiltersManager({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierConsumer<GradesModule>(
        controller: schoolApi.gradesModule,
        builder: (context, module, _) {
          return Row(
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
                  text: module.currentFilter.name,
                  color: YColor.secondary),
              Expanded(child: YHorizontalSpacer(YScale.s2)),
              YIconButton(
                  icon: Icons.add_rounded,
                  onPressed: () async {
                    final SubjectsFilter? res = await YModalBottomSheets.show<SubjectsFilter>(
                        context: context, child: _Sheet(schoolApi.gradesModule));
                    if (res != null) {
                      await module.addFilter(res);
                      YSnackbars.success(context, message: 'Filtre "${res.name}" ajouté !');
                      module.setCurrentFilter(res);
                    }
                  }),
              YIconButton(
                  icon: Icons.settings_rounded,
                  onPressed: () {
                    // TODO: open settings page
                  }),
            ],
          );
        });
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
    final SubjectsFilter filter = SubjectsFilter.fromName(name: name)..subjects.addAll(_subjects);
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
              if (valid) {
                submit(valid);
              }
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
