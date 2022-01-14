import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class RecipientsOffline {
  late Offline parent;
  RecipientsOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<Recipient>?> getRecipients() async {
    try {
      return parent.offlineBox?.get("recipients")?.cast<Recipient>();
    } catch (e) {
      Logger.log("MAILS", "An error occured while returning recipients");
      Logger.error(e, stackHint: "NDM=");
      return null;
    }
  }

  updateRecipients(List<Recipient> newData) async {
    try {
      var old = await getRecipients();
      for (var recipient in newData) {
        (old ?? []).removeWhere((a) => a.id == recipient.id);
      }

      await parent.offlineBox!.put("recipients", newData);
    } catch (e) {
      Logger.log("MAILS", "An error occured while updating recipients");
      Logger.error(e, stackHint: "NDQ=");
    }
  }
}
