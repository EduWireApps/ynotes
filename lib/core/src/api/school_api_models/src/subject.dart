part of models;

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
      required SchoolApi api,
      required YTColor color})
      : super(
            id: md5.convert(utf8.encode(name)).toString(),
            name: name,
            classAverage: double.nan,
            maxAverage: double.nan,
            minAverage: double.nan,
            coefficient: coefficient,
            teachers: teachers,
            average: double.nan,
            color: color);
}

/// The model for a subject.
///
/// Can be stored in [Hive] storage.
@Collection()
class Subject {
  /// The id of the subject.

  @Id()
  int? isarId;

  final String id;

  /// The name of the subject.

  final String name;

  /// The average of the class for this subject.

  final double classAverage;

  /// The maximum average of the class for this subject.

  final double maxAverage;

  /// The minimum average of the class for this subject.

  final double minAverage;

  /// The coefficient of the subject.

  final double coefficient;

  /// The teachers of the subject.

  final String teachers;

  /// The average of the subject.

  final double average;

  /// The color of the subject.
  @YTColorConverter()
  YTColor color;

  Subject({
    required this.color,
    required this.id,
    required this.name,
    required this.classAverage,
    required this.maxAverage,
    required this.minAverage,
    required this.coefficient,
    required this.teachers,
    required this.average,
  });

  final IsarLinks<Grade> grades = IsarLinks<Grade>();
}
