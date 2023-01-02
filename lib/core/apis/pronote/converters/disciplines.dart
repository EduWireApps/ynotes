import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';

class PronoteDisciplineConverter {
  static disciplines(PronoteClient client, Map disciplinesData) {
    List<Discipline> disciplines = [];
    //Translate averages
    String generalAverage = client.utils.gradeTranslate(mapGet(
            disciplinesData, ['donneesSec', 'donnees', 'moyGenerale', 'V']) ??
        "");
    String classGeneralAverage = client.utils.gradeTranslate(
        mapGet(disciplinesData, ['donneesSec', 'donnees', 'moyClasse', 'V']) ??
            "");

    var rawDisciplines = mapGet(
            disciplinesData, ['donneesSec', 'donnees', 'listeServices', 'V']) ??
        [];
    rawDisciplines.forEach((rawDiscipline) {
      String disciplineName = mapGet(rawDiscipline, ["L"]);
      List<Grade> gradesList = [];
      String minClassAverage =
          client.utils.gradeTranslate(mapGet(rawDiscipline, ["moyMin", "V"]));
      String maxClassAverage =
          client.utils.gradeTranslate(mapGet(rawDiscipline, ["moyMax", "V"]));
      String classAverage = client.utils
          .gradeTranslate(mapGet(rawDiscipline, ["moyClasse", "V"]));
      String average =
          client.utils.gradeTranslate(mapGet(rawDiscipline, ["moyEleve", "V"]));
      List<String> teachers = [];
      List<String> subdisciplineCode = [];
      disciplines.add(Discipline(
          disciplineName: disciplineName,
          disciplineCode: disciplineName.hashCode.toString(),
          gradesList: gradesList,
          minClassAverage: minClassAverage,
          maxClassAverage: maxClassAverage,
          average: average,
          classAverage: classAverage,
          generalAverage: generalAverage,
          classGeneralAverage: classGeneralAverage,
          subdisciplineCodes: subdisciplineCode,
          teachers: teachers));
    });
    var rawGrades = mapGet(
            disciplinesData, ['donneesSec', 'donnees', 'listeDevoirs', 'V']) ??
        [];
    //get grades
    List<Grade> _grades = grades(client, rawGrades);
    for (var element in disciplines) {
      (element.gradesList ?? []).addAll(_grades
          .where((grade) => grade.disciplineName == element.disciplineName));
    }
    return disciplines;
  }

  static List<Grade> grades(PronoteClient client, List gradesData) {
    List<Grade> grades = [];
    for (var gradeData in gradesData) {
      String value =
          client.utils.gradeTranslate(mapGet(gradeData, ["note", "V"]) ?? "");
      String testName = mapGet(gradeData, ["commentaire"]) ?? "";
      String periodCode = mapGet(gradeData, ["periode", "V", "N"]) ?? "";
      String periodName = mapGet(gradeData, ["periode", "V", "L"]) ?? "";
      String disciplineCode =
          (mapGet(gradeData, ["service", "V", "L"]) ?? "").hashCode.toString();
      String? subdisciplineCode;
      String disciplineName = mapGet(gradeData, ["service", "V", "L"]);
      bool letters = (mapGet(gradeData, ["note", "V"]) ?? "").contains("|");
      String weight = mapGet(gradeData, ["coefficient"]).toString();
      String scale = mapGet(gradeData, ["bareme", "V"]);
      String min = client.utils
          .gradeTranslate(mapGet(gradeData, ["noteMin", "V"]) ?? "");
      String max = client.utils
          .gradeTranslate(mapGet(gradeData, ["noteMax", "V"]) ?? "");
      String classAverage = client.utils
          .gradeTranslate(mapGet(gradeData, ["moyenne", "V"]) ?? "");
      DateTime? date = mapGet(gradeData, ["date", "V"]) != null
          ? DateFormat("dd/MM/yyyy").parse(mapGet(gradeData, ["date", "V"]))
          : null;
      bool notSignificant =
          client.utils.gradeTranslate(mapGet(gradeData, ["note", "V"]) ?? "") ==
              "NonNote";
      String testType = "Interrogation";
      DateTime? entryDate = mapGet(gradeData, ["date", "V"]) != null
          ? DateFormat("dd/MM/yyyy").parse(mapGet(gradeData, ["date", "V"]))
          : null;
      bool countAsZero = client.utils.shouldCountAsZero(
          client.utils.gradeTranslate(mapGet(gradeData, ["note", "V"]) ?? ""));
      bool optional = mapGet(gradeData, ["estFacultatif"]) ?? false;
      bool bonus = mapGet(gradeData, ["estBonus"]) ?? false;

      grades.add(Grade(
          value: value,
          testName: testName,
          periodCode: periodCode,
          periodName: periodName,
          disciplineCode: disciplineCode,
          subdisciplineCode: subdisciplineCode,
          disciplineName: disciplineName,
          letters: letters,
          weight: weight,
          scale: scale,
          min: min,
          max: max,
          classAverage: classAverage,
          date: date,
          notSignificant: notSignificant,
          testType: testType,
          entryDate: entryDate,
          countAsZero: countAsZero,
          optional: optional,
          bonus: bonus));
    }
    return grades;
  }
}
