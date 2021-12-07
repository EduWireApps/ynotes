part of school_api;

class OfflineGrades extends OfflineModel {
  OfflineGrades() : super('grades');

  static const String currentPeriodKey = "currentPeriod";
  static const String currentFilterKey = "currentFilter";
  static const String periodsKey = "periods";
  static const String subjectsKey = "subjects";
  static const String gradesKey = "grades";

  Future<Period?> getCurrentPeriod() async {
    return (box?.get(currentPeriodKey) as Period?);
  }

  Future<void> setCurrentPeriod(Period? period) async {
    box?.put(currentPeriodKey, period);
  }

  Future<SubjectsFilter?> getCurrentFilter() async {
    return (box?.get(currentFilterKey) as SubjectsFilter?);
  }

  Future<void> setCurrentFilter(SubjectsFilter? filter) async {
    box?.put(currentFilterKey, filter);
  }

  Future<List<Period>> getPeriods() async {
    return (box?.get(periodsKey) as List<dynamic>?)?.map<Period>((e) => e).toList() ?? [];
  }

  Future<void> setPeriods(List<Period> periods) async {
    box?.put(periodsKey, periods);
  }

  Future<List<Subject>> getSubjects() async {
    return (box?.get(subjectsKey) as List<dynamic>?)?.map<Subject>((e) => e).toList() ?? [];
  }

  Future<void> setSubjects(List<Subject> subjects) async {
    box?.put(subjectsKey, subjects);
  }

  Future<List<Grade>> getGrades() async {
    return (box?.get(gradesKey) as List<dynamic>?)?.map<Grade>((e) => e).toList() ?? [];
  }

  Future<void> setGrades(List<Grade> grades) async {
    box?.put(gradesKey, grades);
  }
}
