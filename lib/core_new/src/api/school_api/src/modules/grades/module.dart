part of school_api;

abstract class GradesModule<R extends Repository> extends Module<R, OfflineGrades> {
  GradesModule({required bool isSupported, required bool isAvailable, required R repository, required SchoolApi api})
      : super(
            isSupported: isSupported,
            isAvailable: isAvailable,
            repository: repository,
            api: api,
            offline: OfflineGrades());

  List<Grade> grades = [];
  List<Period> periods = [];
  List<Subject> subjects = [];
  Period? currentPeriod;
  SubjectsFilter? currentFilter;
  List<SubjectsFilter> customFilters = [];
  List<SubjectsFilter> get filters => [..._defaultFilters, ...customFilters];
  late final List<SubjectsFilter> _defaultFilters = [
    SubjectsFilter(name: "Toutes matières", color: AppColors.blue, subjectsIds: null, custom: false, id: "all")
  ];

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) return res;
      periods = res.data!["periods"] ?? [];
      subjects = res.data!["subjects"] ?? [];
      final List<Grade> _grades = res.data!["grades"] ?? [];
      if (_grades.length > grades.length) {
        // TODO: check if this really works
        final List<Grade> newGrades = _grades.toSet().difference(grades.toSet()).toList();
        // TODO: trigger notification
      }
      grades = _grades;
      await offline.setPeriods(periods);
      await offline.setSubjects(subjects);
      await offline.setGrades(grades);
    } else {
      periods = await offline.getPeriods();
      subjects = await offline.getSubjects();
      grades = await offline.getGrades();
    }
    await setCurrentPeriod();
    await offline.setCustomFilters(filters);
    await setCurrentFilter();
    fetching = false;
    notifyListeners();
    return const Response();
  }

  Future<void> setCurrentPeriod({Period? period}) async {
    if (period == null) {
      final String? periodId = await offline.getCurrentPeriodId();
      final Period? offlinePeriod = periodId == null ? null : periods.firstWhereOrNull((e) => e.id == periodId);
      if (offlinePeriod != null) {
        currentPeriod = offlinePeriod;
        notifyListeners();
      } else {
        final DateTime now = DateTime.now();
        currentPeriod = periods.firstWhereOrNull((period) =>
            now.isAfter(period.startDate) &&
            (now.isBefore(period.endDate) ||
                (now.year == period.endDate.year &&
                    now.month == period.endDate.month &&
                    now.day == period.endDate.day)));
      }
    } else {
      currentPeriod = period;
    }
    await offline.setCurrentPeriodId(currentPeriod?.id);
    notifyListeners();
  }

  Future<void> setCurrentFilter({SubjectsFilter? filter}) async {
    if (filter == null) {
      final String? filterId = await offline.getCurrentFilterId();
      final SubjectsFilter? offlineFilter = filterId == null ? null : filters.firstWhereOrNull((e) => e.id == filterId);
      if (offlineFilter != null) {
        currentFilter = offlineFilter;
        notifyListeners();
      } else {
        currentFilter = filters[0];
      }
    } else {
      currentFilter = filter;
    }
    await offline.setCurrentFilterId(currentFilter?.id);
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

  double calculateAverageFromGrades(List<Grade> grades) {
    List<double> values = [];
    List<double> coefficients = [];
    for (Grade grade in grades) {
      values.add(grade.realValue);
      coefficients.add(grade.coefficient);
    }
    return calculateAverage(values, coefficients);
  }

  double calculateAverageFromSubjects(List<Subject> subjects, [Period? period]) {
    final List<List<Grade>> _grades = subjects.map((e) => e.grades(grades, period)).toList();
    final List<double> values = _grades.map((e) => calculateAverageFromGrades(e)).toList();
    final List<double> coefficients = subjects.map((e) => e.coefficient).toList();
    return calculateAverage(values, coefficients);
  }

  double calculateAverageFromPeriod(Period period) => calculateAverageFromSubjects(subjects, period);

  @override
  Future<void> reset({bool offline = false}) async {
    grades = [];
    periods = [];
    subjects = [];
    customFilters = [];
    currentPeriod = null;
    await super.reset(offline: offline);
  }
}
