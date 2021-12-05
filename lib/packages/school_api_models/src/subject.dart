part of models;

@HiveType(typeId: _HiveTypeIds.subject)
class Subject extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double classAverage;
  @HiveField(3)
  final double maxAverage;
  @HiveField(4)
  final double minAverage;
  double get average => api.gradesModule.calculateAverageFromGrades(grades);
  @HiveField(5)
  final double coefficient;
  @HiveField(6)
  final String teachers;
  @HiveField(7)
  final HiveList<Grade> grades;
  @HiveField(8)
  final HiveList<Period> periods;

  @protected
  @HiveField(9)
  final SchoolApi api;

  Subject(
      {required this.id,
      required this.name,
      required this.classAverage,
      required this.maxAverage,
      required this.minAverage,
      required this.coefficient,
      required this.teachers,
      required this.grades,
      required this.periods,
      required this.api});
}

class CustomSubject extends Subject {
  CustomSubject(
      {required String name,
      required double coefficient,
      String teachers = "Pas de professeurs",
      required HiveList<Grade> grades,
      required HiveList<Period> periods,
      required SchoolApi api})
      : super(
            id: md5.convert(utf8.encode(name)).toString(),
            name: name,
            classAverage: double.nan,
            maxAverage: double.nan,
            minAverage: double.nan,
            coefficient: coefficient,
            teachers: teachers,
            grades: grades,
            periods: periods,
            api: api);
}
