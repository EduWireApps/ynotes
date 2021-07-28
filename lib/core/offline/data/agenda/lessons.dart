import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
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
      CustomLogger.log("LESSONS", "An error occurred while returning lessons");
      CustomLogger.error(e);
      return null;
    }
  }

  ///Update existing offline lessons with passed data, `week` is used to
  ///shorten fetching delays, it should ALWAYS be from a same starting point
  updateLessons(List<Lesson> newData, int week) async {
    try {
      CustomLogger.log("LESSONS", "Update offline lessons (week : $week, length : ${newData.length})");
      Map<dynamic, dynamic> timeTable = Map();
      var offline = await parent.agendaBox?.get("lessons");
      if (offline != null) {
        timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox?.get("lessons"));
      }
      int todayWeek = await getWeek(DateTime.now());
      bool lighteningOverride = appSys.settings.user.agendaPage.lighteningOverride;

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
      CustomLogger.log("LESSONS", "An error occurred while updating offline lessons");
      CustomLogger.error(e);
    }
  }
}
