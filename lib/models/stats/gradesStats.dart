import 'package:ynotes/classes.dart';

class GradesStats {
  final Grade grade;
  final List<Grade> allGrades;

  GradesStats(this.grade, this.allGrades);

  ///returns a double (positive or negative)
  ///this represents the the increase or decrease of the **discipline average** for this period when receiving the grade
  double calculateAverageImpact() {
    //remove not concerned grades

    List<Grade> _sortedGrades = List();
    _sortedGrades.addAll(this.allGrades);
    //Order
    //Remove unconcerned grades

    _sortedGrades.removeWhere(
        (_grade) => _grade.codeMatiere != this.grade.codeMatiere || _grade.codePeriode != this.grade.codePeriode);
    _sortedGrades = _sortedGrades.reversed.toList();
    int gradeIndex =
        _sortedGrades.indexWhere((_grade) => _grade.devoir == this.grade.devoir && _grade.date == this.grade.date);
    //remove next items
    _sortedGrades = _sortedGrades.sublist(0, gradeIndex + 1);
    double beforeAverage = 0.0;
    double afterAverage = 0.0;
    double coeffCounter = 0.0;

    _sortedGrades.forEach((_grade) {
      //Before selected grade
      if (_grade.devoir != this.grade.devoir || _grade.dateSaisie != this.grade.dateSaisie) {
        if (!_grade.nonSignificatif && !_grade.letters) {
          double gradeOver20 =
              double.parse(_grade.valeur.replaceAll(',', '.')) * 20 / double.parse(_grade.noteSur.replaceAll(',', '.'));
          beforeAverage += gradeOver20 * double.parse(_grade.coef.replaceAll(',', '.'));
          afterAverage += gradeOver20 * double.parse(_grade.coef.replaceAll(',', '.'));
          coeffCounter += double.tryParse(_grade.coef.replaceAll(',', '.'));
        }
      }
      //At selected grade
      else {
        //Calculate before average
        beforeAverage = beforeAverage / coeffCounter;

        if (!_grade.nonSignificatif && !_grade.letters) {
          double gradeOver20 =
              double.parse(_grade.valeur.replaceAll(',', '.')) * 20 / double.parse(_grade.noteSur.replaceAll(',', '.'));
          afterAverage += gradeOver20 * double.parse(_grade.coef.replaceAll(',', '.'));
          coeffCounter += double.tryParse(_grade.coef.replaceAll(',', '.'));
          //Calculate before average

          afterAverage = afterAverage / coeffCounter;
        }
      }
      //Returns the difference
    });
    print(beforeAverage);
    print(afterAverage);
    if (afterAverage - beforeAverage == null || (afterAverage - beforeAverage).isNaN) {
      return afterAverage;
    }
    return (afterAverage - beforeAverage);
  }

  ///returns a double (positive or negative)
  ///this represents the the increase or decrease of the **global average** for this period when receiving the grade
  double calculateGlobalAverageImpact() {
    List<Grade> _periodGradesWithGrade = List();
    List<Grade> _periodGradesWithoutGrade = List();

    _periodGradesWithGrade.addAll(this.allGrades);
    //remove other periods grades
    _periodGradesWithGrade.removeWhere((_grade) => _grade.codePeriode != this.grade.codePeriode);
    _periodGradesWithGrade = _periodGradesWithGrade.reversed.toList();
    //get this grade index
    int gradeIndex = _periodGradesWithGrade
        .indexWhere((_grade) => _grade.devoir == this.grade.devoir && _grade.date == this.grade.date);
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
    List<Grade> _periodGradesWithGrade = List();
    List<Grade> _periodGradesWithoutGrade = List();

    _periodGradesWithGrade.addAll(this.allGrades);
    //remove other periods grades
    _periodGradesWithGrade.removeWhere((_grade) => _grade.codePeriode != this.grade.codePeriode);
    _periodGradesWithGrade = _periodGradesWithGrade.reversed.toList();
    //get this grade index
    int gradeIndex = _periodGradesWithGrade
        .indexWhere((_grade) => _grade.devoir == this.grade.devoir && _grade.date == this.grade.date);
    _periodGradesWithoutGrade.addAll(_periodGradesWithGrade);
    //remove grade
    _periodGradesWithoutGrade
        .removeWhere((_grade) => _grade.devoir == this.grade.devoir && _grade.date == this.grade.date);

    return (_calculateGlobalAverage(_periodGradesWithGrade) - _calculateGlobalAverage(_periodGradesWithoutGrade));
  }

  double _calculateGlobalAverage(List<Grade> grades) {
    Map<dynamic, List<Grade>> gradesSortedByDisciplines = Map();
    List<double> averages = List();

    grades.forEach((grade) {
      //ensure that grade can be used
      if (!grade.nonSignificatif && !grade.letters) {
        if (gradesSortedByDisciplines[grade.codeMatiere] == null) {
          gradesSortedByDisciplines[grade.codeMatiere] = List();
        }
        gradesSortedByDisciplines[grade.codeMatiere].add(grade);
      }
    });
    gradesSortedByDisciplines.keys.forEach((key) {
      double average = 0.0;
      double counter = 0.0;
      gradesSortedByDisciplines[key].forEach((_grade) {
        try {
          average += double.parse(_grade.valeur.replaceAll(',', '.')) *
              20 /
              double.parse(_grade.noteSur.replaceAll(',', '.')) *
              double.parse(_grade.coef.replaceAll(',', '.'));
          counter += double.parse(_grade.coef);
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
