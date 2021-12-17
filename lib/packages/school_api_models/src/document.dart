part of models;

@HiveType(typeId: _HiveTypeIds.document)
class Document extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  String get fileName => "${id}_$name";
  // TODO: this is temporary
  Future<File> file() async => File("${(await FolderAppUtil.getDirectory(downloads: true)).path}/$fileName");
  Future<String> content() async => (await file()).readAsStringSync();
  @HiveField(3)
  bool saved;

  Document({required this.id, required this.name, required this.type, required this.saved});
}
