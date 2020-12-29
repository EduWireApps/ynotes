import 'package:ynotes/classes.dart';

class GradesStats {
  final Grade grade;
  final List<Grade> allGrades;

  GradesStats(this.grade, this.allGrades);

  ///returns a double (positive or negative)
  ///this represents the the increase or decrease of the **discipline average** for this period
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
        print("RAW BEFORE AVERAGE " + beforeAverage.toString());
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
    print("Counter " + coeffCounter.toString());
    print("Before average " + beforeAverage.toString());
    print("After average " + afterAverage.toString());
    return (afterAverage - beforeAverage);
  }

  ///returns a double (positive or negative)
  ///this represents the the increase or decrease of the **global average** for this period
  double calculateGlobalImpact() {}
}
