part of models;

@HiveType(typeId: _HiveTypeIds.email)
class Email {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final bool read;
  @HiveField(2)
  final String sender;
  @HiveField(3)
  final String subject;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final String? content;
  @HiveField(6)
  final List<dynamic> files;

  Email({
    required this.id,
    required this.read,
    required this.sender,
    required this.subject,
    required this.date,
    this.content,
    this.files = const [],
  });
}
