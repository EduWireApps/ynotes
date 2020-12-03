import 'package:hive/hive.dart';
import 'package:ynotes/offline/data/homework/homework.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/utils/fileUtils.dart';

class DoneHomeworkOffline extends Offline {
  setHWCompletion(String id, bool state) async {
    print("Setting done hw");
    try {
      if (homeworkDoneBox == null || !homeworkDoneBox.isOpen) {
        homeworkDoneBox = await Hive.openBox("doneHomework");
      }

      await homeworkDoneBox.put(id.toString(), state);
    } catch (e) {
      print("Error during the setHomeworkDoneProcess $e");
    }
  }

  Future<bool> getHWCompletion(String id) async {
    try {
      final dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offline");

      bool toReturn = homeworkDoneBox.get(id.toString());

      //If to return is null return false
      return (toReturn != null) ? toReturn : false;
    } catch (e) {
      print("Error during the getHomeworkDoneProcess $e");

      return false;
    }
  }
}
