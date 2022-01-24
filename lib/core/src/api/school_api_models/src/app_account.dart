part of models;

/// The model for the app account. This account is not used
/// to retrieve data, but if [accounts] is empty, a [SchoolAccount]
/// will be generated from it instead.
///
/// Can be stored in [Hive] storage.
@Collection()
class AppAccount {
  @Id()
  int? id;

  final String entityId;

  /// The first name of the user.
  final String firstName;

  /// The last name of the user.
  final String lastName;

  /// The full name of the user, computed from [firstName] and [lastName].
  String get fullName => '$firstName $lastName';

  /// Is the account a parent or not. Based on [accounts]' length.
  bool get isParent => accounts.isNotEmpty;

  /// The sub accounts, usually the children of the parent.
  final IsarLinks<SchoolAccount> accounts = IsarLinks<SchoolAccount>();

  AppAccount({required this.entityId, required this.firstName, required this.lastName});
}
