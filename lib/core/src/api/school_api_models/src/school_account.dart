part of models;

/// The model for the school account. This account is used to
/// retrive data.
///
/// Can be stored in [Hive] storage.
@Collection()
class SchoolAccount {
  @Id()
  int? isarId;

  /// The account's id.
  final String id;

  /// The first name of the user.
  final String firstName;

  /// The last name of the user.
  final String lastName;

  /// The full name of the user, computed from [firstName] and [lastName].
  String get fullName => '$firstName $lastName';

  /// The name of the user's class.
  final String className;

  /// The user's profile picture url.
  final String profilePicture;

  /// The user's school.
  final String school;

  SchoolAccount(
      {required this.firstName,
      required this.lastName,
      required this.className,
      required this.id,
      required this.profilePicture,
      required this.school});
}
