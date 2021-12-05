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

  Future<void> setCurrentPeriod({Period? period}) async {
    if (period == null) {
      final Period? offlinePeriod = await offline.getCurrentPeriod();
      if (offlinePeriod != null) {
        currentPeriod = offlinePeriod;
        return;
      }
      final DateTime now = DateTime.now();
      currentPeriod = periods.firstWhereOrNull((period) =>
          now.isAfter(period.startDate) &&
          (now.isBefore(period.endDate) ||
              (now.year == period.endDate.year && now.month == period.endDate.month && now.day == period.endDate.day)));
    } else {
      currentPeriod = period;
    }
    await offline.setCurrentPeriod(currentPeriod);
    notifyListeners();
  }

  List<SubjectsFilter> filters = [];

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
    filters = [];
    currentPeriod = null;
    await super.reset(offline: offline);
  }
}

/* 
Things to do:
X current period. Saved to offline or KVS
- handle custom grades.
- handle custom subjects.
- handle filters
X handle averages calculations
- handle offline
*/