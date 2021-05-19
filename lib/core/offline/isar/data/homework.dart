import 'package:isar/isar.dart';
import 'package:ynotes/core/offline/isar/test.dart';
import 'package:ynotes/isar.g.dart';

class OfflineHomework {
  final Isar isarInstance;
  OfflineHomework(this.isarInstance);

  void addHomework(List<Homework2> newHW) async {
    await isarInstance.txnSync((isar) async {
      List<int> ids = [];
      //Let's remove the old one
      await Future.forEach(newHW, (Homework2 hw) async {
        ids.addAll((await isar.homework2s.where().filter().idEqualTo(hw.id).findAll()).map((e) => e.dbId ?? -1));
      });
      await isar.homework2s.deleteAll(ids);
      await isar.homework2s.putAll(newHW);
    });
  }

  Future<List<Homework2>> getAllHomework() async {
    return await isarInstance.homework2s.where().findAll();
  }

  
}
