import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class RecipientsOffline {
  late Offline parent;
  RecipientsOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<Recipient>?> getRecipients() async {
    try {
      return parent.offlineBox?.get("recipients")?.cast<Recipient>();
    } catch (e) {
      print("Error while returning recipients " + e.toString());
      return null;
    }
  }

  updateRecipients(List<Recipient> newData) async {
    try {
      var old = await getRecipients();
      newData.forEach((recipient) {
        (old ?? []).removeWhere((a) => a.id == recipient.id);
      });

      await parent.offlineBox!.put("recipients", newData);
    } catch (e) {
      print("Error while updating recipients " + e.toString());
    }
  }
}
