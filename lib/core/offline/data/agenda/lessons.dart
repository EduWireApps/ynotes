import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/globals.dart';

class LessonsOffline extends Offline {
  late Offline parent;
  LessonsOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }

  Future<List<Lesson>?> get(int week) async {
    try {
      if (parent.lessonsData != null && parent.lessonsData![week] != null) {
        List<Lesson> lessons = [];

        lessons.addAll(parent.lessonsData![week].cast<Lesson>());

        return lessons;
      } else {
        print("refreshing");
        await parent.refreshData();
        if ((parent.lessonsData ?? {})[week] != null) {
          List<Lesson> lessons = [];
          lessons.addAll((parent.lessonsData ?? {})[week].cast<Lesson>());
          return lessons;
        } else {
          return null;
        }
      }
    } catch (e) {
      print("Error while returning lessons " + e.toString());
      return null;
    }
  }

  ///Update existing offline lessons with passed data, `week` is used to
  ///shorten fetching delays, it should ALWAYS be from a same starting point
  updateLessons(List<Lesson> newData, int week) async {
    if (!locked) {
      try {
        if (newData != null) {
          print("Update offline lessons (week : $week, length : ${newData.length})");
          Map<dynamic, dynamic> timeTable = Map();
          var offline = await parent.agendaBox?.get("lessons");
          if (offline != null) {
            timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox?.get("lessons"));
          }

          if (timeTable == null) {
            timeTable = Map();
          }

          int todayWeek = await getWeek(DateTime.now());

          bool lighteningOverride = appSys.settings!["user"]["agendaPage"]["lighteningOverride"];

          //Remove old lessons in order to lighten the db
          //Can be overriden in settings
          if (!lighteningOverride) {
            timeTable.removeWhere((key, value) {
              return ((key < todayWeek - 2) || key > todayWeek + 3);
            });
          }
          //timeTable[week] = [];
          //Update the timetable
          timeTable[week] = newData;

          await parent.agendaBox?.put("lessons", timeTable);
          await parent.refreshData();
        }

        return true;
      } catch (e) {
        print("Error while updating offline lessons " + e.toString());
      }
    }
  }
}
