part of models;

/// The model for a period.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.period)
class Period {
  /// The id of the period.
  @HiveField(0)
  final String id;

  /// The name of the period.
  @HiveField(1)
  final String name;

  /// The start date of the period.
  @HiveField(2)
  final DateTime startDate;

  /// The end date of the period.
  @HiveField(3)
  final DateTime endDate;

  /// The class head teacher.
  @HiveField(4)
  final String headTeacher;

  /// The user average for this period.
  @HiveField(5)
  final double overallAverage;

  /// The class average for this period.
  @HiveField(6)
  final double classAverage;

  /// The maximum average of the class for this period.
  @HiveField(7)
  final double maxAverage;

  /// The minimum average of the class for this period.
  @HiveField(8)
  final double minAverage;

  /// Get the grades related to this period from a list of [Grade]s.
  List<Grade> grades(List<Grade> grades) => grades.where((g) => g.periodId == id).toList();

  Period({
    required this.id,
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
