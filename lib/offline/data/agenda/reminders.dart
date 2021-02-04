import 'package:hive/hive.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/offline.dart';

class RemindersOffline extends Offline {
  RemindersOffline(bool locked) : super(locked);

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
    if (!locked) {
      print("Update reminders");
      try {
        if (!agendaBox.isOpen) {
          agendaBox = await Hive.openBox("agenda");
        }
        var old = await agendaBox.get("reminders");
        List<AgendaReminder> offline = List();
        if (old != null) {
          offline = old.cast<AgendaReminder>();
        }
        if (offline != null) {
          offline.removeWhere((a) => a.id == newData.id);
        }
        offline.add(newData);
        print(offline);
        await agendaBox.put("reminders", offline);
        await refreshData();
        print("Updated reminders");
      } catch (e) {
        print("Error while updating reminder " + e.toString());
      }
    }
  }

  ///Remove all reminders associated with the give `lessonId`
  removeAll(String lessonId) async {
    if (!locked) {
      try {
        if (!agendaBox.isOpen) {
          agendaBox = await Hive.openBox("agenda");
        }
        var old = await agendaBox.get("reminders");
        List<AgendaReminder> offline = List();
        if (old != null) {
          offline = old.cast<AgendaReminder>();
        }
        if (offline != null) {
          offline.removeWhere((element) => element.lessonID == lessonId);
        }
        await agendaBox.put("reminders", offline);
        await refreshData();
      } catch (e) {
        print("Error while removing reminder " + e.toString());
      }
    }
  }

  ///Remove a reminder with its `id`
  void remove(String id) async {
    if (!locked) {
      try {
        if (!agendaBox.isOpen) {
          agendaBox = await Hive.openBox("agenda");
        }
        var old = await agendaBox.get("reminders");
        List<AgendaReminder> offline = List();
        if (old != null) {
          offline = old.cast<AgendaReminder>();
        }
        if (offline != null) {
          offline.removeWhere((a) => a.id == id);
        }
        await agendaBox.put("reminders", offline);
        await refreshData();
      } catch (e) {
        print("Error while removing reminder " + e.toString());
      }
    }
  }
}
