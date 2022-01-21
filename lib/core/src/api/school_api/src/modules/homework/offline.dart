part of school_api;

class OfflineHomework extends OfflineModel {
  OfflineHomework() : super('homework');

  static const String _homeworkKey = "homework";

  Future<List<Homework>> getHomework() async {
    return (box?.get(_homeworkKey) as List<dynamic>?)?.map<Homework>((e) => e).toList() ?? [];
  }

  Future<void> setHomework(List<Homework> homework) async {
    await box?.put(_homeworkKey, homework);
  }
}
