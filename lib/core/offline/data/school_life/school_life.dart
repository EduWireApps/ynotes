import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class SchoolLifeOffline {
  late Offline parent;
  SchoolLifeOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<SchoolLifeTicket>?> get() async {
    try {
      return parent.offlineBox?.get("schoolLife")?.cast<SchoolLifeTicket>();
    } catch (e) {
      CustomLogger.log("SCHOOL LIFE", "An error occured while returning tickets");
      CustomLogger.error(e, stackHint:"NjE=");
      return null;
    }
  }

  ///Update existing polls (clear old data) with passed data
  update(List<SchoolLifeTicket>? newData) async {
    CustomLogger.log("SCHOOL LIFE", "Update school life tickets (length : ${newData!.length})");
    try {
      await parent.offlineBox?.delete("schoolLife");
      await parent.offlineBox?.put("schoolLife", newData);
    } catch (e) {
      CustomLogger.log("SCHOOL LIFE", "An error occured while updating tickets");
      CustomLogger.error(e, stackHint:"NjI=");
    }
  }
}
