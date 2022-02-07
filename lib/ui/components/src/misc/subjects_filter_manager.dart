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
                    final List<YConfirmationDialogOption<String>> options = module.filters
                        .map((filter) => YConfirmationDialogOption(value: filter.entityId, label: filter.name))
                        .toList();
                    final String? res = await YDialogs.getConfirmation<String>(
                        context,
                        YConfirmationDialog(
                          title: "Filtre sélectionné",
                          options: options,
                          initialValue: module.currentFilter.entityId,
                        ));
                    if (res != null) {
                      await module.setCurrentFilter(module.filters.firstWhere((filter) => filter.entityId == res));
                    }
                  },
                  text: module.currentFilter.name,
                  color: YColor.secondary),
              Expanded(child: YHorizontalSpacer(YScale.s2)),
              YIconButton(
                  icon: Icons.add_rounded, onPressed: () async => await AppSheets.showAddSubjectFilterSheet(context)),
              YIconButton(
                  icon: Icons.settings_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, "/settings/filters");
                  }),
            ],
          );
        });
  }
}
