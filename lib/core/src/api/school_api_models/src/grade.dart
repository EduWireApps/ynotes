part of models;

/// The model for a grade.
///
/// Can be stored in [Hive] storage.
@Collection()
class Grade extends _LinkedModel {
  @Id()
  int? id;

  /// The name of the assessment associated with this grade.

  final String name;

  /// The type of assessment. Depends of the api.

  final String type;

  /// The coefficient. Can be 0.

  final double coefficient;

  /// The grade's denominator, 20 is the default one in France.

  final double outOf;

  /// The grade's numerator. Between 0 and [outOf].

  final double value;

  /// If the grade counts for the average.

  final bool significant;

  /// The assessment's date.

  final DateTime date;

  /// The date of the grade's entry by the teacher.

  final DateTime entryDate;

  /// The class average. Not calculated in realtime.

  final double classAverage;

  /// The highest grade in the class.

  final double classMax;

  /// The lowest grade in the class.

  final double classMin;

  /// If the grade is custom.

  final bool custom;

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
      this.custom = false});

  /// A grade that can be added by the user.
  /// Some fields are useless so this class let's you create a [Grade]
  /// with only required data.
  Grade.custom({
    required this.coefficient,
    required this.outOf,
    required this.value,
  })  : name = "Simulée",
        type = "Simulation",
        significant = true,
        date = DateTime.now(),
        entryDate = DateTime.now(),
        classAverage = double.nan,
        classMax = double.nan,
        classMin = double.nan,
        custom = true;

  // TODO: implement competences

  /// The value out of 20. Use this to calculate averages.
  double get realValue => 20 * value / outOf;

  final IsarLink<Subject> subject = IsarLink<Subject>();

  final IsarLink<Period> period = IsarLink<Period>();

  @override
  void load() {
    Offline.isar.writeTxnSync((isar) {
      subject.loadSync();
      period.loadSync();
    });
  }
}
