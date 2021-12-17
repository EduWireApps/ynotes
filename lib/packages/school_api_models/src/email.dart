part of models;

/// The model for an email.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.email)
class Email {
  /// The id of the email.
  @HiveField(0)
  final String id;

  /// Is the email read. Don't forget to update the [Email]
  /// in the [EmailsModule] if you change it.
  @HiveField(1)
  bool read;

  /// The email's sender.
  @HiveField(2)
  final Recipient from;

  /// The email's subject.
  @HiveField(3)
  final String subject;

  /// The date the e-mail was sent.
  @HiveField(4)
  final DateTime date;

  /// The email's content. By default when querying the emails' list
  /// from the api, it's likely to be null. You have to call the api
  /// again to get all emails' data. Don't forget to update the [Email]
  /// in the [EmailsModule].
  @HiveField(5)
  String? content;

  /// The email's documents ids, used to retrieve linked documents
  /// in [documents] from [DocumentsModule].
  @HiveField(6)
  final List<String> documentsIds;

  /// Get the email's documents from a list of [Document]s.
  List<Document> documents(List<Document> d) => d.where((document) => documentsIds.contains(document.id)).toList();

  /// The email's recipients.
  @HiveField(7)
  final List<Recipient> to;

  Email({
    required this.id,
    required this.read,
    required this.from,
    required this.subject,
    required this.date,
    this.content,
    this.documentsIds = const [],
    required this.to,
  });

  /// When sending an [Email], some data are useless and so
  /// this factory let's you create an [Email] with only the
  /// required data.
  factory Email.toSend(
          {required String subject,
          required String content,
          required List<Recipient> to,
          List<String> documentsIds = const []}) =>
      Email(
        id: "",
        read: false,
        from: Recipient(id: "", firstName: "", lastName: "", civility: "", headTeacher: false, subjects: []),
        subject: subject,
        content: content,
        date: DateTime.now(),
        to: to,
        documentsIds: documentsIds,
      );
}
