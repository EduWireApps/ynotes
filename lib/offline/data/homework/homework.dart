import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/offline/data/homework/doneHomework.dart';
import 'package:ynotes/offline/data/homework/pinnedHomework.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/utils/fileUtils.dart';

import '../../../classes.dart';

class HomeworkOffline extends Offline {
  Offline parent;
  HomeworkOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }

  ///Update existing offline.homework.get() with passed data
  ///if `add` boolean is set to true passed data is combined with old data
  updateHomework(List<Homework> newData, {bool add = false, forceAdd = false}) async {
    if (!locked) {
      print("Update offline homwork");
      try {
        if (!parent.offlineBox.isOpen) {
          parent.offlineBox = await Hive.openBox("offlineData");
        }
        if (add == true && newData != null) {
          List<Homework> oldHW = List();
          if (parent.offlineBox.get("homework") != null) {
            oldHW = super.offlineBox.get("homework").cast<Homework>();
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

          await parent.offlineBox.put("homework", combinedList);
        } else {
          await parent.offlineBox.put("homework", newData);
        }
        await parent.refreshData();
      } catch (e) {
        print("Error while updating homework " + e.toString());
      }
    }
  }

  //Get all homework
  Future<List<Homework>> getHomework() async {
    try {
      if (parent.homeworkData != null) {
        return parent.homeworkData;
      } else {
        await parent.refreshData();

        return parent.homeworkData;
      }
    } catch (e) {
      print("Error while returning homework " + e.toString());
      return null;
    }
  }
}
