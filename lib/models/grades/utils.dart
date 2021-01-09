import 'package:ynotes/classes.dart';

class GradesUtils {
  //Get average
  average(List<Discipline> disciplineList, String period) {
    double average = 0;
    List<double> averages = List();
    disciplineList.where((i) => i.periode == period).forEach((f) {
      try {
        double _average = 0.0;
        double _counter = 0;
        f.gradesList.forEach((grade) {
          if (!grade.nonSignificatif && !grade.letters) {
            _counter += double.parse(grade.coef);
            _average += double.parse(grade.valeur.replaceAll(',', '.')) *
                20 /
                double.parse(grade.noteSur.replaceAll(',', '.')) *
                double.parse(grade.coef.replaceAll(',', '.'));
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
    average = sum / averages.length;
    return average;
  }
}
