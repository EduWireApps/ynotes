import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils.dart';

class CompetencesOffline {
  late Offline parent;
  CompetencesOffline(Offline _parent) {
    parent = _parent;
  }
  //Used to get disciplines, from db or locally
  Future<List<CompetencesDiscipline>?> getCompetencesDisciplines() async {
    try {
      return await parent.offlineBox?.get("competences").cast<CompetencesDiscipline>();
    } catch (e) {
      CustomLogger.log("COMPETENCES", "An error occured while returning competences");
      CustomLogger.error(e);
      return null;
    }
  }

  ///Get periods from DB (a little bit messy but totally functional)
  getPeriods() async {
    try {
      List<Period> listPeriods = [];
      List<CompetencesDiscipline>? disciplines = await getCompetencesDisciplines();
      disciplines?.forEach((discipline) {
        if (!listPeriods.any((period) => period.name == discipline.periodName || period.id == discipline.periodCode)) {
          if (discipline.periodName != "") {
            listPeriods.add(Period(discipline.periodName, discipline.periodCode));
          } else {}
        } else {}
      });
      try {
        listPeriods.sort((a, b) => a.name!.compareTo(b.name!));
      } catch (e) {
        CustomLogger.log("COMPETENCES", "An error occured while sorting periods");
        CustomLogger.error(e);
      }
      return listPeriods;
    } catch (e) {
      throw ("Error while collecting offline periods " + e.toString());
    }
  }

  ///Update existing disciplines (clear old data) with passed data
  updateCompetencesDisciplines(List<CompetencesDiscipline> newData) async {
    try {
      CustomLogger.log("COMPETENCES", "Updating competences");
      await parent.offlineBox?.delete("competences");
      await parent.offlineBox?.put("competences", newData);
    } catch (e) {
      CustomLogger.log("COMPETENCES", "An error occured while updating competences");
      CustomLogger.error(e);
    }
  }
}
