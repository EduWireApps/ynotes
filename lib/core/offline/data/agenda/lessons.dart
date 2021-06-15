import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/globals.dart';

class LessonsOffline {
  late Offline parent;
  LessonsOffline(Offline _parent) {
    parent = _parent;
  }

  Future<List<Lesson>?> get(int week) async {
    try {
      return parent.agendaBox?.get("lessons")?[week]?.cast<Lesson>();
    } catch (e) {
      print("Error while returning lessons " + e.toString());
      return null;
    }
  }

  ///Update existing offline lessons with passed data, `week` is used to
  ///shorten fetching delays, it should ALWAYS be from a same starting point
  updateLessons(List<Lesson> newData, int week) async {
    try {
      print("Update offline lessons (week : $week, length : ${newData.length})");
      Map<dynamic, dynamic> timeTable = Map();
      var offline = await parent.agendaBox?.get("lessons");
      if (offline != null) {
        timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox?.get("lessons"));
      }
      int todayWeek = await getWeek(DateTime.now());
      bool lighteningOverride = appSys.settings?["user"]["agendaPage"]["lighteningOverride"] ?? false;
      //Remove old lessons in order to lighten the db
      //Can be overriden in settings
      if (!lighteningOverride) {
        timeTable.removeWhere((key, value) {
          return ((key < todayWeek - 2) || key > todayWeek + 3);
        });
      }
      timeTable[week] = newData;

      await parent.agendaBox?.put("lessons", timeTable);

      return true;
    } catch (e) {
      print("Error while updating offline lessons " + e.toString());
    }
  }
}
