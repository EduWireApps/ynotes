import 'package:hive/hive.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/usefulMethods.dart';

class LessonsOffline extends Offline {
  LessonsOffline(bool locked) : super(locked);

  Future<List<Lesson>> get(int week) async {
    try {
      if (lessonsData != null && lessonsData[week] != null) {
        List<Lesson> lessons = List();
        lessons.addAll(lessonsData[week].cast<Lesson>());
        return lessons;
      } else {
        await refreshData();
        if (lessonsData[week] != null) {
          List<Lesson> lessons = List();
          lessons.addAll(lessonsData[week].cast<Lesson>());
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
        if (!agendaBox.isOpen) {
          agendaBox = await Hive.openBox("agenda");
        }
        if (newData != null) {
          print("Update offline lessons (week : $week, length : ${newData.length})");
          Map<dynamic, dynamic> timeTable = Map();
          var offline = await agendaBox.get("lessons");
          if (offline != null) {
            timeTable = Map<dynamic, dynamic>.from(await agendaBox.get("lessons"));
          }

          if (timeTable == null) {
            timeTable = Map();
          }

          int todayWeek = await get_week(DateTime.now());

          bool lighteningOverride = await getSetting("lighteningOverride");

          //Remove old lessons in order to lighten the db
          //Can be overriden in settings
          if (!lighteningOverride) {
            timeTable.removeWhere((key, value) {
              return ((key < todayWeek - 2) || key > todayWeek + 3);
            });
          }
          //Update the timetable
          timeTable.update(week, (value) => newData, ifAbsent: () => newData);
          await agendaBox.put("lessons", timeTable);
          await refreshData();
        }

        return true;
      } catch (e) {
        print("Error while updating offline lessons " + e.toString());
      }
    }
  }
}
