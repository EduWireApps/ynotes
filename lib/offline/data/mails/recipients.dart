import 'package:hive/hive.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/offline.dart';

class RecipientsOffline extends Offline {
  Offline parent;
  RecipientsOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }
  Future<List<Recipient>> getRecipients() async {
    try {
      if (parent.recipientsData != null) {
        return parent.recipientsData;
      } else {
        await parent.refreshData();
        return parent.recipientsData.cast<Recipient>();
      }
    } catch (e) {
      print("Error while returning recipients " + e.toString());
      return null;
    }
  }

  updateRecipients(List<Recipient> newData) async {
    try {
      /*if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }*/
      var old = await parent.offlineBox.get("recipients");
      newData.forEach((recipient) {
        old.removeWhere((a) => a.id == recipient.id);
      });

      await parent.offlineBox.put("recipients", newData);
      await parent.refreshData();
    } catch (e) {
      print("Error while updating recipients " + e.toString());
    }
  }
}
