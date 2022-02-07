part of components;

class EditSubjectFilterSheet extends StatefulWidget {
  final SubjectsFilter filter;
  const EditSubjectFilterSheet({Key? key, required this.filter}) : super(key: key);

  @override
  State<EditSubjectFilterSheet> createState() => EditSubjectFilterSheetState();
}

class EditSubjectFilterSheetState extends State<EditSubjectFilterSheet> {
  final GradesModule module = schoolApi.gradesModule;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final List<Subject> _subjects = widget.filter.subjects
      .map((e) => e.entityId)
      .toSet()
      .map((e) => widget.filter.subjects.firstWhere((element) => element.entityId == e))
      .toList();
  late String name = widget.filter.name;

  void submit(bool value) {
    _formKey.currentState!.save();
    final List<Subject> allSubjects = [];
    for (final subject in _subjects) {
      allSubjects.add(subject);
      allSubjects.addAll(module.subjects.where((s) => s.entityId == subject.entityId));
    }
    final SubjectsFilter filter = widget.filter;
    filter.name = name;
    filter.subjects.clear();
    filter.subjects.addAll(allSubjects);
    Navigator.pop(context, filter);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s4),
      child: Column(
        children: [
          Text("Editer un filtre de matières", style: theme.texts.title),
          YVerticalSpacer(YScale.s6),
          YForm(
              formKey: _formKey,
              fields: [
                YFormField(
                  type: YFormFieldInputType.text,
                  label: "Nom",
                  defaultValue: widget.filter.name,
                  properties: YFormFieldProperties(),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ est obligatoire... Comment tu vas retrouver ton filtre sinon ?";
                    }
                    if (value != widget.filter.name) {
                      if (module.filters.map((e) => e.name).toList().contains(value)) {
                        return "Ce nom est déjà utilisé";
                      }
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
                final List<YListDialogOption> options = module.currentPeriod!.sortedSubjects
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
                        _subjects.add(module.subjects.firstWhere((s) => s.name == e.label));
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
            text: "MODIFIER",
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
