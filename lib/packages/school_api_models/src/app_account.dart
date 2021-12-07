part of models;

class AppAccount {
  final String firstName;
  final String lastName;
  String get fullName => '$firstName $lastName';
  final String id;
  final bool isParent;
  final List<SchoolAccount> accounts;

  AppAccount({required this.firstName, required this.lastName, String? id, this.accounts = const []})
      : id = id ?? const Uuid().v4(),
        isParent = accounts.isNotEmpty;
}
