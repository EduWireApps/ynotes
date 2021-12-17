part of models;

/// The model for the app account. This account is not used
/// to retrieve data, but if [accounts] is empty, a [SchoolAccount]
/// will be generated from it instead.
///
/// Can't be stored in [Hive] storage for now.
class AppAccount {
  /// The account's id. If not provided, defaults to [Uuid.v4]
  final String id;

  /// The first name of the user.
  final String firstName;

  /// The last name of the user.
  final String lastName;

  /// The full name of the user, computed from [firstName] and [lastName].
  String get fullName => '$firstName $lastName';

  /// Is the account a parent or not. Based on [accounts]' length.
  bool get isParent => accounts.isNotEmpty;

  /// The sub accounts, usually the children of the parent.
  final List<SchoolAccount> accounts;

  AppAccount({required this.firstName, required this.lastName, String? id, this.accounts = const []})
      : id = id ?? const Uuid().v4();
}
