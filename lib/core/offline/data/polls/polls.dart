import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/loggingUtils.dart';

class PollsOffline {
  late Offline parent;
  PollsOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<PollInfo>?> get() async {
    try {
      return await parent.offlineBox?.get("polls")?.cast<PollInfo>();
    } catch (e) {
      CustomLogger.log("POLLS", "An error occured while returning polls");
      CustomLogger.error(e);
      return null;
    }
  }

  ///Update existing polls (clear old data) with passed data
  update(List<PollInfo>? newData) async {
    CustomLogger.log("POLLS", "Update offline polls (length : ${newData!.length})");
    try {
      await parent.offlineBox?.delete("polls");
      await parent.offlineBox?.put("polls", newData);
    } catch (e) {
      CustomLogger.log("POLLS", "An error occured while updating polls");
      CustomLogger.error(e);
    }
  }
}
