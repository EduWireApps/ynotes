part of school_api;

class SchoolLifeTicket {
  final String duration;
  final String displayDate;
  final String reason;
  final String type;
  final bool isJustified;
  final DateTime date;

  const SchoolLifeTicket({
    required this.duration,
    required this.displayDate,
    required this.reason,
    required this.type,
    required this.isJustified,
    required this.date,
  });
}
