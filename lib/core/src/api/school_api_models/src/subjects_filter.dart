part of models;

/// The model for a subject filter.
///
/// Can be stored in [Hive] storage.
@Collection()
class SubjectsFilter {
  @Id()
  int? id;

  /// The name of the filter.
  final String name;

  /// The id of the filter.
  late final String? entityId;

  SubjectsFilter({
    required this.name,
    String? entityId,
  }) : entityId = entityId ?? const Uuid().v4();

  final IsarLinks<Subject> subjects = IsarLinks<Subject>();
}
