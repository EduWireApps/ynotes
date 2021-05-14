import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class SchoolLifeOffline extends Offline {
  late Offline parent;
  SchoolLifeOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }
  Future<List<SchoolLifeTicket>?> get() async {
    try {
      if (parent.schoolLifeData != null) {
        return parent.schoolLifeData;
      } else {
        await refreshData();
        return (parent.schoolLifeData ?? []).cast<SchoolLifeTicket>();
      }
    } catch (e) {
      print("Error while returning school life tickets " + e.toString());
      return null;
    }
  }

  ///Update existing polls (clear old data) with passed data
  update(List<SchoolLifeTicket>? newData) async {
    if (!locked) {
      print("Update school life tickets (length : ${newData!.length})");
      try {
        await parent.offlineBox!.delete("schoolLife");
        await parent.offlineBox!.put("schoolLife", newData);
        await parent.refreshData();
      } catch (e) {
        print("Error while updating school life tickets " + e.toString());
      }
    }
  }
}
