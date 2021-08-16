import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/data/disciplines_filter.dart';
import 'package:ynotes/core/logic/competences/models.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

class CompetencesController extends ChangeNotifier {
  String? _period = "";
  bool isFetching = false;
  List<String?>? specialties;
  String _sorter = "all";
  API? _api;
  List<Period>? _schoolPeriods;
  List<CompetencesDiscipline>? _disciplines = [];
  CompetencesController(API? api) {
    _api = api;
  }
  set api(API? api) {
    _api = api;
  }

  String? get period => _period;
  set period(String? newPeriod) {
    _period = newPeriod;
    refresh();
  }

  List<Period>? get periods => _schoolPeriods;

  String get sorter => _sorter;
  set sorter(String newSorter) {
    _sorter = newSorter;
    refresh();
  }

  List<CompetencesDiscipline>? disciplines({bool showAll = false}) =>
      _filterDisciplinesForPeriod(_disciplines ?? [], showAll: showAll);

  Future<void> refresh({bool force = false, refreshFromOffline = false}) async {
    CustomLogger.log("GRADES", "Refreshing competences " + (refreshFromOffline ? "from offline" : "online"));

    notifyListeners();
    //ED
    if (refreshFromOffline) {
      _disciplines = await _api?.getCompetences(forceReload: force);
      notifyListeners();
    } else {
      _disciplines = await _api?.getCompetences(forceReload: force);
      notifyListeners();
    }
    isFetching = false;
    await _refreshPeriods();

    notifyListeners();
  }

  //Get school periods;
  ///Get the corresponding disciplines and responding to the filter chosen
  List<CompetencesDiscipline>? _filterDisciplinesForPeriod(List<CompetencesDiscipline>? li, {bool showAll = false}) {
    if (showAll == true) {
      return li;
    }
    List<CompetencesDiscipline> toReturn = [];
    (li ?? []).forEach((f) {
      switch (_sorter) {
        case "all":
          if (f.periodName == _period) {
            toReturn.add(f);
          }
          break;
        case "littérature":
          if (appSys.settings.system.chosenParser == 0) {
            List<String> codeMatiere = filters["literary"]["ED"];

            if (f.periodName == _period &&
                codeMatiere.any((test) {
                  if (test == f.disciplineCode) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          } else {
            List<String> codeMatiere = filters["literary"]["Pronote"];

            if (f.periodName == _period &&
                codeMatiere.any((test) {
                  if (f.disciplineName.contains(test)) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          }

          break;
        case "sciences":
          if (appSys.settings.system.chosenParser == 0) {
            List<String> codeMatiere = filters["sciences"]["ED"];

            if (f.periodName == _period &&
                codeMatiere.any((test) {
                  if (test == f.disciplineCode) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          } else {
            List<String> codeMatiere = filters["sciences"]["Pronote"];
            List<String> blackList = filters["sciences"]["blacklist"];
            if (f.periodName == _period &&
                codeMatiere.any((test) {
                  if (f.disciplineName.contains(test) &&
                      !blackList.any((element) => f.disciplineName.contains(element))) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          }
          break;
        case "spécialités":
          if (specialties != null) {
            if (f.periodName == _period &&
                specialties!.any((test) {
                  if (test == f.disciplineName) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          } else {
            CustomLogger.log("GRADES", "Specialties list is null");
          }
          break;
      }
    });
    return toReturn;
  }

  void _setDefaultPeriod() {
    if (_disciplines != null && _disciplines!.length != 0 && _period == "") {
      _period = (_disciplines ?? []).lastWhere((list) => list.assessmentsList!.length > 0).periodName;
    }
  }

  //Removed "real" grades
  _refreshPeriods() async {
    List<Period> temp = this.disciplines(showAll: true)?.map((e) => Period(e.periodName, e.periodCode)).toList() ?? [];
    final ids = temp.map((e) => e.name).toSet();
    temp.retainWhere((x) => ids.remove(x.name));
    List<Period> unicalPeriods = temp.toSet().toList();
    _schoolPeriods = unicalPeriods;
    _setDefaultPeriod();
  }
}
