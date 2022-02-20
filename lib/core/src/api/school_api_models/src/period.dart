part of models;

/// The model for a period.
///
/// Can be stored in [Hive] storage.
@Collection()
class Period extends _LinkedModel {
  @Id()
  int? id;

  /// The id of the period.
  final String entityId;

  /// The name of the period.
  final String name;

  /// The start date of the period.
  final DateTime startDate;

  /// The end date of the period.
  final DateTime endDate;

  /// The class head teacher.
  final String headTeacher;

  /// The user average for this period.
  final double overallAverage;

  /// The class average for this period.
  final double classAverage;

  /// The maximum average of the class for this period.
  final double maxAverage;

  /// The minimum average of the class for this period.
  final double minAverage;

  @Backlink(to: "period")
  final IsarLinks<Grade> grades = IsarLinks<Grade>();

  @Backlink(to: "period")
  final IsarLinks<Subject> subjects = IsarLinks<Subject>();

  List<Grade> get sortedGrades => grades.toList()..sort((a, b) => a.entryDate.compareTo(b.entryDate));

  List<Subject> get sortedSubjects => subjects.toList()..sort((a, b) => a.name.compareTo(b.name));

  @override
  void load() {
    Offline.isar.writeTxnSync((isar) {
      grades.loadSync();
      subjects.loadSync();
    });
    for (final grade in grades) {
      grade.load();
    }
    for (final subject in subjects) {
      subject.load();
    }
  }

  Period({
    required this.entityId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.headTeacher,
    required this.overallAverage,
    required this.classAverage,
    required this.maxAverage,
    required this.minAverage,
  });
}
