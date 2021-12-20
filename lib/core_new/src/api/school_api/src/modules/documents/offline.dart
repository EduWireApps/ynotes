part of school_api;

class OfflineDocuments extends OfflineModel {
  OfflineDocuments() : super('documents');

  static const String _documentsKey = 'documents';

  Future<List<Document>> getDocuments() async {
    return (box?.get(_documentsKey) as List<dynamic>?)?.map<Document>((e) => e).toList() ?? [];
  }

  Future<List<Document>> setDocuments(List<Document> documents) async {
    await box?.put(_documentsKey, documents);
    return await getDocuments();
  }
}
