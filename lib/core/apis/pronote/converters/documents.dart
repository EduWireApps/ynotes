import 'package:ynotes/core/logic/models_exporter.dart';

class PronoteDocumentConverter {
  static documents(var filesData) {
    List<Document> documents = [];
    filesData?.forEach((document) {
      String documentName = document["L"].toString();
      String id = document["N"].toString();
      String type = document["G"].toString();
      int? length;
      documents.add(Document(documentName: documentName, id: id, type: type, length: length));
    });
    return documents;
  }
}
