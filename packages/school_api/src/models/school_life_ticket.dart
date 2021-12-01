part of school_api;

class SchoolLifeTicket {
  final String duration;
  final String date;
  final String reason;
  final String type;
  final bool isJustified;

  const SchoolLifeTicket({
    required this.duration,
    required this.date,
    required this.reason,
    required this.type,
    required this.isJustified,
  });
}
