import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/offline/data/homework/doneHomework.dart';
import 'package:ynotes/offline/data/homework/pinnedHomework.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/utils/fileUtils.dart';

import '../../../classes.dart';

class HomeworkOffline extends Offline {
  ///Update existing offline.homework.get() with passed data
  ///if `add` boolean is set to true passed data is combined with old data
  updateHomework(List<Homework> newData, {bool add = false, forceAdd = false}) async {
    if (!locked) {
      print("Update offline homwork");
      try {
        if (!offlineBox.isOpen) {
          offlineBox = await Hive.openBox("offlineData");
        }
        if (add == true && newData != null) {
          List<Homework> oldHW = List();
          if (offlineBox.get("homework") != null) {
            oldHW = offlineBox.get("homework").cast<Homework>();
          }

          List<Homework> combinedList = List();
          combinedList.addAll(oldHW);
          newData.forEach((newdataelement) {
            if (forceAdd) {
              combinedList.removeWhere((element) => element.id == newdataelement.id);
              combinedList.add(newdataelement);
            } else if (combinedList.any((clistelement) => clistelement.id == newdataelement.id)) {
              combinedList.add(newdataelement);
            }
          });
          combinedList = combinedList.toSet().toList();

          await offlineBox.put("homework", combinedList);
        } else {
          await offlineBox.put("homework", newData);
        }
        await refreshData();
      } catch (e) {
        print("Error while updating homework " + e.toString());
      }
    }
  }

  //Get all homework
  Future<List<Homework>> getHomework() async {
    try {
      if (homeworkData != null) {
        return homeworkData;
      } else {
        await refreshData();

        return homeworkData;
      }
    } catch (e) {
      print("Error while returning homework " + e.toString());
      return null;
    }
  }
}
