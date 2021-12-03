part of school_api;

class SchoolAccount {
  final String firstName;
  final String lastName;
  String get fullName => '$firstName $lastName';
  final String className;
  final String id;
  final String profilePicture;

  const SchoolAccount(
      {required this.firstName,
      required this.lastName,
      required this.className,
      required this.id,
      required this.profilePicture});
}
