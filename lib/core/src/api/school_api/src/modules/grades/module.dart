part of school_api;

abstract class GradesModule<R extends Repository> extends Module<R> {
  late final List<SubjectsFilter> _defaultFilters = [SubjectsFilter(name: "Toutes matières", entityId: "all")];

  GradesModule({required R repository, required SchoolApi api})
      : super(
          isSupported: api.modulesSupport.grades,
          isAvailable: api.modulesAvailability.grades,
          repository: repository,
          api: api,
        );

  /// The current [SubjectsFilter]. Defaults to all subjects.
  SubjectsFilter get currentFilter =>
      filters.firstWhereOrNull((element) => element.entityId == _Storage.values.currentFilterId) ?? filters.first;

  /// The current period. By default, the one with corresponding start and end dates.
  Period? get currentPeriod {
    if (_Storage.values.currentPeriodId == null) {
      return null;
    }
    final Period? _period = offline.periods.filter().entityIdEqualTo(_Storage.values.currentPeriodId!).findFirstSync();
    if (_period == null) {
      return null;
    }
    _period.load();
    return _period;
  }

  /// The user provided [SubjectsFilter]s.
  List<SubjectsFilter> get customFilters {
    final _subjects = offline.subjectsFilters.where().sortByName().findAllSync();
    for (final subject in _subjects) {
      subject.load();
    }
    return _subjects;
  }

  /// All the [SubjectsFilter]s.
  List<SubjectsFilter> get filters => [..._defaultFilters, ...customFilters];

  /// ALl the grades stored offline, sorted by [Grade.entryDate].
  List<Grade> get grades {
    final _grades = offline.grades.where().sortByEntryDate().build().findAllSync();
    for (final grade in _grades) {
      grade.load();
    }
    return _grades;
  }

  /// All the periods stored offline.
  List<Period> get periods {
    final _periods = offline.periods.where().findAllSync();
    for (final period in _periods) {
      period.load();
    }
    return _periods;
  }

  /// All the subjects stored offline, sorted by [Subject.name].
  List<Subject> get subjects {
    final _subjects = offline.subjects.where().sortByName().findAllSync();
    for (final subject in _subjects) {
      subject.load();
    }
    return _subjects;
  }

  /// Adds a custom [grade].
  Future<Response<void>> addCustomGrade(Grade grade) async {
    if (!grade.custom) return Response(error: "Grade is not custom");
    await offline.writeTxn((isar) async {
      await isar.grades.put(grade);
    });
    notifyListeners();
    return Response();
  }

  /// Adds a [filter] to [customFilters].
  Future<Response<void>> addFilter(SubjectsFilter filter) async {
    await offline.writeTxn((isar) async {
      // await isar.subjects.putAll(filter.subjects.toList());
      await isar.subjectsFilters.put(filter);
      await filter.subjects.save();
    });
    notifyListeners();
    return Response();
  }

  /// Calculates a a weighted average from a list of values and coefficients.
  double calculateAverage(List<double> values, List<double> coefficients) {
    if (values.length != coefficients.length) return double.nan;
    double n = 0;
    double d = 0;
    for (int i = 0; i < values.length; i++) {
      n += values[i] * coefficients[i];
      d += coefficients[i];
    }
    if (d == 0) return 0;
    return (n / d).asFixed(2);
  }

