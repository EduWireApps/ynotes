import 'package:calendar_time/calendar_time.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class HomeworkOffline {
  late Offline parent;
  HomeworkOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<Homework>?> getAllHomework() async {
    try {
      return (parent.homeworkBox?.values.toList().cast<Homework>());
    } catch (e) {
      CustomLogger.log("HOMEWORK", "An error occured while returning homework");
      CustomLogger.error(e, stackHint:"NTU=");
      return null;
    }
  }

  Future<List<Homework>?> getHomeworkFor(DateTime date) async {
    try {
      return (parent.homeworkBox?.values.toList().cast<Homework>())
          ?.where((element) => (CalendarTime(element.date).isSameDayAs(date)))
          .toList();
    } catch (e) {
      CustomLogger.log("HOMEWORK", "An error occured while returning homework");
      CustomLogger.error(e, stackHint:"NTY=");
      return null;
    }
  }

  ///Update existing appSys.offline.homework.get() with passed data
  ///if `add` boolean is set to true passed data is combined with old data
  updateHomework(List<Homework> newHomeworks) async {
    CustomLogger.log("HOMEWORK", "Update offline homework");
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
        CustomLogger.log("HOMEWORK", "New homework length: ${newHomeworks.length}");
      }
      await parent.homeworkBox?.addAll(newHomeworks);
    } catch (e) {
      CustomLogger.log("HOMEWORK", "An error occured while updating homework");
      CustomLogger.error(e, stackHint:"NTc=");
    }
  }

  //Get all homework
  Future<void> updateSingleHW(Homework homework) async {
    await homework.save();
  }
}
