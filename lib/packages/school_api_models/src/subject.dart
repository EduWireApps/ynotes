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
  double get average {
    double n = 0.0;
    for (final grade in grades) {
      n += grade.value;
    }
    return n;
  }

  @HiveField(5)
  final double coefficient;
  @HiveField(6)
  final String teachers;
  @HiveField(7)
  final HiveList<Grade> grades;
  @HiveField(8)
  final HiveList<Period> periods;

  Subject({
    required this.id,
    required this.name,
    required this.classAverage,
    required this.maxAverage,
    required this.minAverage,
    required this.coefficient,
    required this.teachers,
    required this.grades,
    required this.periods,
  });
}
