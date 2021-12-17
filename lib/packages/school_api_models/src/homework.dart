part of models;

@HiveType(typeId: _HiveTypeIds.homework)
class Homework extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String subjectId;
  Subject subject(List<Subject> subjects) => subjects.firstWhere((subject) => subject.id == subjectId);
  @HiveField(2)
  String? content;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final DateTime entryDate;
  @HiveField(5)
  bool done;
  @HiveField(6)
  final bool due;
  @HiveField(7)
  final bool assessment;
  @HiveField(8)
  bool pinned;
  @HiveField(9)
  List<Document> documents;

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
    this.documents = const [],
  });
}
