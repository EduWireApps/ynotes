part of models;

/// The model for a ticket (school life).
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.schoolLifeTicket)
class SchoolLifeTicket {
  /// The duration of the ticket.
  @HiveField(0)
  final String duration;

  /// The date displayed on the ticket.
  @HiveField(1)
  final String displayDate;

  /// The reason of the ticket.
  @HiveField(2)
  final String reason;

  /// The type of the ticket.
  @HiveField(3)
  final String type;

  /// Is the ticket justified.
  @HiveField(4)
  final bool isJustified;

  /// The date of the ticket.
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
