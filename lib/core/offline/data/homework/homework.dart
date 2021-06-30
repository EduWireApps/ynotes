import 'package:calendar_time/calendar_time.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class HomeworkOffline {
  late Offline parent;
  HomeworkOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<Homework>?> getAllHomework() async {
    try {
      return (parent.homeworkBox?.values.toList().cast<Homework>());
    } catch (e) {
      print("Error while returning homework " + e.toString());
      return null;
    }
  }

  Future<List<Homework>?> getHomeworkFor(DateTime date) async {
    try {
      return (parent.homeworkBox?.values.toList().cast<Homework>())
          ?.where((element) => (CalendarTime(element.date).isSameDayAs(date)))
          .toList();
    } catch (e) {
      print("Error while returning homework " + e.toString());
      return null;
    }
  }

  ///Update existing appSys.offline.homework.get() with passed data
  ///if `add` boolean is set to true passed data is combined with old data
  updateHomework(List<Homework> newHomeworks) async {
    print("Update offline homwork");
    try {
      List<Homework>? oldHW = [];
      if (parent.homeworkBox?.values != null) {
        oldHW = parent.homeworkBox?.values.toList().cast<Homework>();
      }
      if (oldHW != null) {
        await Future.forEach(oldHW, (Homework oldHW) async {
          await Future.forEach(newHomeworks, (Homework newHW) async {
            if (newHW.id == oldHW.id) {
              //fields available unloaded
              oldHW.discipline = newHW.discipline;
              oldHW.disciplineCode = newHW.disciplineCode;
              oldHW.date = newHW.date;
              oldHW.isATest = newHW.isATest;
              oldHW.toReturn = newHW.toReturn;
              //update these fields only if loaded
              if (newHW.loaded ?? false) {
                oldHW.rawContent = newHW.rawContent;
                oldHW.teacherName = newHW.teacherName;
                oldHW.loaded = newHW.loaded;
              }
              oldHW.files = newHW.files;
              await oldHW.save();
            }
          });
        });
      }
      final old = (parent.homeworkBox?.values.toList().cast<Homework>())
          ?.where((oldHW) => newHomeworks.any((newHW) => newHW.id == oldHW.id));
      if (old != null) {
        newHomeworks
            .removeWhere((newHomework) => old.any((oldPieceOfHomework) => oldPieceOfHomework.id == newHomework.id));
        print(newHomeworks.length);
      }
      await parent.homeworkBox?.addAll(newHomeworks);
    } catch (e) {
      print("Error while updating homework " + e.toString());
    }
  }

  //Get all homework
  Future<void> updateSingleHW(Homework homework) async {
    await homework.save();
  }
}
