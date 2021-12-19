part of models;

/// The model for the school account. This account is used to
/// retrive data.
///
/// Can't be stored in [Hive] storage for now.
class SchoolAccount {
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

  const SchoolAccount(
      {required this.firstName,
      required this.lastName,
      required this.className,
      required this.id,
      required this.profilePicture});
}
