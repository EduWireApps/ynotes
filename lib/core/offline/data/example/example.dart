import 'package:hive/hive.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/loggingUtils.dart';

class Example extends HiveObject {
  int id;
  String? fieldToUpdateOnce;
  String? fieldToUpdate;

  Example(this.id, {this.fieldToUpdateOnce, this.fieldToUpdate});
}

class ExampleOffline {
  late Offline parent;

  //We need to access parent database to access opened boxes
  ExampleOffline(Offline _parent) {
    parent = _parent;
  }

  //A really simple get example
  Future<List<Example>?> getAllExample() async {
    try {
      //Await is not even needed
      //Here we access a box content we dont even need to cast content
      //But we need to reference the box like that `Box<Example>` in `offline.dart`
      //Caution box can be null
      return parent.exampleBox?.values.toList();
    } catch (e) {
      CustomLogger.log("EXAMPLE", "An error occured while returning example");
      CustomLogger.error(e);
      return null;
    }
  }

  ///Here we update existing data : but we don't want every fields to be updated each time
  update(List<Example> newExamples) async {
    CustomLogger.log("EXAMPLE", "Update examples (length : ${newExamples.length})");
    try {
      //Here we get already persisted data
      List<Example>? oldExamples = [];
      if (await getAllExample() != null) {
        oldExamples = await getAllExample();
      }

      //Here we treat already persisteddata
      if (oldExamples != null) {
        await Future.forEach(oldExamples, (Example oldExample) async {
          await Future.forEach(newExamples, (Example newExample) async {
            if (newExample.id == oldExample.id) {
              //fields we want to update in the old example
              oldExample.fieldToUpdate = newExample.fieldToUpdate;
              //we can update it in the database easily with save();
              //caution : don't update newExample (not in the datbase) but oldExample
              await oldExample.save();
            }
          });
        });
      }

      //We clear existing values
      final old = (parent.exampleBox?.values.toList().cast<Example>())
          ?.where((oldExample) => newExamples.any((newExample) => newExample.id == oldExample.id));
      if (old != null) {
        newExamples.removeWhere((newExample) => old.any((oldExample) => newExample.id == oldExample.id));
        CustomLogger.log("EXAMPLE", "New examples length: ${newExamples.length}");
      }

      //We add to the database the others
      await parent.exampleBox?.addAll(newExamples);
    } catch (e) {
      CustomLogger.log("EXAMPLE", "An error occured while updating examples");
      CustomLogger.error(e);
    }
  }
}
