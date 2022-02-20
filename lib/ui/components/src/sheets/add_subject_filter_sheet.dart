part of components;

class AddSubjectFilterSheet extends StatefulWidget {
  const AddSubjectFilterSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AddSubjectFilterSheet> createState() => AddSubjectFilterSheetState();
}

class AddSubjectFilterSheetState extends State<AddSubjectFilterSheet> {
  final GradesModule module = schoolApi.gradesModule;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Subject> _subjects = [];
  String name = "";

  void submit(bool value) {
    _formKey.currentState!.save();
    final List<Subject> allSubjects = [];
    for (final subject in _subjects) {
      allSubjects.add(subject);
      allSubjects.addAll(module.subjects.where((s) => s.entityId == subject.entityId));
    }
    final SubjectsFilter filter = SubjectsFilter.fromName(name: name)..subjects.addAll(allSubjects);
    Navigator.pop(context, filter);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s4),
      child: Column(
        children: [
          Text("Ajouter un filtre de matières", style: theme.texts.title),
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
                    if (module.filters.map((e) => e.name).toList().contains(value)) {
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
