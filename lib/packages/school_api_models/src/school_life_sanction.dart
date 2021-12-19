part of models;

/// The model for a sanction (school life).
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.schoolLifeSanction)
class SchoolLifeSanction {
  /// The type of sanction. Depends of the API.
  @HiveField(0)
  final String type;

  /// The registration date of the sanction.
  /// TODO: check if could be renamed to date and
  /// [date] to entryDate. Not sure.
  @HiveField(1)
  final String registrationDate;

  /// The reason of the sanction.
  @HiveField(2)
  final String reason;

  /// The name of the person how gave the sanction.
  @HiveField(3)
  final String by;

  /// The date of the sanction.
  @HiveField(4)
  final DateTime date;

  /// What the sanction is.
  @HiveField(5)
  final String sanction;

  /// The work to do.
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
