import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class RecipientsOffline extends Offline {
  RecipientsOffline(bool locked) : super(locked);

  Future<List<Recipient>> getRecipients() async {
    try {
      if (recipientsData != null) {
        return recipientsData;
      } else {
        await refreshData();
        return recipientsData.cast<Recipient>();
      }
    } catch (e) {
      print("Error while returning recipients " + e.toString());
      return null;
    }
  }

  updateRecipients(List<Recipient> newData) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      var old = await offlineBox.get("recipients");
      newData.forEach((recipient) {
        old.removeWhere((a) => a.id == recipient.id);
      });

      await offlineBox.put("recipients", newData);
      await refreshData();
    } catch (e) {
      print("Error while updating recipients " + e.toString());
    }
  }
}
