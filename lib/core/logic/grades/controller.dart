import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/services/shared_preferences.dart';
import 'package:ynotes/usefulMethods.dart';

///To use to collect grades in a view
class GradesController extends ChangeNotifier {
  final api;
  API _api;
  List<Period> _schoolPeriods;
  List<Discipline> _disciplines = List();
  List<Discipline> z = List();

  String _period = "";
  double _average = 0.0;
  String _bestAverage;
  bool isFetching = false;
  bool _isSimulating = false;
  List<String> specialties;
  String _sorter = "all";

  double get average => _average;
  String get bestAverage => _bestAverage;

  set sorter(String newSorter) {
    _sorter = newSorter;
    refresh();
  }

  set period(String newPeriod) {
    _period = newPeriod;
    refresh();
  }

  get period => _period;

  get sorter => _sorter;

  get isSimulating => _isSimulating;

  set isSimulating(bool newState) {
    _isSimulating = newState;
    refresh();
    notifyListeners();
  }

  List<Discipline> disciplines({bool showAll = false}) => isSimulating
      ? _filterDisciplinesForPeriod(simulationMerge(_disciplines), showAll: showAll)
      : _filterDisciplinesForPeriod(_disciplines, showAll: showAll);

  List<Period> get periods => _schoolPeriods;

  GradesController(this.api) {
    _api = api;
  }

  simulatorCallback() {
    _setAverage();
    notifyListeners();
  }

  Future<void> refresh({bool force = false, refreshFromOffline = false}) async {
    print("Refresh grades");
    if (isSimulating && force) {
      isSimulating = false;
    }
    isFetching = true;
    notifyListeners();
    await _refreshPeriods();
    //ED
    if (refreshFromOffline) {
      _disciplines = await _api.getGrades();
      notifyListeners();
    } else {
      _disciplines = await _api.getGrades(forceReload: force);
      notifyListeners();
    }

    isFetching = false;
    _setDefaultPeriod();
    _setAverage();
    _setBestAverage();
    await _setListSpecialties();

    notifyListeners();
  }

  void _setDefaultPeriod() {
    if (_disciplines != null && _period == "") {
      _period = _disciplines.lastWhere((list) => list.gradesList.length > 0).gradesList.last.periodName;
    }
  }

  //Get school periods;
  _refreshPeriods() async {
    _schoolPeriods = await _api.getPeriods();
  }

  ///Set the user average
  void _setAverage() {
    _average = 0;
    List<double> averages = List();
    disciplines().where((i) => i.period == _period).forEach((f) {
      try {
        double _average = f.getAverage().isNaN ? f.average : f.getAverage();
        if (_average != null && !_average.isNaN) {
          averages.add(_average);
        }
      } catch (e) {}
    });
    double sum = 0.0;
    averages.forEach((element) {
      if (element != null && !element.isNaN) {
        sum += element;
      }
    });
    _average = sum / averages.length;
    notifyListeners();
  }

  void _setBestAverage() {
    try {
      if (disciplines().last != null && disciplines().last.maxClassGeneralAverage != null) {
        double value = double.tryParse(disciplines().last.maxClassGeneralAverage.replaceAll(",", "."));
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

  ///Get specialties list
  _setListSpecialties() async {
    final prefs = await SharedPreferences.getInstance();
    {
      specialties = prefs.getStringList("listSpecialties");
      notifyListeners();
    }
  }

  ///Get the corresponding disciplines and responding to the filter chosen
  List<Discipline> _filterDisciplinesForPeriod(List<Discipline> li, {bool showAll = false}) {
    if (showAll == true) {
      return li;
    }
    List<Discipline> toReturn = new List<Discipline>();
    li.forEach((f) {
      switch (_sorter) {
        case "all":
          if (f.period == _period) {
            toReturn.add(f);
          }
          break;
        case "littérature":
          if (chosenParser == 0) {
            List<String> codeMatiere = ["FRANC", "HI-GE", "AGL1", "ESP2"];

            if (f.period == _period &&
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
            List<String> codeMatiere = ["FRANCAIS", "ANGLAIS", "ESPAGNOL", "ALLEMAND", "HISTOIRE", "PHILO"];

            if (f.period == _period &&
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
          if (chosenParser == 0) {
            List<String> codeMatiere = ["SVT", "MATHS", "G-SCI", "PH-CH"];
            if (f.period == _period &&
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
            List<String> codeMatiere = ["SVT", "MATH", "PHY", "PHYSIQUE", "SCI", "BIO"];
            List<String> blackList = ["SPORT"];
            if (f.period == _period &&
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
            if (f.period == _period &&
                specialties.any((test) {
                  if (test == f.disciplineName) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          } else {
            debugPrint("Specialties list is null");
          }
          break;
      }
    });
    return toReturn;
  }

  /*-----SIMULATION PART------*/

  //Added "unreal" grades
  List<Grade> _addedGrades = List();

  //Removed "real" grades
  List<Grade> _removedGrades = List();

  void simulationReset() {
    _addedGrades.clear();
    _removedGrades.clear();
    refresh();
  }

  void simulationAdd(Grade _grade) {
    _removedGrades.removeWhere((grade) => grade == _grade);
    _addedGrades.add(_grade);
    notifyListeners();
    refresh();
  }

  void simulationRemove(Grade _grade) {
    if (_addedGrades.contains(_grade)) {
      _addedGrades.removeWhere((grade) => grade == _grade);
    } else {
      _removedGrades.add(_grade);
    }
    notifyListeners();
    refresh();
  }

  String gradeHash(Grade grade) {
    return (grade.value.hashCode.toString() +
        grade.disciplineName.hashCode.toString() +
        grade.entryDate.hashCode.toString());
  }

  simulationMerge(List<Discipline> list) {
    ///Returned disciplines
    List<Discipline> _simulatedDisciplines;
    if (list != null) {
      _simulatedDisciplines = List();
      //boring clone
      _simulatedDisciplines.addAll(list
          .map((e) => Discipline(
              gradesList: e.gradesList
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
              disciplineCode: e.classAverage,
              subdisciplineCode: e.subdisciplineCode,
              average: e.average,
              teachers: e.teachers,
              disciplineName: e.disciplineName,
              period: e.period,
              color: e.color,
              disciplineRank: e.disciplineRank,
              classNumber: e.classNumber,
              generalRank: e.generalRank))
          .toList());
      print("Merging ...");
      _simulatedDisciplines.forEach((discipline) {
        discipline.gradesList.removeWhere((_grade) => _removedGrades.any((element) =>
            element.date == _grade.date && element.value == _grade.value && element.testName == _grade.testName));
        if (_addedGrades.any(
            (_grade) => _grade.periodName == discipline.period && _grade.disciplineCode == discipline.disciplineCode)) {
          discipline.gradesList.addAll(_addedGrades.where((_grade) =>
              _grade.periodName == discipline.period && _grade.disciplineCode == discipline.disciplineCode));
        }
      });
    }
    return _simulatedDisciplines;
  }
}
