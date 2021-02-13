import 'package:hive/hive.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/offline.dart';

class PollsOffline extends Offline {
  Offline parent;
  PollsOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }
  Future<List<PollInfo>> get() async {
    try {
      if (pollsData != null) {
        return parent.pollsData;
      } else {
        await refreshData();
        return parent.pollsData.cast<PollInfo>();
      }
    } catch (e) {
      print("Error while returning polls " + e.toString());
      return null;
    }
  }

  ///Update existing polls (clear old data) with passed data
  update(List<PollInfo> newData) async {
    if (!locked) {
      print("Update offline polls (length : ${newData.length})");
      try {
        /* if (!offlineBox.isOpen) {
          offlineBox = await Hive.openBox("offlineData");
        }*/
        await parent.offlineBox.delete("polls");
        await parent.offlineBox.put("polls", newData);
        await parent.refreshData();
      } catch (e) {
        print("Error while updating polls " + e.toString());
      }
    }
  }
}
