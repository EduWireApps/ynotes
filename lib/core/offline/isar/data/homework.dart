import 'package:isar/isar.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/isar.g.dart';

class OfflineHomework {
  final Isar isarInstance;
  OfflineHomework(this.isarInstance);

  Future<List<Homework>?> getAllHomework() async {
    return await isarInstance.homeworks.where().findAll();
  }
  
  Future<List<Homework>?> getHomeworkFor(DateTime date) async {
    return await isarInstance.homeworks.where().filter().dateEqualTo(date).findAll();
  }

  Future<void> updateDoneStatus(Homework homework) async {
    await isarInstance.writeTxn((isar) async {
      // await isar.mails.where().deleteAll();
      //We get all homework we want to update
      Homework? oldHomework = await isarInstance.homeworks.where().filter().idEqualTo(homework.id).findFirst();
      if (oldHomework != null) {
        oldHomework.done = homework.done;
      } else {
        oldHomework = homework;
      }
      await isar.homeworks.put(oldHomework);
    });
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
            if (newHW.editable) {
              oldHW.rawContent = newHW.rawContent;
              oldHW.discipline = newHW.discipline;
              oldHW.disciplineCode = newHW.disciplineCode;
              oldHW.date = newHW.date;
            }
            await oldHW.files.load();
            oldHW.files.clear();
            oldHW.files.addAll(newHW.files);
            await oldHW.files.saveChanges();
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
      await isar.homeworks.putAll(old);

      //we put the old mails
      //no need to remove the old ones (Isar will automatically update them)
      await isar.homeworks.putAll(newHomeworks);
    });
  }
}
