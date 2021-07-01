import 'package:ynotes/core/logic/models_exporter.dart';

class GradesUtils {
  //Get average
  average(List<Discipline> disciplineList, String period) {
    double average = 0;
    List<double> averages = [];
    disciplineList.where((i) => i.periodName == period).forEach((f) {
      try {
        double _average = 0.0;
        double _counter = 0;
        f.gradesList!.forEach((grade) {
          if (!grade.notSignificant! && !grade.letters!) {
            _counter += double.parse(grade.weight!);
            _average += double.parse(grade.value!.replaceAll(',', '.')) *
                20 /
                double.parse(grade.scale!.replaceAll(',', '.')) *
                double.parse(grade.weight!.replaceAll(',', '.'));
          }
        });
        _average = _average / _counter;
        if (!_average.isNaN) {
          averages.add(_average);
        }
      } catch (e) {}
    });
    double sum = 0.0;
    averages.forEach((element) {
      if (!element.isNaN) {
        sum += element;
      }
    });
    average = sum / averages.length;
    return average;
  }
}
