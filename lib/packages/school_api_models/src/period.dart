part of models;

@HiveType(typeId: _HiveTypeIds.period)
class Period {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final DateTime startDate;
  @HiveField(3)
  final DateTime endDate;
  @HiveField(4)
  final String headTeacher;
  @HiveField(5)
  final double overallAverage;
  @HiveField(6)
  final double classAverage;
  @HiveField(7)
  final double maxAverage;
  @HiveField(8)
  final double minAverage;

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
