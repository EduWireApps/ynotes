import 'package:ynotes/core/logic/modelsExporter.dart';

class PronoteDocumentConverter {
  static documents(var filesData) {
    List<Document> documents = List();
    filesData.forEach((document) {
      String documentName = document["L"];
      String id = document["N"];
      String type = document["G"];
      int length;
      documents.add(Document(documentName,id,type,length));
    });
  }
}
