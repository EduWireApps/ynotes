part of school_api;

abstract class GradesModule<R extends Repository> extends Module<R> {
  GradesModule({required R repository, required SchoolApi api})
      : super(
          isSupported: api.modulesSupport.grades,
          isAvailable: api.modulesAvailability.grades,
          repository: repository,
          api: api,
        );

  List<Grade> get grades {
    final _grades = offline.grades.where().sortByEntryDate().build().findAllSync();
    for (final grade in _grades) {
      grade.load();
    }
    return _grades;
  }

  List<Period> get periods {
    final _periods = offline.periods.where().findAllSync();
    for (final period in _periods) {
      period.load();
    }
    return _periods;
  }

  List<Subject> get subjects {
    final _subjects = offline.subjects.where().sortByName().findAllSync();
    for (final subject in _subjects) {
      subject.load();
    }
    return _subjects;
  }

  Period? get currentPeriod {
    if (_Storage.values.currentPeriodId == null) {
      return null;
    }
    final Period? _period = offline.periods.filter().entityIdEqualTo(_Storage.values.currentPeriodId!).findFirstSync();
    if (_period == null) {
      return null;
    }
    _period.grades.loadSync();
    return _period;
  }

  SubjectsFilter? get currentFilter =>
      customFilters.firstWhereOrNull((element) => element.entityId == _Storage.values.currentFilterId) ?? filters[0];

  List<SubjectsFilter> get customFilters {
    final _subjects = offline.subjectsFilters.where().sortByName().findAllSync();
    for (final subject in _subjects) {
      subject.load();
    }
    return _subjects;
  }

  List<SubjectsFilter> get filters => [..._defaultFilters, ...customFilters];
  late final List<SubjectsFilter> _defaultFilters = [SubjectsFilter(name: "Toutes matières", entityId: "all")];

  @override
  Future<Response<void>> fetch() async {
    fetching = true;
    notifyListeners();
    final res = await repository.get();
    if (res.error != null) return res;
    // Handling periods.
    final List<Period> __periods = res.data!["periods"] ?? [];
    // Handling subjects.
    final List<Subject> __subjects = res.data!["subjects"] ?? [];
    for (final __subject in __subjects) {
      final Subject? _subject = subjects.firstWhereOrNull((subject) => subject.entityId == __subject.entityId);
      if (_subject != null) {
        __subject.color = _subject.color;
      }
    }
    // Handling grades.
    final List<Grade> __grades = res.data!["grades"] ?? [];
    if (__grades.length > grades.length) {
      // TODO: check if this really works
      final List<Grade> newGrades = __grades.sublist(grades.length);
      // TODO: trigger notification
    }
    // We save all the data. Here is an overview of the process:
    // 1. We retrieve the custom grades
    // 2. For each custom grade, we update its subject and period to a new one, not
    //    saved in Isar yet. If the subject or period is not found, we delete the grade.
    // 3. We clear all the data
    // 4. We store all the data that comes from the API
    // 5. We save the custom grades
    // 6. We save the links of all grades
    await offline.writeTxn((isar) async {
      // STEP 1
      final customGrades = await isar.grades.filter().customEqualTo(true).findAll();
      // STEP 2
      for (final grade in customGrades) {
        await grade.subject.load();
        await grade.period.load();
        final Subject? subject =
            __subjects.firstWhereOrNull((subject) => subject.entityId == grade.subject.value!.entityId);
        final Period? period = __periods.firstWhereOrNull((period) => period.entityId == grade.period.value!.entityId);
        if (subject == null || period == null) {
          await isar.grades.delete(grade.id!);
        } else {
          grade.subject.value = subject;
          grade.period.value = period;
        }
      }
      // STEP 3
      await isar.periods.clear();
      await isar.subjects.clear();
      await isar.grades.clear();
      // STEP 4
      await isar.periods.putAll(__periods);
      await isar.subjects.putAll(__subjects);
      await isar.grades.putAll(__grades);
      // STEP 5
      await isar.grades.putAll(customGrades);
      // STEP 6
      await Future.forEach(__grades, (Grade grade) async {
        await grade.period.save();
        await grade.subject.save();
      });
      await Future.forEach(customGrades, (Grade grade) async {
        await grade.period.save();
        await grade.subject.save();
      });
    });
    await setCurrentPeriod();
    await setCurrentFilter();
    fetching = false;
    notifyListeners();
    return const Response();
  }

  Future<void> setCurrentPeriod([Period? period]) async {
    String? id;
    if (period == null) {
      final DateTime now = DateTime.now();
      id = periods
          .firstWhereOrNull((period) =>
              now.isAfter(period.startDate) &&
              (now.isBefore(period.endDate) ||
                  (now.year == period.endDate.year &&
                      now.month == period.endDate.month &&
                      now.day == period.endDate.day)))
          ?.entityId;
    } else {
      id = period.entityId;
    }
    _Storage.values.currentPeriodId = id;
    await _Storage.update();
    notifyListeners();
  }

  Future<void> setCurrentFilter([SubjectsFilter? filter]) async {
    String? id;
    if (filter == null) {
      if (currentFilter == null) {
        id = filters.first.entityId;
      }
    } else {
      id = filter.entityId;
    }
    _Storage.values.currentFilterId = id;
    await _Storage.update();
    notifyListeners();
  }

  double calculateAverage(List<double> values, List<double> coefficients) {
    if (values.isEmpty || (values.length != coefficients.length)) return double.nan;
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
      final Map<String, List<Grade>> map = {};
      for (final grade in grades) {
        grade.load();
        final String subjectName = grade.subject.value!.entityId;
        if (map.containsKey(subjectName)) {
          map[subjectName]!.add(grade);
        } else {
          map[subjectName] = [grade];
        }
      }
      for (final entry in map.entries) {
        final List<Grade> grades = entry.value;
        avgs.add(calculateAverageFromGrades(grades));
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

  Future<Response<void>> addFilter(SubjectsFilter filter) async {
    await offline.writeTxn((isar) async {
      await isar.subjects.putAll(filter.subjects.toList());
      await isar.subjectsFilters.put(filter);
      await filter.subjects.save();
    });
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> removeFilter(SubjectsFilter filter) async {
    await offline.writeTxn((isar) async {
      await isar.subjectsFilters.delete(filter.id!);
    });
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> updateFilter(SubjectsFilter filter) async {
    await removeFilter(filter);
    await addFilter(filter);
    return const Response();
  }

  Future<Response<void>> addCustomGrade(Grade grade) async {
    if (!grade.custom) return const Response(error: "Grade is not custom");
    await offline.writeTxn((isar) async {
      await isar.grades.put(grade);
    });
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> removeCustomGrade(Grade grade) async {
    if (!grade.custom) return const Response(error: "Grade is not custom");
    await offline.writeTxn((isar) async {
      await isar.grades.delete(grade.id!);
    });
    notifyListeners();
    return const Response();
  }

  @override
  Future<void> reset() async {
    await offline.writeTxn((isar) async {
      await isar.grades.clear();
      await isar.periods.clear();
      await isar.subjects.clear();
    });
    _Storage.values.currentPeriodId = null;
    _Storage.values.currentFilterId = null;
    await _Storage.update();
    notifyListeners();
  }
}
