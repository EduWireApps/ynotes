part of school_api;

@HiveType(typeId: 1)
class SchoolLifeSanction extends HiveObject {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String registrationDate;
  @HiveField(2)
  final String reason;
  @HiveField(3)
  final String by;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final String sanction;
  @HiveField(6)
  final String work;

  SchoolLifeSanction({
    required this.type,
    required this.registrationDate,
    required this.reason,
    required this.by,
    required this.date,
    required this.sanction,
    required this.work,
  });
}
