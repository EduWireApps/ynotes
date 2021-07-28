
import 'package:ynotes/core/logic/models_exporter.dart';

class EcoleDirecteWorkspacesConverter {
  static List<Workspace> workspaces(var workspacesData) {
    List<Workspace> workspaces = [];
    workspacesData["data"].forEach((folderData) {
      String? date = folderData["creeLe"];
      try {
        if (date != null) {
          var split = date.split(" ");
          date = split[0];
        }
      } catch (e) {}
      String? title = folderData["titre"];
      String? author = folderData["creePar"];
      bool isMemberOf = folderData["estMembre"];
      String id = folderData["id"].toString();
      workspaces.add(Workspace(
        title: title,
        author: author,
        id: id,
        isMemberOf: isMemberOf,
      ));
    });
    return workspaces;
  }
}
