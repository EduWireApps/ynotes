part of models;

/// The model for a subject.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.subject)
class Subject {
  /// The id of the subject.
  @HiveField(0)
  final String id;

  /// The name of the subject.
  @HiveField(1)
  final String name;

  /// The average of the class for this subject.
  @HiveField(2)
  final double classAverage;

  /// The maximum average of the class for this subject.
  @HiveField(3)
  final double maxAverage;

  /// The minimum average of the class for this subject.
  @HiveField(4)
  final double minAverage;

  /// The coefficient of the subject.
  @HiveField(5)
  final double coefficient;

  /// The teachers of the subject.
  @HiveField(6)
  final String teachers;

  /// The grades of the subject.
  List<Grade> grades(List<Grade> grades, [Period? period]) =>
      grades.where((g) => g.subjectId == id && (period == null ? true : g.periodId == period.id)).toList();

  /// The average of the subject.
  @HiveField(7)
  final double average;

  Subject(
      {required this.id,
      required this.name,
      required this.classAverage,
      required this.maxAverage,
      required this.minAverage,
      required this.coefficient,
      required this.teachers,
      required this.average});
}

/// The model for a custom [Subject].
///
/// It only requires required data and can be used to
/// sort between [Subject]s and [CustomSubject]s:
///
/// ```dart
/// final bool custom = subject is CustomSubject;
/// ```
class CustomSubject extends Subject {
  CustomSubject(
      {required String name,
      required double coefficient,
      String teachers = "Pas de professeurs",
      required SchoolApi api})
      : super(
            id: md5.convert(utf8.encode(name)).toString(),
            name: name,
            classAverage: double.nan,
            maxAverage: double.nan,
            minAverage: double.nan,
            coefficient: coefficient,
            teachers: teachers,
            average: double.nan);
}
