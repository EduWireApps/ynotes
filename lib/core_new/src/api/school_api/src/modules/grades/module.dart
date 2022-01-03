part of school_api;

abstract class GradesModule<R extends Repository> extends Module<R, OfflineGrades> {
  GradesModule({required R repository, required SchoolApi api})
      : super(
            isSupported: api.modulesSupport.grades,
            isAvailable: api.modulesAvailability.grades,
            repository: repository,
            api: api,
            offline: OfflineGrades());

  List<Grade> get grades => _grades;
  List<Period> get periods => _periods;
  List<Subject> get subjects => _subjects;
  Period? get currentPeriod => _currentPeriod;
  SubjectsFilter? get currentFilter => _currentFilter;
  List<SubjectsFilter> get customFilters => _customFilters;
  List<Grade> _grades = [];
  List<Period> _periods = [];
  List<Subject> _subjects = [];
  Period? _currentPeriod;
  SubjectsFilter? _currentFilter;
  List<SubjectsFilter> _customFilters = [];

  List<SubjectsFilter> get filters => [..._defaultFilters, ...customFilters];
  late final List<SubjectsFilter> _defaultFilters = [
    SubjectsFilter(name: "Toutes matières", subjectsIds: null, id: "all")
  ];

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) return res;
      _periods = res.data!["periods"] ?? [];
      final List<Grade> __grades = res.data!["grades"] ?? [];
      if (__grades.length > _grades.length) {
        // TODO: check if this really works
        final List<Grade> newGrades = __grades.sublist(_grades.length);
        // TODO: trigger notification
      }
      _grades = __grades;
      final List<Subject> __subjects = res.data!["subjects"] ?? [];
      for (final __subject in __subjects) {
        final Subject? _subject = _subjects.firstWhereOrNull((subject) => subject.id == __subject.id);
        if (_subject != null) {
          __subject.color = _subject.color;
        }
      }
      _subjects = __subjects;
      await offline.setPeriods(_periods);
      await offline.setSubjects(_subjects);
      await offline.setGrades(_grades);
    } else {
      _periods = await offline.getPeriods();
      _subjects = await offline.getSubjects();
      _grades = await offline.getGrades();
    }
    await setCurrentPeriod();
    await offline.setCustomFilters(filters);
    await setCurrentFilter();
    fetching = false;
    notifyListeners();
    return const Response();
  }

  Future<void> setCurrentPeriod([Period? period]) async {
    if (period == null) {
      final String? periodId = await offline.getCurrentPeriodId();
      final Period? offlinePeriod = periodId == null ? null : _periods.firstWhereOrNull((e) => e.id == periodId);
      if (offlinePeriod != null) {
        _currentPeriod = offlinePeriod;
        notifyListeners();
      } else {
        final DateTime now = DateTime.now();
        _currentPeriod = _periods.firstWhereOrNull((period) =>
            now.isAfter(period.startDate) &&
            (now.isBefore(period.endDate) ||
                (now.year == period.endDate.year &&
                    now.month == period.endDate.month &&
                    now.day == period.endDate.day)));
      }
    } else {
      _currentPeriod = period;
    }
    await offline.setCurrentPeriodId(_currentPeriod?.id);
    notifyListeners();
  }

  Future<void> setCurrentFilter([SubjectsFilter? filter]) async {
    if (filter == null) {
      final String? filterId = await offline.getCurrentFilterId();
      final SubjectsFilter? offlineFilter = filterId == null ? null : filters.firstWhereOrNull((e) => e.id == filterId);
      if (offlineFilter != null) {
        _currentFilter = offlineFilter;
        notifyListeners();
      } else {
        _currentFilter = filters[0];
      }
    } else {
      _currentFilter = filter;
    }
    await offline.setCurrentFilterId(_currentFilter?.id);
    notifyListeners();
  }

  double calculateAverage(List<double> values, List<double> coefficients) {
    if (values.isEmpty) return double.nan;
    double n = 0;
    double d = 0;
    for (int i = 0; i < values.length; i++) {
      n += values[i] * coefficients[i];
      d += coefficients[i];
    }
    if (d == 0) return 0;
    return (n / d).asFixed(2);
  }

  double calculateAverageFromGrades(List<Grade> grades, {bool bySubject = false}) {
    if (bySubject) {
      final List<double> avgs = [];
      for (final subject in subjects) {
        final List<Grade> __grades = subject.grades(grades);
        if (__grades.isNotEmpty) {
          avgs.add(calculateAverageFromGrades(__grades));
        }
      }
      double sum = 0.0;
      for (final avg in avgs) {
        sum += avg;
      }
      return (sum / avgs.length).asFixed(2);
    } else {
      List<double> values = [];
      List<double> coefficients = [];
      for (Grade grade in grades) {
        values.add(grade.realValue);
        coefficients.add(grade.coefficient);
      }
      return calculateAverage(values, coefficients);
    }
  }

  double calculateAverageFromSubjects(List<Subject> subjects, {Period? period}) {
    final List<List<Grade>> _grades = subjects.map((e) => e.grades(grades, period)).toList();
    final List<double> allValues = _grades.map((e) => calculateAverageFromGrades(e)).toList();
    final List<double> allCoefficients = subjects.map((e) => e.coefficient).toList();

    final List<double> values = [];
    final List<double> coefficients = [];
    for (int i = 0; i < allValues.length; i++) {
      final double value = allValues[i];
      final double coefficient = allCoefficients[i];
      if (!value.isNaN) {
        values.add(value);
        coefficients.add(coefficient);
      }
    }
    return calculateAverage(values, coefficients);
  }

  double calculateAverageFromPeriod(Period period) => calculateAverageFromSubjects(subjects, period: period);

  @override
  Future<void> reset({bool offline = false}) async {
    _grades = [];
    _periods = [];
    _subjects = [];
    _customFilters = [];
    _currentPeriod = null;
    await super.reset(offline: offline);
  }
}
