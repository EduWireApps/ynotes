import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class GradesUtils {
  average(List<Discipline> disciplineList, String period) {
    //Init sums and average
    double average = 0;
    double weightSum = 0.0;
    double sum = 0.0;

    List<double> averages = [];

    //Iterating into every discipline
    disciplineList.where((i) => i.periodName == period).forEach((discipline) {
      try {
        double _average = disciplineAverage(discipline);
        if (!_average.isNaN) {
          double nw =
              double.parse((discipline.weight ?? "1").replaceAll(',', '.'));
          weightSum += nw;
          averages.add(_average * nw);
        }
        CustomLogger.log("object", weightSum);
      } catch (e) {
        CustomLogger.error(e, stackHint: "Mzk=");
      }
    });

    for (var element in averages) {
      if (!element.isNaN) {
        sum += element;
      }
    }
    average = sum / weightSum;
    return average;
  }

  //Get average
  disciplineAverage(Discipline discipline) {
    double _average = 0.0;
    double _counter = 0;
    List optionalGrades = [];
    for (Grade grade in (discipline.gradesList ?? [])) {
      if (!(grade.notSignificant ?? false) && !(grade.letters ?? false)) {
        if (grade.optional) {
          optionalGrades.add(grade);
          return;
        }
        try {
          _counter += double.parse(grade.weight!);
          _average += double.parse(grade.value!.replaceAll(',', '.')) *
              20 /
              double.parse(grade.scale!.replaceAll(',', '.')) *
              double.parse((grade.weight ?? "1.0").replaceAll(',', '.'));
        } catch (e) {
          CustomLogger.log("ERREUR TEST", e);
        }
      }
    }

    //Treat optional grades
    //These ones only count if grade is beneficial
    for (Grade grade in optionalGrades) {
      try {
        double tempCounter = _counter + double.parse(grade.weight!);
        double tempAverage = _average +
            double.parse(grade.value!.replaceAll(',', '.')) *
                20 /
                double.parse(grade.scale!.replaceAll(',', '.')) *
                double.parse((grade.weight ?? "1.0").replaceAll(',', '.'));
        if ((tempAverage / tempCounter) > (_average / _counter)) {
          _average = tempAverage;
          _counter = tempCounter;
        }
      } catch (e) {
        CustomLogger.log("ERREUR TEST", e);
      }
    }
    return _average / _counter;
  }
}
