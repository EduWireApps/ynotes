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
  List<Discipline> _old = List();
  String _period = "";
  double _average = 0.0;
  String _bestAverage;
  bool isFetching = false;
  bool _isSimulating = false;
  List<String> specialties;
  String _sorter = "all";

  GradesSimulator simulator;
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
    simulator = GradesSimulator(_old, refresh);
    refresh();
    notifyListeners();
  }

  List<Discipline> get disciplines => _isSimulating ? simulator.disciplines : _old;

  List<Period> get periods => _schoolPeriods;

  GradesController(this.api) {
    _api = api;
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
      _old = await _api.getGrades();
      notifyListeners();
    } else {
      _old = await _api.getGrades(forceReload: force);
      notifyListeners();
    }
    isFetching = false;
    _setDefaultPeriod();
    _filterDisciplinesForPeriod();
    await _setListSpecialties();

    notifyListeners();
  }

  void _setDefaultPeriod() {
    if (disciplines != null && _period == "") {
      _period = disciplines.lastWhere((list) => list.gradesList.length > 0).gradesList.last.periodName;
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
    disciplines.where((i) => i.period == _period).forEach((f) {
      try {
        double _average = 0.0;
        double _counter = 0;
        f.gradesList.forEach((grade) {
          if (!grade.notSignificant && !grade.letters) {
            _counter += double.parse(grade.coefficient);
            _average += double.parse(grade.value.replaceAll(',', '.')) *
                20 /
                double.parse(grade.scale.replaceAll(',', '.')) *
                double.parse(grade.coefficient.replaceAll(',', '.'));
          }
        });
        _average = _average / _counter;
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
      if (disciplines.last != null && disciplines.last.maxClassGeneralAverage != null) {
        double value = double.tryParse(disciplines.last.maxClassGeneralAverage.replaceAll(",", "."));
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
  void _filterDisciplinesForPeriod() {
    List<Discipline> toReturn = new List<Discipline>();
    disciplines.forEach((f) {
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
    _setAverage();
    _setBestAverage();
    _old = toReturn;
    notifyListeners();
  }
}

///A grade simulator
class GradesSimulator {
  final List<Discipline> defaultDisciplines;
  final Function callback;

  ///This list is NEVER touched
  List<Discipline> _defaultDisciplines;

  ///Returned disciplines
  List<Discipline> _simulatedDisciplines;

  //Added "unreal" grades
  List<Grade> _addedGrades = List();

  //Removed "real" grades
  List<Grade> _removedGrades = List();

  List<Discipline> get disciplines => _simulatedDisciplines;

  GradesSimulator(this.defaultDisciplines, this.callback) {
    reset();
  }

  void reset() {
    _defaultDisciplines = this.defaultDisciplines;
    _addedGrades.clear();
    _removedGrades.clear();
    merge();
  }

  void add(Grade _grade) {
    _removedGrades.removeWhere((grade) => grade == _grade);
    _addedGrades.add(_grade);
    print(_addedGrades);
    merge();
  }

  void remove(Grade _grade) {
    if (_addedGrades.contains(_grade)) {
      _addedGrades.removeWhere((grade) => grade == _grade);
    } else {
      _removedGrades.add(_grade);
    }
    merge();
  }

  void merge() {
    if (defaultDisciplines != null) {
      print("Merging ...");
      _simulatedDisciplines = defaultDisciplines;
      _simulatedDisciplines.forEach((discipline) {
        discipline.gradesList.removeWhere((_grade) => _removedGrades.contains(_grade));
        if (_addedGrades.any((_grade) =>
            _grade.periodName == discipline.period &&
            _grade.disciplineCode == discipline.disciplineCode &&
            !_simulatedDisciplines.contains(_grade))) {
          discipline.gradesList.addAll(_addedGrades.where((_grade) =>
              _grade.periodName == discipline.period && _grade.disciplineCode == discipline.disciplineCode));
        }
      });
    }
    this.callback();
  }
}
