part of models;

/// The model for an homework.
///
/// Can be stored in [Hive] storage.
@Collection()
class Homework {
  @Id()
  int? id;

  /// The id of the homework.
  final String entityId;

  final IsarLink<Subject> subject = IsarLink<Subject>();

  /// The homework's content. By default when querying the homework' list
  /// from the api, it's likely to be null. You have to call the api
  /// again to get all emails' data. Don't forget to update the [Homework]
  /// in the [HomeworkModule].
  String? content;

  /// The date of the homework.
  final DateTime date;

  /// The date of entry by the teacher.
  final DateTime entryDate;

  /// Is the homework done. Don't forget to update it in the [HomeworkModule].
  bool done;

  /// Does the homework requires an answer through the api.
  final bool due;

  /// Is the homework an assessment.
  final bool assessment;

  /// Is the homework pinned.
  bool pinned;

  final IsarLinks<Document> documents = IsarLinks<Document>();

  Homework({
    required this.entityId,
    required this.content,
    required this.date,
    required this.entryDate,
    required this.done,
    required this.due,
    required this.assessment,
    this.pinned = false,
  });
}
