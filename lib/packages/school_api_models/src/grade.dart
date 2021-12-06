part of models;

@HiveType(typeId: _HiveTypeIds.grade)
class Grade {
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
  @HiveField(12)
  final String subjectId;

  Grade(
      {required this.name,
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
      required this.subjectId});
}

class CustomGrade extends Grade {
  CustomGrade({
    required Subject subject,
    required double coefficient,
    required double outOf,
    required double value,
    required String subjectId,
  }) : super(
          name: "Simulée",
          subject: subject,
          type: "Simulation",
          coefficient: coefficient,
          outOf: outOf,
          value: value,
          significant: true,
          date: DateTime.now(),
          entryDate: DateTime.now(),
          classAverage: double.nan,
          maxAverage: double.nan,
          minAverage: double.nan,
          subjectId: subjectId,
        );
}
