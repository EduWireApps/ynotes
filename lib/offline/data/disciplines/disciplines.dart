import 'package:hive/hive.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/usefulMethods.dart';

class DisciplinesOffline extends Offline {
  Offline parent;
  DisciplinesOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }
  //Used to get disciplines, from db or locally
  Future<List<Discipline>> getDisciplines() async {
    if (!locked) {
      try {
        if (parent.disciplinesData != null) {
          await parent.refreshData();
          return parent.disciplinesData;
        } else {
          await parent.refreshData();
          return parent.disciplinesData;
        }
      } catch (e) {
        print("Error while returning disciplines" + e.toString());
        return null;
      }
    }
  }

  ///Update existing disciplines (clear old data) with passed data
  updateDisciplines(List<Discipline> newData) async {
    if (!locked) {
      try {
        /*if (offlineBox == null || !offlineBox.isOpen) {
          offlineBox = await Hive.openBox("offlineData");
        }*/
        print("Updating disciplines");
        await offlineBox.delete("disciplines");
        await offlineBox.put("disciplines", newData);
        await refreshData();
      } catch (e) {
        print("Error while updating disciplines " + e);
      }
    }
  }

  ///Get periods from DB (a little bit messy but totally functional)
  getPeriods() async {
    try {
      List<Period> listPeriods = List();
      List<Discipline> disciplines = await this.getDisciplines();
      List<Grade> grades = getAllGrades(disciplines, overrideLimit: true);

      grades.forEach((grade) {
        if (!listPeriods.any((period) => period.name == grade.periodName && period.id == grade.periodCode)) {
          if (grade.periodName != null && grade.periodName != "") {
            listPeriods.add(Period(grade.periodName, grade.periodCode));
          } else {}
        }
      });
      try {
        listPeriods.sort((a, b) => a.name.compareTo(b.name));
      } catch (e) {
        print(e);
      }

      return listPeriods;
    } catch (e) {
      throw ("Error while collecting offline periods " + e.toString());
    }
  }
}