  /// Calculates the average of a list of grades. Can be by subject.
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
        if (grade.value.significant && (grade.value.valueType != gradeValueType.string)) {
          values.add(grade.realValue);
          /// It is asserted not null
          coefficients.add(grade.value.coefficient!);
        }
      }
      return calculateAverage(values, coefficients);
    }
  }

  /// Fetches data from the API. Retrieves all the grades, subjects, and periods.
  /// Any custom data (e.g. custom filters) is not affected.
  @override
  Future<Response<void>> fetch() async {
    if (fetching) {
      return Response(error: "Already fetching");
    }
    fetching = true;
    notifyListeners();
    final res = await repository.get();
    if (res.hasError) return res;
    final List<Period> __periods = res.data!["periods"] ?? [];
    final List<Subject> __subjects = res.data!["subjects"] ?? [];
    // If a subject already exists, we only keep its color so that it doesn't
    // get updated on each [fetch].
    for (final __subject in __subjects) {
      final Subject? _subject = subjects.firstWhereOrNull((subject) => subject.entityId == __subject.entityId);
      if (_subject != null) {
        __subject.color = _subject.color;
      }
    }
    final List<Grade> __grades = res.data!["grades"] ?? [];
    // For each new grade, a notification is sent.
    if (__grades.length > grades.length) {
      // TODO: check if this really works
      // TODO: trigger notification
      final List<Grade> newGrades = __grades.sublist(grades.length);
    }
    // We save all the data. Here is an overview of the process:
    // 1. We retrieve the custom grades
    // 1.5 We retrieve the filters and assigned the new corresponding subjects
    // 2. For each custom grade, we update its subject and period to a new one, not
    //    saved in Isar yet. If the subject or period is not found, we delete the grade.
    // 3. We clear all the data
    // 4. We store all the data that comes from the API
    // 5. We save the custom grades
    // 6. We save the links of all grades
    await offline.writeTxn((isar) async {
      // STEP 1
      final customGrades = await isar.grades.filter().customEqualTo(true).findAll();
      // STEP 1.5
      final filters = await isar.subjectsFilters.where().findAll();
      for (final filter in filters) {
        await filter.subjects.load();
        final List<String> subjectsIds = filter.subjects.map((subject) => subject.entityId).toSet().toList();
        final List<Subject> subjects = __subjects.where((subject) => subjectsIds.contains(subject.entityId)).toList();
        filter.subjects.clear();
        filter.subjects.addAll(subjects);
      }
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
      await isar.subjectsFilters.clear();
      // STEP 4
      await isar.periods.putAll(__periods);
      await isar.subjects.putAll(__subjects);
      await isar.grades.putAll(__grades);
      // STEP 5
      await isar.grades.putAll(customGrades);
      await isar.subjectsFilters.putAll(filters);

      // STEP 6
      await Future.forEach(__subjects, (Subject subject) async {
        await subject.period.save();
      });
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
    Logger.log("GRADES MODULE", "Fetch successful");
    return Response();
  }

  /// Removes a custom [grade].
  Future<Response<void>> removeCustomGrade(Grade grade) async {
    if (!grade.custom) return Response(error: "Grade is not custom");
    await offline.writeTxn((isar) async {
      await isar.grades.delete(grade.id!);
    });
    notifyListeners();
    return Response();
  }

  /// Removes a [filter] from [customFilters].
  Future<Response<void>> removeFilter(SubjectsFilter filter) async {
    await offline.writeTxn((isar) async {
      await isar.subjectsFilters.delete(filter.id!);
    });
    if (filter.entityId == currentFilter.entityId) {
      await setCurrentFilter(_defaultFilters.first);
    }
    notifyListeners();
    return Response();
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

  /// Sets the current [SubjectsFilter].
  Future<void> setCurrentFilter([SubjectsFilter? filter]) async {
    String id;
    if (filter == null) {
      if (_Storage.values.currentFilterId == null) {
        id = filters.first.entityId;
      } else {
        id = _Storage.values.currentFilterId!;
      }
    } else {
      id = filter.entityId;
    }
    _Storage.values.currentFilterId = id;
    await _Storage.update();
    notifyListeners();
  }

  /// Sets the current period.
  Future<void> setCurrentPeriod([Period? period]) async {
    String? id;
    if (period == null) {
      if (_Storage.values.currentPeriodId == null) {
        final DateTime now = DateTime.now();
        id = periods
            .firstWhereOrNull((period) =>
                now.isAfter(period.startDate) &&
                (now.isBefore(period.endDate) ||
                    (now.year == period.endDate.year &&
                        now.month == period.endDate.month &&
                        now.day == period.endDate.day)))
            ?.entityId;

        //Covering the case no period is suitable (between two periods for instance)
        if (id == null && periods.isNotEmpty) {
          id = periods.first.entityId;
        }
      } else {
        id = _Storage.values.currentPeriodId;
      }
    } else {
      id = period.entityId;
    }
    _Storage.values.currentPeriodId = id;
    await _Storage.update();
    notifyListeners();
  }

  /// Updates a [filter].
  Future<Response<void>> updateFilter(SubjectsFilter filter) async {
    await removeFilter(filter);
    await addFilter(filter);
    return Response();
  }

  /// Updates a subject.
  Future<void> updateSubject(Subject subject) async {
    final List<Subject> _subjects = subjects.where((e) => e.entityId == subject.entityId).map((e) {
      e.color = subject.color;
      return e;
    }).toList();
    await offline.writeTxn((isar) async {
      await isar.subjects.putAll([subject, ..._subjects]);
    });
    notifyListeners();
  }
}
