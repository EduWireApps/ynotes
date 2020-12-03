import 'package:hive/hive.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/usefulMethods.dart';

class DisciplinesOffline extends Offline {
  //Used to get disciplines, from db or locally
  Future<List<Discipline>> getDisciplines() async {
    try {
      if (disciplinesData != null) {
        await refreshData();
        return disciplinesData;
      } else {
        await refreshData();
        return disciplinesData;
      }
    } catch (e) {
      print("Error while returning disciplines" + e.toString());
      return null;
    }
  }

  ///Update existing disciplines (clear old data) with passed data
  updateDisciplines(List<Discipline> newData) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      print("Updating disciplines");
      await offlineBox.delete("disciplines");
      await offlineBox.put("disciplines", newData);
      await refreshData();
    } catch (e) {
      print("Error while updating disciplines " + e);
    }
  }

  ///Get periods from DB (a little bit messy but totally functional)
  getPeriods() async {
    try {
      List<Period> listPeriods = List();
      List<Discipline> disciplines = await this.getDisciplines();
      List<Grade> grades = getAllGrades(disciplines, overrideLimit: true);

      grades.forEach((grade) {
        if (!listPeriods.any((period) => period.name == grade.nomPeriode && period.id == grade.codePeriode)) {
          if (grade.nomPeriode != null && grade.nomPeriode != "") {
            listPeriods.add(Period(grade.nomPeriode, grade.codePeriode));
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
