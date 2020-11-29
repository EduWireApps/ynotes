import 'package:hive/hive.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/offline.dart';

class PollsOffline extends Offline {
  Future<List<PollInfo>> get() async {
    try {
      if (pollsData != null) {
        return pollsData;
      } else {
        await refreshData();
        return pollsData.cast<PollInfo>();
      }
    } catch (e) {
      print("Error while returning polls " + e.toString());
      return null;
    }
  }

  ///Update existing polls (clear old data) with passed data
  update(List<PollInfo> newData) async {
    print("Update offline polls (length : ${newData.length})");
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      await offlineBox.delete("polls");
      await offlineBox.put("polls", newData);
      await refreshData();
    } catch (e) {
      print("Error while updating polls " + e.toString());
    }
  }
}
