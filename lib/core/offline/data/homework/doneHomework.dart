import 'package:ynotes/core/offline/offline.dart';

class DoneHomeworkOffline extends Offline {
  late Offline parent;
  DoneHomeworkOffline(bool locked, Offline _parent) : super(locked) {
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
      print("Error during the getHomeworkDoneProcess $e");
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
      print("Error during the getHomeworkDoneProcess $e");

      return false;
    }
  }

  setHWCompletion(String? id, bool? state) async {
    if (!locked) {
      print("Setting done hw");
      try {
        await parent.homeworkDoneBox!.put(id.toString(), state);
      } catch (e) {
        print("Error during the setHomeworkDoneProcess $e");
      }
    }
  }
}
