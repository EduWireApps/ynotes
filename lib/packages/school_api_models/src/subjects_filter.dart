part of models;

/// The model for a subject filter.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.subjectsFilter)
class SubjectsFilter {
  /// The name of the filter.
  @HiveField(0)
  final String name;

  /// The color of the filter.
  @HiveField(1)
  final YTColor color;

  /// The subjects ids of the filter.
  @HiveField(2)
  final List<String>? subjectsIds;

  /// Is the filter custom.
  @HiveField(3)
  final bool custom;

  /// The id of the filter.
  @HiveField(4)
  final String id;

  /// The subjects of the filter, from [subjectsIds].
  List<Subject> subjects(List<Subject> s) =>
      subjectsIds == null ? s : s.where((subject) => subjectsIds!.contains(subject.id)).toList();

  SubjectsFilter(
      {required this.name, required this.color, required this.subjectsIds, required this.custom, required this.id});
}
