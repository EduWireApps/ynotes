import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class DoneHomeworkOffline {
  late Offline parent;
  DoneHomeworkOffline(Offline _parent) {
    parent = _parent;
  }

  List<String>? getAllDoneHomeworkIDs() {
    List<String>? toReturn = parent.homeworkDoneBox
        ?.toMap()
        .entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList()
        .cast<String>();
    return toReturn;
  }

  Future<int> getDoneHWNumber() async {
    try {
      return parent.homeworkDoneBox!.keys.length;
    } catch (e) {
      CustomLogger.log("DONE HOMEWORK", "An error occured during the getHomeworkDoneProcess");
      CustomLogger.error(e, stackHint:"NjM=");
      return 0;
    }
  }

  Future<bool> getHWCompletion(String? id) async {
    try {
      /*Hive.init("${dir.path}/offline");
      if (homeworkDoneBox == null || !homeworkDoneBox.isOpen) {
        homeworkDoneBox = await Hive.openBox("doneHomework");
      }*/

      bool? toReturn = parent.homeworkDoneBox!.get(id.toString());

      //If to return is null return false
      return (toReturn != null) ? toReturn : false;
    } catch (e) {
      CustomLogger.log("DONE HOMEWORK", "An error occured during the getHomeworkDoneProcess");
      CustomLogger.error(e, stackHint:"NjQ=");
      return false;
    }
  }

  setHWCompletion(String? id, bool? state) async {
    CustomLogger.log("DONE HOMEWORK", "Setting homework state to $state");
    try {
      await parent.homeworkDoneBox!.put(id.toString(), state);
    } catch (e) {
      CustomLogger.log("DONE HOMEWORK", "An error occured during the setHomeworkDoneProcess");
      CustomLogger.error(e, stackHint:"NjU=");
    }
  }
}
