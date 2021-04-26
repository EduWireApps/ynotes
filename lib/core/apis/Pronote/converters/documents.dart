import 'package:ynotes/core/logic/modelsExporter.dart';

class PronoteDocumentConverter {
  static documents(var filesData) {
    List<Document> documents = [];
    filesData?.forEach((document) {
      String documentName = document["L"].toString();
      String id = document["N"].toString();
      String type = document["G"].toString();
      int? length;
      documents.add(Document(documentName, id, type, length));
    });
    return documents;
  }
}
