part of school_api;

class OfflineGrades extends OfflineModel {
  OfflineGrades() : super('grades');

  static const String currentPeriodKey = "currentPeriod";

  Future<Period?> getCurrentPeriod() async {
    return (box?.get(currentPeriodKey) as Period?);
  }

  Future<void> setCurrentPeriod(Period? period) async {
    box?.put(currentPeriodKey, period);
  }
}
