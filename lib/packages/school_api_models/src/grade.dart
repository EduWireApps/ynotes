part of models;

@HiveType(typeId: _HiveTypeIds.grade)
class Grade extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final Subject subject;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final double coefficient;
  @HiveField(4)
  final double outOf;
  @HiveField(5)
  final double value;
  @HiveField(6)
  final bool significant;
  @HiveField(7)
  final DateTime date;
  @HiveField(8)
  final DateTime entryDate;
  @HiveField(9)
  final double classAverage;
  @HiveField(10)
  final double maxAverage;
  @HiveField(11)
  final double minAverage;

  Grade({
    required this.name,
    required this.subject,
    required this.type,
    required this.coefficient,
    required this.outOf,
    required this.value,
    required this.significant,
    required this.date,
    required this.entryDate,
    required this.classAverage,
    required this.maxAverage,
    required this.minAverage,
  });
}
