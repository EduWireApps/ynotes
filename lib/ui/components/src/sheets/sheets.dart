part of components;

/// A class that handles shared sheets accross the app
class AppSheets {
  /// A class that handles shared sheets accross the app
  const AppSheets._();

  static Future<void> showAddSubjectFilterSheet(BuildContext context) async {
    final SubjectsFilter? res =
        await YModalBottomSheets.show<SubjectsFilter>(context: context, child: const AddSubjectFilterSheet());
    if (res != null) {
      await schoolApi.gradesModule.addFilter(res);
      YSnackbars.success(context, message: 'Filtre "${res.name}" ajouté !');
      schoolApi.gradesModule.setCurrentFilter(res);
    }
  }

  static Future<void> showEditSubjectFilterSheet(BuildContext context, {required SubjectsFilter filter}) async {
    final SubjectsFilter? res =
        await YModalBottomSheets.show<SubjectsFilter>(context: context, child: EditSubjectFilterSheet(filter: filter));
    if (res != null) {
      await schoolApi.gradesModule.updateFilter(res);
      YSnackbars.success(context, message: 'Filtre "${res.name}" mis à jour !');
    }
  }
}
