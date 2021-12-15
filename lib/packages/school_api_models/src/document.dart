part of models;

@HiveType(typeId: _HiveTypeIds.document)
class Document {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  File get file => File(name);
  String get content => file.readAsStringSync();
  @HiveField(3)
  bool saved;

  Document({required this.id, required this.name, required this.type, required this.saved});
}
