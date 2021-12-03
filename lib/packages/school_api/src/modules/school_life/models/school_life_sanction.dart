part of school_api;

@HiveType(typeId: 1)
class SchoolLifeSanction extends HiveObject {
  @HiveField(0)
  final String type; // typeElement
  @HiveField(1)
  final String registrationDate; // dateDeroulement
  @HiveField(2)
  final String reason; // motif
  @HiveField(3)
  final String by; // par
  @HiveField(4)
  final DateTime date; // date
  @HiveField(5)
  final String sanction; // libelle
  @HiveField(6)
  final String work; // aFaire

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
