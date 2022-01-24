part of models;

/// The model for a period.
///
/// Can be stored in [Hive] storage.
@Collection()
class Period {
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

  final IsarLinks<Grade> grades = IsarLinks<Grade>();

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
