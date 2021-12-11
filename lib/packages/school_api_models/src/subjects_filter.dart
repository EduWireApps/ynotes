part of models;

@HiveType(typeId: _HiveTypeIds.subjectsFilter)
class SubjectsFilter extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final YTColor color;
  @HiveField(2)
  final HiveList<Subject> subjects;
  @HiveField(3)
  final bool custom;

  SubjectsFilter({required this.name, required this.color, required this.subjects, required this.custom});
}
