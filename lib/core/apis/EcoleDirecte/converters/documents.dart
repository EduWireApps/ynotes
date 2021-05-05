import 'package:ynotes/core/logic/modelsExporter.dart';

class EcoleDirecteDocumentConverter {
  static List<Document> documents(var filesData) {
    List<Document> documents = [];
    filesData.forEach((fileData) {
      String libelle = fileData["libelle"];
      String id = fileData["id"].toString();
      String type = fileData["type"];

      ///TO DO : replace length
      int length = 0;
      documents.add(Document(libelle, id, type, length));
    });
    return documents;
  }
}
