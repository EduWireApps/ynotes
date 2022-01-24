part of models;

/// The model for a ticket (school life).
///
/// Can be stored in [Hive] storage.
@Collection()
class SchoolLifeTicket {
  @Id()
  int? id;

  /// The duration of the ticket.
  final String duration;

  /// The date displayed on the ticket.
  final String displayDate;

  /// The reason of the ticket.
  final String reason;

  /// The type of the ticket.
  final String type;

  /// Is the ticket justified.
  final bool isJustified;

  /// The date of the ticket.
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
