part of models;

/// The model for a sanction (school life).
///
/// Can be stored in [Hive] storage.
@Collection()
class SchoolLifeSanction {
  @Id()
  int? id;

  /// The type of sanction. Depends of the API.
  final String type;

  /// The registration date of the sanction.
  /// TODO: check if could be renamed to date and [date] to entryDate. Not sure.
  final String registrationDate;

  /// The reason of the sanction.
  final String reason;

  /// The name of the person how gave the sanction.
  final String by;

  /// The date of the sanction.
  final DateTime date;

  /// What the sanction is.
  final String sanction;

  /// The work to do.
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
