import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/globals.dart';

class RemindersOffline extends Offline {
  late Offline parent;
  RemindersOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }
  Future<List<AgendaReminder>?> getReminders(String? idLesson) async {
    try {
      if (parent.remindersData != null) {
        return parent.remindersData!.where((element) => element.lessonID == idLesson).toList();
      } else {
        await parent.refreshData();
        var toCollect = parent.remindersData;
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
        var old = await parent.agendaBox.get("reminders");
        List<AgendaReminder>? offline = [];
        if (old != null) {
          offline = old.cast<AgendaReminder>();
        }
        if (offline != null) {
          offline.removeWhere((a) => a.id == newData.id);
        }
        offline!.add(newData);
        await parent.agendaBox.put("reminders", offline);
        await parent.refreshData();
        print("Updated reminders");
      } catch (e) {
        print("Error while updating reminder " + e.toString());
      }
    }
  }

  ///Remove all reminders associated with the give `lessonId`
  removeAll(String? lessonId) async {
    if (!locked) {
      try {
        var old = await parent.agendaBox.get("reminders");
        List<AgendaReminder>? offline = [];
        if (old != null) {
          offline = old.cast<AgendaReminder>();
        }
        if (offline != null) {
          offline.removeWhere((element) => element.lessonID == lessonId);
        }
        await parent.agendaBox.put("reminders", offline);
        await parent.refreshData();
      } catch (e) {
        print("Error while removing reminder " + e.toString());
      }
    }
  }

  ///Remove a reminder with its `id`
  void remove(String? id) async {
    if (!locked) {
      try {
        var old = await parent.agendaBox.get("reminders");
        List<AgendaReminder>? offline = [];
        if (old != null) {
          offline = old.cast<AgendaReminder>();
        }
        if (offline != null) {
          offline.removeWhere((a) => a.id == id);
        }
        await parent.agendaBox.put("reminders", offline);
        await parent.refreshData();
      } catch (e) {
        print("Error while removing reminder " + e.toString());
      }
    }
  }
}
