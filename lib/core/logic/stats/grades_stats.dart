import 'package:ynotes/core/logic/models_exporter.dart';

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
    _sortedGrades.addAll(this.allGrades!);
    //Remove unconcerned grades
    _sortedGrades.removeWhere(
        (_grade) => _grade.disciplineCode != this.grade?.disciplineCode || _grade.periodCode != this.grade?.periodCode);
    _sortedGrades = _sortedGrades.reversed.toList();
    //get concerned grad index
    int gradeIndex = _sortedGrades
        .indexWhere((_grade) => _grade.testName == this.grade?.testName && _grade.date == this.grade?.date);
    //remove next items
    _sortedGrades = _sortedGrades.sublist(0, gradeIndex + 1);
    double beforeAverage = 0.0;
    double afterAverage = 0.0;
    double coeffCounter = 0.0;
    _sortedGrades.forEach((_grade) {
      //Before selected grade
      if (_grade.testName != this.grade?.testName || _grade.entryDate != this.grade?.entryDate) {
        if (!_grade.notSignificant! && !_grade.letters!) {
          double gradeOver20 =
              double.parse(_grade.value!.replaceAll(',', '.')) * 20 / double.parse(_grade.scale!.replaceAll(',', '.'));
          beforeAverage += gradeOver20 * double.parse(_grade.weight!.replaceAll(',', '.'));
          afterAverage += gradeOver20 * double.parse(_grade.weight!.replaceAll(',', '.'));
          coeffCounter += double.tryParse(_grade.weight!.replaceAll(',', '.'))!;
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
    });
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

    _periodGradesWithGrade.addAll(this.allGrades!);
    //remove other periods grades
    _periodGradesWithGrade.removeWhere((_grade) => _grade.periodCode != this.grade?.periodCode);
    _periodGradesWithGrade = _periodGradesWithGrade.reversed.toList();
    //get this grade index
    int gradeIndex = _periodGradesWithGrade
        .indexWhere((_grade) => _grade.testName == this.grade?.testName && _grade.date == this.grade?.date);
    //remove next items
    _periodGradesWithGrade = _periodGradesWithGrade.sublist(0, gradeIndex + 1);
    _periodGradesWithoutGrade.addAll(_periodGradesWithGrade);
    if (_periodGradesWithoutGrade.length > 0) {
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

    _periodGradesWithGrade.addAll(this.allGrades!);
    //remove other periods grades
    _periodGradesWithGrade.removeWhere((_grade) => _grade.periodCode != this.grade?.periodCode);
    _periodGradesWithGrade = _periodGradesWithGrade.reversed.toList();
    _periodGradesWithoutGrade.addAll(_periodGradesWithGrade);
    //remove grade
    _periodGradesWithoutGrade
        .removeWhere((_grade) => _grade.testName == this.grade?.testName && _grade.date == this.grade?.date);

    return (_calculateGlobalAverage(_periodGradesWithGrade) - _calculateGlobalAverage(_periodGradesWithoutGrade));
  }

  ///returns last average for each grade
  List<double> lastAverages() {
    List<Grade> _sortedGrades = [];
    _sortedGrades.addAll(this.allGrades!);
    _sortedGrades = _sortedGrades.reversed.toList();
    List<double> averages = [];

    _sortedGrades.forEach((Grade grade) {
      averages.add(_calculateGlobalAverage(_sortedGrades
          .sublist(0, _sortedGrades.indexOf(grade))
          .where((element) => element.periodCode == grade.periodCode)
          .toList()));
    });
    return averages;
  }

  double _calculateGlobalAverage(List<Grade> grades) {
    Map<dynamic, List<Grade>> gradesSortedByDisciplines = Map();
    List<double> averages = [];

    grades.forEach((grade) {
      //ensure that grade can be used
      if (!grade.notSignificant! && !grade.letters!) {
        if (gradesSortedByDisciplines[grade.disciplineCode] == null) {
          gradesSortedByDisciplines[grade.disciplineCode] = [];
        }
        gradesSortedByDisciplines[grade.disciplineCode]!.add(grade);
      }
    });
    gradesSortedByDisciplines.keys.forEach((key) {
      double average = 0.0;
      double counter = 0.0;
      gradesSortedByDisciplines[key]!.forEach((_grade) {
        try {
          average += double.parse(_grade.value!.replaceAll(',', '.')) *
              20 /
              double.parse(_grade.scale!.replaceAll(',', '.')) *
              double.parse(_grade.weight!.replaceAll(',', '.'));
          counter += double.parse(_grade.weight!);
        } catch (e) {}
      });
      average = average / counter;
      averages.add(average);
      //add average to list
    });
    if (averages.length != 0) {
      return (averages.reduce((a, b) => a + b) / averages.length);
    } else {
      return 0.0;
    }
  }
}
