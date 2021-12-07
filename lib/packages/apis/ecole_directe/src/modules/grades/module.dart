part of ecole_directe;

class _GradesModule extends GradesModule<_GradesRepository> {
  _GradesModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _GradesRepository(api), api: api);

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) {
        return Response(error: res.error);
      }
      periods = res.data!["periods"];
      subjects = res.data!["subjects"];
      grades = res.data!["grades"];
      // TODO: check before setting values
      offline.setPeriods(periods);
      offline.setSubjects(subjects);
      offline.setGrades(grades);
    } else {
      periods = await offline.getPeriods();
      subjects = await offline.getSubjects();
      grades = await offline.getGrades();
    }
    fetching = false;
    notifyListeners();
    return const Response();
  }
}
