import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class GradesStats {
  final Grade? grade;
  final List<Grade>? allGrades;

  GradesStats({this.grade, required this.allGrades});

  ///returns a double (positive or negative)
  ///this represents the the increase or decrease of the **discipline average** for this period when receiving the grade
  double calculateAverageImpact() {
    //remove not concerned grades
    assert(grade != null, "Grade can't be null");
    List<Grade> _sortedGrades = [];
    _sortedGrades.addAll(allGrades!);
    //Remove unconcerned grades
    _sortedGrades.removeWhere(
        (_grade) => _grade.disciplineCode != grade?.disciplineCode || _grade.periodCode != grade?.periodCode);
    _sortedGrades = _sortedGrades.reversed.toList();
    //get concerned grad index
    int gradeIndex =
        _sortedGrades.indexWhere((_grade) => _grade.testName == grade?.testName && _grade.date == grade?.date);
    //remove next items
    _sortedGrades = _sortedGrades.sublist(0, gradeIndex + 1);
    double beforeAverage = 0.0;
    double afterAverage = 0.0;
    double coeffCounter = 0.0;
    for (var _grade in _sortedGrades) {
      //Before selected grade
      if (_grade.testName != grade?.testName || _grade.entryDate != grade?.entryDate) {
        if (!_grade.notSignificant! && !_grade.letters!) {
          final double? value = double.tryParse(_grade.value!.replaceAll(',', '.'));
          final double? scale = double.tryParse(_grade.scale!.replaceAll(',', '.'));
          if (value != null && scale != null) {
            final double gradeOver20 = value * 20 / scale;
            beforeAverage += gradeOver20 * double.parse(_grade.weight!.replaceAll(',', '.'));
            afterAverage += gradeOver20 * double.parse(_grade.weight!.replaceAll(',', '.'));
            coeffCounter += double.tryParse(_grade.weight!.replaceAll(',', '.'))!;
          }
        }
      }
      //At selected grade
      else {
        //Calculate before average
        beforeAverage = beforeAverage / coeffCounter;
        if (!_grade.notSignificant! && !_grade.letters!) {
          double gradeOver20 =
              double.parse(_grade.value!.replaceAll(',', '.')) * 20 / double.parse(_grade.scale!.replaceAll(',', '.'));
          afterAverage += gradeOver20 * double.parse(_grade.weight!.replaceAll(',', '.'));
          coeffCounter += double.tryParse(_grade.weight!.replaceAll(',', '.'))!;
          //Calculate before average

          afterAverage = afterAverage / coeffCounter;
        } else {
          afterAverage = beforeAverage;
        }
      }
      //Returns the difference
    }
    if ((afterAverage - beforeAverage).isNaN) {
      return afterAverage;
    }

    return (afterAverage - beforeAverage);
  }

  ///returns a double (positive or negative)
  ///this represents the the increase or decrease of the **global average** for this period when receiving the grade
  double calculateGlobalAverageImpact() {
    assert(grade != null, "Grade can't be null");

    List<Grade> _periodGradesWithGrade = [];
    List<Grade> _periodGradesWithoutGrade = [];

    _periodGradesWithGrade.addAll(allGrades!);
    //remove other periods grades
    _periodGradesWithGrade.removeWhere((_grade) => _grade.periodCode != grade?.periodCode);
    _periodGradesWithGrade = _periodGradesWithGrade.reversed.toList();
    //get this grade index
    int gradeIndex =
        _periodGradesWithGrade.indexWhere((_grade) => _grade.testName == grade?.testName && _grade.date == grade?.date);
    //remove next items
    _periodGradesWithGrade = _periodGradesWithGrade.sublist(0, gradeIndex + 1);
    _periodGradesWithoutGrade.addAll(_periodGradesWithGrade);
    if (_periodGradesWithoutGrade.isNotEmpty) {
      _periodGradesWithoutGrade.removeLast();
    }

    return (_calculateGlobalAverage(_periodGradesWithGrade) - _calculateGlobalAverage(_periodGradesWithoutGrade));
  }

  ///returns a double (positive or negative)
  ///this represents the the increase or decrease of the **global average** for this period with and without the grade
  double calculateGlobalAverageImpactOverall() {
    assert(grade != null, "Grade can't be null");

    List<Grade> _periodGradesWithGrade = [];
    List<Grade> _periodGradesWithoutGrade = [];

    _periodGradesWithGrade.addAll(allGrades!);
    //remove other periods grades
    _periodGradesWithGrade.removeWhere((_grade) => _grade.periodCode != grade?.periodCode);
    _periodGradesWithGrade = _periodGradesWithGrade.reversed.toList();
    _periodGradesWithoutGrade.addAll(_periodGradesWithGrade);
    //remove grade
    _periodGradesWithoutGrade.removeWhere((_grade) => _grade.testName == grade?.testName && _grade.date == grade?.date);

    return (_calculateGlobalAverage(_periodGradesWithGrade) - _calculateGlobalAverage(_periodGradesWithoutGrade));
  }

  ///returns last average for each grade
  List<double> lastAverages() {
    List<Grade> _sortedGrades = [];
    _sortedGrades.addAll(allGrades!);
    _sortedGrades = _sortedGrades.reversed.toList();
    List<double> averages = [];

    for (var grade in _sortedGrades) {
      averages.add(_calculateGlobalAverage(_sortedGrades
          .sublist(0, _sortedGrades.indexOf(grade))
          .where((element) => element.periodCode == grade.periodCode)
          .toList()));
    }
    return averages;
  }

  double _calculateGlobalAverage(List<Grade> grades) {
    Map<dynamic, List<Grade>> gradesSortedByDisciplines = {};
    List<double> averages = [];

    for (var grade in grades) {
      //ensure that grade can be used
      if (!grade.notSignificant! && !grade.letters!) {
        if (gradesSortedByDisciplines[grade.disciplineCode] == null) {
          gradesSortedByDisciplines[grade.disciplineCode] = [];
        }
        gradesSortedByDisciplines[grade.disciplineCode]!.add(grade);
      }
    }
    for (var key in gradesSortedByDisciplines.keys) {
      double average = 0.0;
      double counter = 0.0;
      for (var _grade in gradesSortedByDisciplines[key]!) {
        try {
          average += double.parse(_grade.value!.replaceAll(',', '.')) *
              20 /
              double.parse(_grade.scale!.replaceAll(',', '.')) *
              double.parse(_grade.weight!.replaceAll(',', '.'));
          counter += double.parse(_grade.weight!);
        } catch (e) {
          CustomLogger.error(e);
        }
      }
      average = average / counter;
      averages.add(average);
      //add average to list
    }
    if (averages.isNotEmpty) {
      return (averages.reduce((a, b) => a + b) / averages.length);
    } else {
      return 0.0;
    }
  }
}
