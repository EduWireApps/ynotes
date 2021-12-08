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
        return;
      }
      currentFilter = filters[0];
    } else {
      currentFilter = filter;
    }
    await offline.setCurrentFilterId(currentFilter?.id);
    notifyListeners();
  }

  double calculateAverage(List<double> numerators, List<double> denominators) {
    double n = 0;
    double d = 0;
    for (int i = 0; i < numerators.length; i++) {
      n += numerators[i] * denominators[i];
      d += denominators[i];
    }
    return n / d;
  }

  double calculateAverageFromGrades(List<Grade> grades) {
    List<double> numerators = [];
    List<double> denominators = [];
    for (Grade grade in grades) {
      numerators.add(grade.value);
      denominators.add(grade.coefficient);
    }
    return calculateAverage(numerators, denominators);
  }

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
