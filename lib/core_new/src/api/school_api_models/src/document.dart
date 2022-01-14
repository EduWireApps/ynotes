part of models;

/// The model for a document. It's actually a file from a [SchoolApi]
/// but not named [File] since it's already part of `dart:io`.
///
/// Can be stored in [Hive] storage.
@HiveType(typeId: _HiveTypeIds.document)
class Document {
  /// The id of the document.
  @HiveField(0)
  final String id;

  /// The name of the document. Contains the file extension.
  @HiveField(1)
  final String name;

  /// The type of the document, which is not file type like `application/json`
  /// but internal api types such as `FICHIER_CDT`.
  @HiveField(2)
  final String type;

  /// The filename of the document, computed from [id] and [name].
  /// Used to store it locally and avoid any overrides.
  String get fileName => "${id}_$name";

  /// The [File] from app's directory and [fileName].
  Future<File> file() async {
    final Directory dir = await FileStorage.getAppDirectory(downloads: true);
    return File("${dir.path}/$fileName");
  }

  /// Is the file saved locally. Used to avoid useless downloads, even if
  /// it can be forced.
  @HiveField(3)
  bool saved;

  Document({required this.id, required this.name, required this.type, required this.saved});
}
