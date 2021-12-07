part of ecole_directe;

class _GradesModule extends GradesModule<_GradesRepository> {
  _GradesModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _GradesRepository(api), api: api);

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();

    List<X> getDifference<X>(List<X> x, List<X> y) {
      final int lx = x.length;
      final int ly = y.length;
      if (lx == ly) {
        return [];
      }
      final List<X> l1 = lx > ly ? x : y;
      final List<X> l2 = lx > ly ? y : x;
      return l1.toSet().difference(l2.toSet()).toList();
    }

    if (online) {
      final res = await repository.get();
      if (res.error != null) {
        return Response(error: res.error);
      }
      final List<Period> _periods = res.data!["periods"];
      if (_periods.length != periods.length) {
        final List<Period> diff = getDifference(_periods, periods);
        if (diff.isNotEmpty) {
          if (_periods.length > periods.length) {
            for (final p in diff) {
              periods.remove(p);
            }
          } else {
            periods.addAll(diff);
          }
        }
      }
      periods.sort((a, b) => a.startDate.compareTo(b.startDate));
      _periods.sort((a, b) => a.startDate.compareTo(b.startDate));
      for (int i = 0; i < periods.length; i++) {
        Period p = periods[i];
        final Period _p = _periods[i];
        if (p != _p) {
          p = _p;
        }
      }
      periods.sort((a, b) => a.startDate.compareTo(b.startDate));
      final List<Subject> _subjects = res.data!["subjects"];
      final List<Grade> _grades = res.data!["grades"];
      // TODO: check before setting values
      await offline.setPeriods(periods);
      await offline.setSubjects(subjects);
      await offline.setGrades(grades);
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
