part of models;

/// The model for an email recipient.
///
/// Can be stored in [Hive] storage.
@Collection()
class Recipient {
  @Id()
  int? isarId;

  /// The id of the recipient.
  final String id;

  /// The first name of the recipient.
  final String firstName;

  /// The last name of the recipient.
  final String lastName;

  /// The full name of the recipient, computed from [civility], [firstName] and [lastName].
  String get fullName => '$civility $firstName $lastName';

  /// The civility of the recipient.
  final String civility;

  /// Is the recipient a head teacher.
  final bool headTeacher;

  /// The teacher's subjects.
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
