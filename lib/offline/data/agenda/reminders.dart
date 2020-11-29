import 'package:hive/hive.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/offline.dart';

class RemindersOffline extends Offline {
  Future<List<AgendaReminder>> getReminders(String idLesson) async {
    try {
      if (remindersData != null) {
        return remindersData.where((element) => element.lessonID == idLesson).toList();
      } else {
        await refreshData();
        var toCollect = remindersData;
        if (toCollect != null) {
          toCollect = toCollect.where((element) => element.lessonID == idLesson).toList();
        }
        return toCollect;
      }
    } catch (e) {
      print("Error while returning agenda reminders " + e.toString());
      return null;
    }
  }

  ///Update existing reminders (clear old data) with passed data
  void updateReminders(AgendaReminder newData) async {
    print("Update reminders");
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      var old = await offlineBox.get("reminders");
      List<AgendaReminder> offline = List();
      if (old != null) {
        offline = old.cast<AgendaReminder>();
      }
      if (offline != null) {
        offline.removeWhere((a) => a.id == newData.id);
      }
      offline.add(newData);
      print(offline);
      await offlineBox.put("reminders", offline);
      await refreshData();
      print("Updated reminders");
    } catch (e) {
      print("Error while updating reminder " + e.toString());
    }
  }

  ///Remove all reminders associated with the give `lessonId`
  removeAll(String lessonId) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      var old = await offlineBox.get("reminders");
      List<AgendaReminder> offline = List();
      if (old != null) {
        offline = old.cast<AgendaReminder>();
      }
      if (offline != null) {
        offline.removeWhere((element) => element.lessonID == lessonId);
      }
      await offlineBox.put("reminders", offline);
      await refreshData();
    } catch (e) {
      print("Error while removing reminder " + e.toString());
    }
  }

  ///Remove a reminder with its `id`
  void remove(String id) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      var old = await offlineBox.get("reminders");
      List<AgendaReminder> offline = List();
      if (old != null) {
        offline = old.cast<AgendaReminder>();
      }
      if (offline != null) {
        offline.removeWhere((a) => a.id == id);
      }
      await offlineBox.put("reminders", offline);
      await refreshData();
    } catch (e) {
      print("Error while removing reminder " + e.toString());
    }
  }
}
