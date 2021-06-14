import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class PollsOffline {
  late Offline parent;
  PollsOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<PollInfo>?> get() async {
    try {
      return await parent.offlineBox?.get("polls")?.cast<PollInfo>();
    } catch (e) {
      print("Error while returning polls " + e.toString());
      return null;
    }
  }

  ///Update existing polls (clear old data) with passed data
  update(List<PollInfo>? newData) async {
    print("Update offline polls (length : ${newData!.length})");
    try {
      await parent.offlineBox?.delete("polls");
      await parent.offlineBox?.put("polls", newData);
    } catch (e) {
      print("Error while updating polls " + e.toString());
    }
  }
}
