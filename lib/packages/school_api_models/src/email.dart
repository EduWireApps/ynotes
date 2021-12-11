part of models;

@HiveType(typeId: _HiveTypeIds.email)
class Email {
  @HiveField(0)
  final String id;
  @HiveField(1)
  bool read;
  @HiveField(2)
  final Recipient from;
  @HiveField(3)
  final String subject;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  String? content;
  @HiveField(6)
  final List<dynamic> files;
  @HiveField(7)
  final List<Recipient> to;

  Email({
    required this.id,
    required this.read,
    required this.from,
    required this.subject,
    required this.date,
    this.content,
    this.files = const [],
    required this.to,
  });
}
