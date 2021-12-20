part of models;

/// The model for a grade.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.grade)
class Grade {
  /// The name of the assessment associated with this grade.
  @HiveField(0)
  final String name;

  /// The type of assessment. Depends of the api.
  @HiveField(2)
  final String type;

  /// The coefficient. Can be 0.
  @HiveField(3)
  final double coefficient;

  /// The grade's denominator, 20 is the default one in France.
  @HiveField(4)
  final double outOf;

  /// The grade's numerator. Between 0 and [outOf].
  @HiveField(5)
  final double value;

  /// If the grade counts for the average.
  @HiveField(6)
  final bool significant;

  /// The assessment's date.
  @HiveField(7)
  final DateTime date;

  /// The date of the grade's entry by the teacher.
  @HiveField(8)
  final DateTime entryDate;

  /// The class average. Not calculated in realtime.
  @HiveField(9)
  final double classAverage;

  /// The highest grade in the class.
  @HiveField(10)
  final double classMax;

  /// The lowest grade in the class.
  @HiveField(11)
  final double classMin;

  /// The subject's id.
  @HiveField(12)
  final String subjectId;

  /// The period's id.
  @HiveField(13)
  final String periodId;

  /// The value out of 20. Use this to calculate averages.
  double get realValue => 20 * value / outOf;

  // TODO: implement competences

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

/// A grade that can be added by the user.
/// Some fields are useless so this class let's you create a [Grade]
/// with only required data.
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
