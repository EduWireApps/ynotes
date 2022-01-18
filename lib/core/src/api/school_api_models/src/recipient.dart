part of models;

/// The model for an email recipient.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.recipient)
class Recipient {
  /// The id of the recipient.
  @HiveField(0)
  final String id;

  /// The first name of the recipient.
  @HiveField(1)
  final String firstName;

  /// The last name of the recipient.
  @HiveField(2)
  final String lastName;

  /// The full name of the recipient, computed from [civility], [firstName] and [lastName].
  String get fullName => '$civility $firstName $lastName';

  /// The civility of the recipient.
  @HiveField(3)
  final String civility;

  /// Is the recipient a head teacher.
  @HiveField(4)
  final bool headTeacher;

  /// The teacher's subjects.
  @HiveField(5)
  final List<String> subjects;

  Recipient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.civility,
    required this.headTeacher,
    required this.subjects,
  });
}
