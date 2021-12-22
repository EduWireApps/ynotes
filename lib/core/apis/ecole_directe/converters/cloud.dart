import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class EcoleDirecteCloudConverter {
  static API_TYPE apiType = API_TYPE.ecoleDirecte;

  static YConverter cloudFolders = YConverter(
      apiType: apiType,
      converter: (Map<dynamic, dynamic> cloudFoldersData) {
        List<CloudItem> cloudFolders = [];
        cloudFoldersData["data"].forEach((folderData) {
          String? date = folderData["creeLe"];
          try {
            if (date != null) {
              var split = date.split(" ");
              date = split[0];
            }
          } catch (e) {
            CustomLogger.error(e, stackHint:"MjM=");
          }
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
      });
}
