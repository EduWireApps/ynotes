part of models;

/// The model for an email.
///
/// Can be stored in [Hive] storage.
@Collection()
class Email {
  @Id()
  int? id;

  /// The id of the email.
  final String entityId;

  /// Is the email read. Don't forget to update the [Email]
  /// in the [EmailsModule] if you change it.
  bool read;

  /// The email's sender.
  final IsarLink<Recipient> from = IsarLink<Recipient>();

  /// The email's subject.
  final String subject;

  /// The date the e-mail was sent.
  final DateTime date;

  /// The email's content. By default when querying the emails' list
  /// from the api, it's likely to be null. You have to call the api
  /// again to get all emails' data. Don't forget to update the [Email]
  /// in the [EmailsModule].
  String? content;
  final IsarLinks<Document> documents = IsarLinks<Document>();

  /// The email's recipients.
  final IsarLinks<Recipient> to = IsarLinks<Recipient>();

  bool favorite = false;

  Email({
    required this.entityId,
    required this.read,
    required this.subject,
    required this.date,
    this.content,
  });

  /// When sending an [Email], some fields are useless and so
  /// this factory let's you create an [Email] with only the
  /// required data.
  factory Email.toSend({
    required String subject,
    required String content,
  }) =>
      Email(
        entityId: "",
        read: false,
        subject: subject,
        content: content,
        date: DateTime.now(),
      );
}
