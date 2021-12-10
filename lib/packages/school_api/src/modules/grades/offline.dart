part of school_api;

class OfflineGrades extends OfflineModel {
  OfflineGrades() : super('grades');

  static const String _currentPeriodKey = "currentPeriod";
  static const String _currentFilterKey = "currentFilter";
  static const String _periodsKey = "periods";
  static const String _subjectsKey = "subjects";
  static const String _gradesKey = "grades";
  static const String _customFiltersKey = "customFilters";

  Future<String?> getCurrentPeriodId() async {
    return (box?.get(_currentPeriodKey) as String?);
  }

  Future<void> setCurrentPeriodId(String? periodId) async {
    await box?.put(_currentPeriodKey, periodId);
  }

  Future<String?> getCurrentFilterId() async {
    return (box?.get(_currentFilterKey) as String?);
  }

  Future<void> setCurrentFilterId(String? filterId) async {
    await box?.put(_currentFilterKey, filterId);
  }

  Future<List<Period>> getPeriods() async {
    return (box?.get(_periodsKey) as List<dynamic>?)?.map<Period>((e) => e).toList() ?? [];
  }

  Future<void> setPeriods(List<Period> periods) async {
    await box?.put(_periodsKey, periods);
  }

  Future<List<Subject>> getSubjects() async {
    return (box?.get(_subjectsKey) as List<dynamic>?)?.map<Subject>((e) => e).toList() ?? [];
  }

  Future<void> setSubjects(List<Subject> subjects) async {
    await box?.put(_subjectsKey, subjects);
  }

  Future<List<Grade>> getGrades() async {
    return (box?.get(_gradesKey) as List<dynamic>?)?.map<Grade>((e) => e).toList() ?? [];
  }

  Future<void> setGrades(List<Grade> grades) async {
    await box?.put(_gradesKey, grades);
  }

  Future<List<SubjectsFilter>> getCustomFilters() async {
    return (box?.get(_customFiltersKey) as List<dynamic>?)?.map<SubjectsFilter>((e) => e).toList() ?? [];
  }

  Future<void> setCustomFilters(List<SubjectsFilter> filters) async {
    await box?.put(_customFiltersKey, filters);
  }
}
