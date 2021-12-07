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
  @HiveField(5)
  final double coefficient;
  @HiveField(6)
  final String teachers;
  List<Grade> grades(List<Grade> grades, [Period? period]) =>
      grades.where((g) => g.subjectId == id && (period == null ? true : g.periodId == period.id)).toList();
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
