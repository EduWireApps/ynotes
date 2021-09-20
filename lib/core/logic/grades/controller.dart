import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/data/disciplines_filter.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

///To use to collect grades in a view
class GradesController extends ChangeNotifier {
  API? _api;
  List<Period>? _schoolPeriods;
  List<Discipline>? _disciplines = [];
  List<Discipline> z = [];

  String? _period = "";
  double _average = 0.0;
  String? _bestAverage;
  bool isFetching = false;
  bool _isSimulating = false;
  List<String?>? specialties;
  String _sorter = "all";

  final List<Grade> _addedGrades = [];
  final List<Grade?> _removedGrades = [];

  GradesController(API? api) {
    _api = api;
  }
  set api(API? api) {
    _api = api;
  }

  double get average => _average;

  String? get bestAverage => _bestAverage;

  bool get isSimulating => _isSimulating;

  set isSimulating(bool newState) {
    _isSimulating = newState;
    refresh();
    notifyListeners();
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

  List<Discipline>? disciplines({bool showAll = false}) => isSimulating
      ? _filterDisciplinesForPeriod(simulationMerge(_disciplines ?? []), showAll: showAll)
      : _filterDisciplinesForPeriod(_disciplines, showAll: showAll);

  String gradeHash(Grade grade) {
    return (grade.value.hashCode.toString() +
        grade.disciplineName.hashCode.toString() +
        grade.entryDate.hashCode.toString());
  }

  //Get school periods;
  Future<void> refresh({bool force = false, refreshFromOffline = false}) async {
    CustomLogger.log("GRADES", "Refreshing grades " + (refreshFromOffline ? "from offline" : "online"));
    if (isSimulating && force) {
      isSimulating = false;
    }
    isFetching = true;
    notifyListeners();
    //ED
    if (refreshFromOffline) {
      _disciplines = await _api?.getGrades();
      notifyListeners();
    } else {
      _disciplines = await _api?.getGrades(forceReload: force);
      notifyListeners();
    }
    isFetching = false;
    await _refreshPeriods();
    _setDefaultPeriod();
    _setAverage();
    _setBestAverage();
    await _setListSpecialties();
    notifyListeners();
  }

  void simulationAdd(Grade _grade) {
    _removedGrades.removeWhere((grade) => grade == _grade);
    _addedGrades.add(_grade);
    notifyListeners();
    refresh();
  }

  simulationMerge(List<Discipline> list) {
    ///Returned disciplines
    List<Discipline>? _simulatedDisciplines;
    _simulatedDisciplines = [];
    //boring clone
    _simulatedDisciplines.addAll(list
        .map((e) => Discipline(
            gradesList: e.gradesList!
                .map((f) => Grade(
                      max: f.max,
                      min: f.min,
                      testName: f.testName,
                      periodCode: f.periodCode,
                      disciplineCode: f.disciplineCode,
                      subdisciplineCode: f.subdisciplineCode,
                      disciplineName: f.disciplineName,
                      letters: f.letters,
                      value: f.value,
                      weight: f.weight,
                      scale: f.scale,
                      classAverage: f.classAverage,
                      testType: f.testType,
                      date: f.date,
                      entryDate: f.entryDate,
                      notSignificant: f.notSignificant,
                      periodName: f.periodName,
                      simulated: f.simulated,
                      countAsZero: f.countAsZero,
                    ))
                .toList(),
            maxClassGeneralAverage: e.maxClassGeneralAverage,
            classGeneralAverage: e.classGeneralAverage,
            generalAverage: e.generalAverage,
            classAverage: e.classAverage,
            minClassAverage: e.minClassAverage,
            maxClassAverage: e.maxClassAverage,
            disciplineCode: e.disciplineCode,
            subdisciplineCodes: e.subdisciplineCodes,
            average: e.average,
            teachers: e.teachers,
            disciplineName: e.disciplineName,
            periodName: e.periodName,
            color: e.color,
            disciplineRank: e.disciplineRank,
            classNumber: e.classNumber,
            generalRank: e.generalRank))
        .toList());
    CustomLogger.log("GRADES", "Merging");
    for (var discipline in _simulatedDisciplines) {
      discipline.gradesList!.removeWhere((_grade) => _removedGrades.any((element) =>
          element!.date == _grade.date && element.value == _grade.value && element.testName == _grade.testName));
      if (_addedGrades.any((_grade) =>
          _grade.periodName == discipline.periodName && _grade.disciplineCode == discipline.disciplineCode)) {
        discipline.gradesList!.addAll(_addedGrades.where((_grade) =>
            _grade.periodName == discipline.periodName && _grade.disciplineCode == discipline.disciplineCode));
      }
    }

    return _simulatedDisciplines;
  }

  void simulationRemove(Grade? _grade) {
    if (_addedGrades.contains(_grade)) {
      _addedGrades.removeWhere((grade) => grade == _grade);
    } else {
      _removedGrades.add(_grade);
    }
    notifyListeners();
    refresh();
  }

  void simulationReset() {
    _addedGrades.clear();
    _removedGrades.clear();
    refresh();
  }

  /*-----SIMULATION PART------*/

  //Added "unreal" grades
  simulatorCallback() {
    _setAverage();
    notifyListeners();
  }

  //Removed "real" grades
  ///Get the corresponding disciplines and responding to the filter chosen
  List<Discipline>? _filterDisciplinesForPeriod(List<Discipline>? li, {bool showAll = false}) {
    if (showAll == true) {
      return li;
    }
    List<Discipline> toReturn = [];
    for (var f in (li ?? [])) {
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
                  if (f.disciplineName!.contains(test)) {
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
                  if (f.disciplineName!.contains(test) &&
                      !blackList.any((element) => f.disciplineName!.contains(element))) {
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
    }
    return toReturn;
  }

  _refreshPeriods() async {
    List<Period> temp = disciplines(showAll: true)?.map((e) => Period(e.periodName, e.periodCode)).toList() ?? [];
    final ids = temp.map((e) => e.name).toSet();
    temp.retainWhere((x) => ids.remove(x.name));
    List<Period> unicalPeriods = temp.toSet().toList();
    _schoolPeriods = unicalPeriods;
  }

  ///Set the user average
  void _setAverage() {
    _average = 0;
    double? temp;
    List<double> averages = [];
    for (Discipline f in disciplines()!.where((i) => i.periodName == _period)) {
      if (appSys.settings.system.chosenParser == 1) {
        if (f.generalAverage != null) {
          double? _temp = double.tryParse(f.generalAverage!.replaceAll(",", "."));
          if (temp != null && !temp.isNaN) {
            temp = _temp;
            notifyListeners();
            break;
          }
        }
      }
      try {
        double? _average = f.getAverage().isNaN ? f.average as double? : f.getAverage();
        if (_average != null && !_average.isNaN) {
          averages.add(_average);
        }
      } catch (e) {}
    }

    double sum = 0.0;
    for (var element in averages) {
      sum += element;
    }
    _average = temp ?? (sum / averages.length);
    notifyListeners();
  }

  void _setBestAverage() {
    try {
      if (disciplines()!.last.maxClassGeneralAverage != null) {
        double? value = double.tryParse(disciplines()!.last.maxClassGeneralAverage!.replaceAll(",", "."));
        if (value != null) {
          _bestAverage = value >= average ? value.toString() : average.toStringAsFixed(2);
        } else {
          _bestAverage = "-";
        }
      } else {
        _bestAverage = "-";
      }
    } catch (e) {
      _bestAverage = "-";
    }
    notifyListeners();
  }

  void _setDefaultPeriod() {
    if (_disciplines != null && _disciplines!.isNotEmpty && _period == "") {
      _period = (_disciplines ?? []).lastWhere((list) => list.gradesList!.isNotEmpty).gradesList!.last.periodName;
    }
  }

  ///Get specialties list
  _setListSpecialties() async {
    final prefs = await (SharedPreferences.getInstance());
    {
      specialties = prefs.getStringList("listSpecialties");
      notifyListeners();
    }
  }
}
