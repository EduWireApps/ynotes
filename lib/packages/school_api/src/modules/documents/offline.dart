part of school_api;

class OfflineDocuments extends OfflineModel {
  OfflineDocuments() : super('documents');

  static const String _documentsKey = 'documents';

  Future<List<Document>> getDocuments() async {
    return (box?.get(_documentsKey) as List<dynamic>?)?.map<Document>((e) => e).toList() ?? [];
  }

  Future<void> setDocument(List<Document> homework) async {
    await box?.put(_documentsKey, homework);
  }
}
