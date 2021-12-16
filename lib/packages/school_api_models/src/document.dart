part of models;

@HiveType(typeId: _HiveTypeIds.document)
class Document {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  // TODO: this is temporary
  Future<File> file() async => await FileAppUtil.getFilePath(name);
  Future<String> content() async => (await file()).readAsStringSync();
  @HiveField(3)
  bool saved;

  Document({required this.id, required this.name, required this.type, required this.saved});
}
