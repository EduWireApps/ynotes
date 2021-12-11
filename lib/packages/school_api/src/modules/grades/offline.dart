part of school_api;

class OfflineGrades extends OfflineModel {
  OfflineGrades() : super('grades');

  static const String currentPeriodKey = "currentPeriod";
  static const String currentFilterKey = "currentFilter";

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
}
