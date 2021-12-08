part of models;

@HiveType(typeId: _HiveTypeIds.subjectsFilter)
class SubjectsFilter extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final YTColor color;
  @HiveField(2)
  final List<String>? subjectsIds;
  @HiveField(3)
  final bool custom;
  @HiveField(4)
  final String id;
  List<Subject> subjects(List<Subject> s) =>
      subjectsIds == null ? s : s.where((subject) => subjectsIds!.contains(subject.id)).toList();

  SubjectsFilter(
      {required this.name, required this.color, required this.subjectsIds, required this.custom, required this.id});
}
