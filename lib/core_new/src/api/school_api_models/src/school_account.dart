part of models;

/// The model for the school account. This account is used to
/// retrive data.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.schoolAccount)
class SchoolAccount {
  /// The account's id.
  @HiveField(0)
  final String id;

  /// The first name of the user.
  @HiveField(1)
  final String firstName;

  /// The last name of the user.
  @HiveField(2)
  final String lastName;

  /// The full name of the user, computed from [firstName] and [lastName].
  String get fullName => '$firstName $lastName';

  /// The name of the user's class.
  @HiveField(3)
  final String className;

  /// The user's profile picture url.
  @HiveField(4)
  final String profilePicture;

  const SchoolAccount(
      {required this.firstName,
      required this.lastName,
      required this.className,
      required this.id,
      required this.profilePicture});
}
