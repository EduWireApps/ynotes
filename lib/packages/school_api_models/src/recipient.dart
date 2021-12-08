part of models;

@HiveType(typeId: _HiveTypeIds.recipient)
class Recipient {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
  String get fullName => '$civility $firstName $lastName';
  @HiveField(3)
  final String civility;
  @HiveField(4)
  final bool headTeacher;
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
