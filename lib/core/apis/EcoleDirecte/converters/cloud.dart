import 'package:ynotes/core/logic/modelsExporter.dart';

class EcoleDirecteCloudConverter {
  static List<CloudItem> cloudFolders(var cloudFoldersData) {
    List<CloudItem> cloudFolders = [];
    cloudFoldersData["data"].forEach((folderData) {
      String? date = folderData["creeLe"];
      try {
        if (date != null) {
          var split = date.split(" ");
          date = split[0];
        }
      } catch (e) {}
      String? title = folderData["titre"];
      String elementType = "FOLDER";
      String? author = folderData["creePar"];
      bool isRootDir = true;
      bool isMemberOf = folderData["estMembre"];
      String id = folderData["id"].toString();
      cloudFolders.add(CloudItem(
        title,
        elementType,
        author,
        isRootDir,
        date,
        isMemberOf: isMemberOf,
        id: id,
      ));
    });
    return cloudFolders;
  }
}
