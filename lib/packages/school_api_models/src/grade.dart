part of models;

@HiveType(typeId: _HiveTypeIds.grade)
class Grade {
  @HiveField(0)
  final String name;
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
  final double classMax;
  @HiveField(11)
  final double classMin;
  @HiveField(12)
  final String subjectId;
  @HiveField(13)
  final String periodId;
  double get realValue => 20 * value / outOf;

  Grade(
      {required this.name,
      required this.type,
      required this.coefficient,
      required this.outOf,
      required this.value,
      required this.significant,
      required this.date,
      required this.entryDate,
      required this.classAverage,
      required this.classMax,
      required this.classMin,
      required this.subjectId,
      required this.periodId});
}

class CustomGrade extends Grade {
  CustomGrade({
    required double coefficient,
    required double outOf,
    required double value,
    required String subjectId,
    required String periodId,
  }) : super(
            name: "Simulée",
            type: "Simulation",
            coefficient: coefficient,
            outOf: outOf,
            value: value,
            significant: true,
            date: DateTime.now(),
            entryDate: DateTime.now(),
            classAverage: double.nan,
            classMax: double.nan,
            classMin: double.nan,
            subjectId: subjectId,
            periodId: periodId);
}
