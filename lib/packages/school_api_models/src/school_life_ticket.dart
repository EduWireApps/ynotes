part of models;

@HiveType(typeId: _HiveTypeIds.schoolLifeTicket)
class SchoolLifeTicket {
  @HiveField(0)
  final String duration;
  @HiveField(1)
  final String displayDate;
  @HiveField(2)
  final String reason;
  @HiveField(3)
  final String type;
  @HiveField(4)
  final bool isJustified;
  @HiveField(5)
  final DateTime date;

  SchoolLifeTicket({
    required this.duration,
    required this.displayDate,
    required this.reason,
    required this.type,
    required this.isJustified,
    required this.date,
  });
}
