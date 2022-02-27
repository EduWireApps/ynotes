part of models;

/// The model for a subject filter.
///
/// Can be stored in [Hive] storage.
@Collection()
class SubjectsFilter extends _LinkedModel {
  @Id()
  int? id;

  /// The name of the filter.
  String name;

  /// The id of the filter.
  late final String entityId;

  SubjectsFilter({
    required this.name,
    required this.entityId,
  });

  SubjectsFilter.fromName({required this.name}) : entityId = const Uuid().v4();

  final IsarLinks<Subject> subjects = IsarLinks<Subject>();

  @override
  void load() {
    Offline.isar.writeTxnSync((isar) {
      subjects.loadSync();
    });
    for (final subject in subjects) {
      subject.load();
    }
  }
}
