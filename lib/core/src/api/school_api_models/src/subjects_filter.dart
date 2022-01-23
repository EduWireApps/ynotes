part of models;

/// The model for a subject filter.
///
/// Can be stored in [Hive] storage.
@Collection()
class SubjectsFilter {
  @Id()
  int? isarId;

  /// The name of the filter.
  final String name;

  /// The id of the filter.
  late final String? id;

  SubjectsFilter({
    required this.name,
    String? id,
  }) : id = id ?? const Uuid().v4();

  final IsarLinks<Subject> subjects = IsarLinks<Subject>();
}
