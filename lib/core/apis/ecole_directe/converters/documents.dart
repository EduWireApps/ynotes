import 'package:ynotes/core/logic/models_exporter.dart';

class EcoleDirecteDocumentConverter {
  static List<Document> documents(var filesData) {
    List<Document> documents = [];
    filesData.forEach((fileData) {
      String libelle = fileData["libelle"];
      String id = fileData["id"].toString();
      String type = fileData["type"];

      ///TO DO : replace length
      int length = 0;
      documents.add(Document(documentName: libelle, id: id, type: type, length: length));
    });
    return documents;
  }
}
