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
  final List<Document> documents;
  @HiveField(7)
  final List<Recipient> to;

  Email({
    required this.id,
    required this.read,
    required this.from,
    required this.subject,
    required this.date,
    this.content,
    this.documents = const [],
    required this.to,
  });

  factory Email.toSend(
          {required String subject,
          required String content,
          required List<Recipient> to,
          List<Document> documents = const []}) =>
      Email(
        id: "",
        read: false,
        from: Recipient(id: "", firstName: "", lastName: "", civility: "", headTeacher: false, subjects: []),
        subject: subject,
        content: content,
        date: DateTime.now(),
        to: to,
        documents: documents,
      );
}
