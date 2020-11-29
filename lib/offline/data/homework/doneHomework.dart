import 'package:hive/hive.dart';
import 'package:ynotes/offline/data/homework/homework.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/utils/fileUtils.dart';
 class DoneHomeworkOffline extends Offline {
  setHWCompletion(String id, bool state) async {
    try {
      final dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offline");

      homeworkDoneBox.put(id.toString(), state);
    } catch (e) {
      print("Error during the setHomeworkDoneProcess $e");
    }
  }
}
