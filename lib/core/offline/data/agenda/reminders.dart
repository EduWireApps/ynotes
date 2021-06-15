import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class RemindersOffline {
  late Offline parent;
  RemindersOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<AgendaReminder>?> getReminders(String? idLesson) async {
    try {
      return parent.agendaBox
          ?.get("reminders")
          ?.where((element) => element.lessonID == idLesson)
          .toList()
          ?.cast<AgendaReminder>();
    } catch (e) {
      print("Error while returning agenda reminders " + e.toString());
      return null;
    }
  }

  ///Remove a reminder with its `id`
  void remove(String? id) async {
    try {
      var old = await parent.agendaBox?.get("reminders");
      List<AgendaReminder>? offline = [];
      if (old != null) {
        offline = old.cast<AgendaReminder>();
      }
      if (offline != null) {
        offline.removeWhere((a) => a.id == id);
      }
      await parent.agendaBox?.put("reminders", offline);
    } catch (e) {
      print("Error while removing reminder " + e.toString());
    }
  }

  ///Remove all reminders associated with the give `lessonId`
  removeAll(String? lessonId) async {
    try {
      var old = await parent.agendaBox?.get("reminders");
      List<AgendaReminder>? offline = [];
      if (old != null) {
        offline = old.cast<AgendaReminder>();
      }
      if (offline != null) {
        offline.removeWhere((element) => element.lessonID == lessonId);
      }
      await parent.agendaBox?.put("reminders", offline);
    } catch (e) {
      print("Error while removing reminder " + e.toString());
    }
  }

  ///Update existing reminders (clear old data) with passed data
  void updateReminders(AgendaReminder newData) async {
    try {
      var old = await parent.agendaBox?.get("reminders");
      List<AgendaReminder>? offline = [];
      if (old != null) {
        offline.addAll(old.cast<AgendaReminder>());
      }
      offline.removeWhere((a) => a.id == newData.id);
      offline.add(newData);
      await parent.agendaBox?.put("reminders", offline);

      print("Updated reminders");
    } catch (e) {
      print("Error while updating reminder " + e.toString());
    }
  }
}
