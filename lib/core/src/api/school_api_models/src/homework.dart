part of models;

/// The model for an homework.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.homework)
class Homework {
  /// The id of the homework.
  @HiveField(0)
  final String id;

  /// The subject's id.
  @HiveField(1)
  final String subjectId;

  /// Get the corresponding subject.
  Subject subject(List<Subject> subjects) => subjects.firstWhere((subject) => subject.id == subjectId);

  /// The homework's content. By default when querying the homework' list
  /// from the api, it's likely to be null. You have to call the api
  /// again to get all emails' data. Don't forget to update the [Homework]
  /// in the [HomeworkModule].
  @HiveField(2)
  String? content;

  /// The date of the homework.
  @HiveField(3)
  final DateTime date;

  /// The date of entry by the teacher.
  @HiveField(4)
  final DateTime entryDate;

  /// Is the homework done. Don't forget to update it in the [HomeworkModule].
  @HiveField(5)
  bool done;

  /// Does the homework requires an answer through the api.
  @HiveField(6)
  final bool due;

  /// Is the homework an assessment.
  @HiveField(7)
  final bool assessment;

  /// Is the homework pinned.
  @HiveField(8)
  bool pinned;

  /// The homework's documents ids, used to retrieve linked documents
  /// in [documents] from [DocumentsModule].
  @HiveField(9)
  List<String> documentsIds;

  /// Get the homework's documents from a list of [Document]s.
  List<Document> documents(List<Document> d) => d.where((document) => documentsIds.contains(document.id)).toList();

  Homework({
    required this.id,
    required this.subjectId,
    required this.content,
    required this.date,
    required this.entryDate,
    required this.done,
    required this.due,
    required this.assessment,
    this.pinned = false,
    this.documentsIds = const [],
  });
}
