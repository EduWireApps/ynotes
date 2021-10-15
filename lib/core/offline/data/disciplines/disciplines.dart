import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/useful_methods.dart';

class DisciplinesOffline {
  late Offline parent;
  DisciplinesOffline(Offline _parent) {
    parent = _parent;
  }
  //Used to get disciplines, from db or locally
  Future<List<Discipline>?> getDisciplines() async {
    try {
      return await parent.offlineBox?.get("disciplines").cast<Discipline>();
    } catch (e) {
      CustomLogger.log("DISCIPLINES", "An error occured while returning disciplines");
      CustomLogger.error(e);
      return null;
    }
  }

  ///Get periods from DB (a little bit messy but totally functional)
  getPeriods() async {
    try {
      List<Period> listPeriods = [];
      List<Discipline>? disciplines = await getDisciplines();
      List<Grade>? grades = getAllGrades(disciplines, overrideLimit: true);
      grades?.forEach((grade) {
        if (!listPeriods.any((period) => period.name == grade.periodName || period.id == grade.periodCode)) {
          if (grade.periodName != null && grade.periodName != "") {
            listPeriods.add(Period(grade.periodName, grade.periodCode));
          } else {}
        } else {}
      });
      try {
        listPeriods.sort((a, b) => a.name!.compareTo(b.name!));
      } catch (e) {
        CustomLogger.log("DISCIPLINES", "An error occured while sorting disciplines");
        CustomLogger.error(e);
      }
      return listPeriods;
    } catch (e) {
      throw ("Error while collecting offline periods " + e.toString());
    }
  }

  ///Update existing disciplines (clear old data) with passed data
  updateDisciplines(List<Discipline> newData) async {
    try {
      CustomLogger.log("DISCIPLINES", "Updating disciplines");
      await parent.offlineBox?.delete("disciplines");
      await parent.offlineBox?.put("disciplines", newData);
    } catch (e) {
      CustomLogger.log("DISCIPLINES", "An error occured while updating disciplines");
      CustomLogger.error(e);
    }
  }
}
