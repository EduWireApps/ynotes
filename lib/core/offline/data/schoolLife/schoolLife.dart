import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class SchoolLifeOffline {
  late Offline parent;
  SchoolLifeOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<SchoolLifeTicket>?> get() async {
    try {
      return parent.offlineBox?.get("recipients")?.cast<SchoolLifeTicket>();
    } catch (e) {
      print("Error while returning school life tickets " + e.toString());
      return null;
    }
  }

  ///Update existing polls (clear old data) with passed data
  update(List<SchoolLifeTicket>? newData) async {
    print("Update school life tickets (length : ${newData!.length})");
    try {
      await parent.offlineBox?.delete("schoolLife");
      await parent.offlineBox?.put("schoolLife", newData);
    } catch (e) {
      print("Error while updating school life tickets " + e.toString());
    }
  }
}
