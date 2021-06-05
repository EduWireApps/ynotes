import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class HomeworkOffline {
  late Offline parent;
  HomeworkOffline(bool locked, Offline _parent) {
    parent = _parent;
  }

  Future<List<Homework>?> getHomework() async {
    try {
      return await parent.offlineBox?.get("homework")?.cast<Discipline>();
    } catch (e) {
      print("Error while returning homework " + e.toString());
      return null;
    }
  }

  //Get all homework
  ///Update existing appSys.offline.homework.get() with passed data
  ///if `add` boolean is set to true passed data is combined with old data
  updateHomework(List<Homework>? newData, {bool add = false, forceAdd = false}) async {
    print("Update offline homwork");
    try {
      if (add == true && newData != null) {
        List<Homework>? oldHW = [];
        if (parent.offlineBox?.get("homework") != null) {
          oldHW = parent.offlineBox?.get("homework")?.cast<Homework>();
        }

        List<Homework> combinedList = [];
        combinedList.addAll(oldHW!);
        newData.forEach((newdataelement) {
          if (forceAdd) {
            combinedList.removeWhere((element) => element.id == newdataelement.id);
            combinedList.add(newdataelement);
          } else {
            if (!combinedList
                .any((clistelement) => clistelement.id == newdataelement.id && !(clistelement.loaded ?? false))) {
              combinedList.add(newdataelement);
            }
          }
        });
        combinedList = combinedList.toSet().toList();
        await parent.offlineBox?.put("homework", combinedList);
      } else {
        await parent.offlineBox?.put("homework", newData);
      }
    } catch (e) {
      print("Error while updating homework " + e.toString());
    }
  }
}
