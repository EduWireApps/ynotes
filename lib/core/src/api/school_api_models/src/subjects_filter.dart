part of new_models;


/// The model for a subject filter.
///
/// Can be stored in [Hive] storage.
@Collection()
class SubjectsFilter {
  /// The name of the filter.

  @Id()
  int? isarId;
  final String name;

  /// The subjects ids of the filter.

  final List<String>? subjectsIds;

  /// The id of the filter.

  late final String? id;

  SubjectsFilter({
    required this.name,
    required this.subjectsIds,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// The subjects of the filter, from [subjectsIds].
  List<Subject> subjects(List<Subject> s) =>
      subjectsIds == null ? s : s.where((subject) => subjectsIds!.contains(subject.id)).toList();
}
