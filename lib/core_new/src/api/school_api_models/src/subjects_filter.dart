part of models;

/// The model for a subject filter.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.subjectsFilter)
class SubjectsFilter {
  /// The name of the filter.
  @HiveField(0)
  final String name;

  /// The subjects ids of the filter.
  @HiveField(2)
  final List<String>? subjectsIds;

  /// The id of the filter.
  @HiveField(4)
  final String id;

  /// The subjects of the filter, from [subjectsIds].
  List<Subject> subjects(List<Subject> s) =>
      subjectsIds == null ? s : s.where((subject) => subjectsIds!.contains(subject.id)).toList();

  SubjectsFilter({
    required this.name,
    required this.subjectsIds,
    String? id,
  }) : id = id ?? const Uuid().v4();
}
