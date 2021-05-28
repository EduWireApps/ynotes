import 'package:calendar_time/calendar_time.dart';
import 'package:isar/isar.dart';
import 'package:ynotes/core/logic/appConfig/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/isar.g.dart';

class OfflineHomework {
  final Isar isarInstance;
  OfflineHomework(this.isarInstance);

  Future<List<Homework>?> getAllHomework() async {
    return await isarInstance.homeworks
        .where()
        .filter()
        .dateGreaterThan(CalendarTime(DateTime.now()).startOfDay)
        .or()
        .dateEqualTo(CalendarTime(DateTime.now()).startOfDay)
        .or()
        .pinnedEqualTo(true)
        .findAll();
  }

  Future<List<Homework>?> getHomeworkFor(DateTime date) async {
    return ((await isarInstance.homeworks.where().findAll()) ?? [])
        .where((Homework e) => CalendarTime(e.date).isSameDayAs(date))
        .toList();
  }

  ///Migrate from old done homework
  Future<void> migrateOldDoneHomeworkStatus(ApplicationSystem _appSys) async {
    if (_appSys.settings?["system"]["migratedHW"]) {
      List<String> temp = _appSys.offline.doneHomework.getAllDoneHomeworkIDs() ?? [];
      await isarInstance.writeTxn((isar) async {
        print(temp);
        List<Homework> hw =
            await isar.homeworks.where().filter().repeat(temp, (q, String element) => q.idEqualTo(element)).findAll();
        hw.forEach((element) {
          element.done = true;
        });
        await isar.homeworks.putAll(hw);
      });
      await _appSys.updateSetting(_appSys.settings?["system"], "migratedHW", true);
    } else {
      print("Already migrated");
    }
  }

  Future<void> updateHomework(List<Homework> newHomeworks) async {
    await isarInstance.writeTxn((isar) async {
      await Future.forEach(
          await isar.homeworks
              .where()
              .filter()
              .repeat(newHomeworks, (q, Homework _homework) => q.idEqualTo(_homework.id))
              .findAll(), (Homework oldHW) async {
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
            await oldHW.files.load();
            oldHW.files.clear();
            oldHW.files.addAll(newHW.files);
            await oldHW.files.saveChanges();
            await isar.homeworks.put(oldHW);
          }
        });
      });

      final old = await isar.homeworks
          .where()
          .filter()
          .repeat(newHomeworks, (q, Homework _homework) => q.idEqualTo(_homework.id))
          .findAll();
      newHomeworks
          .removeWhere((newHomework) => old.any((oldPieceOfHomework) => oldPieceOfHomework.id == newHomework.id));
      //we put the old mails
      //no need to remove the old ones (Isar will automatically update them)
      await isar.homeworks.putAll(newHomeworks);
    });
  }

  Future<void> updateSingleHW(Homework homework) async {
    await isarInstance.writeTxn((isar) async {
      await isar.homeworks.put(homework);
    });
  }
}
