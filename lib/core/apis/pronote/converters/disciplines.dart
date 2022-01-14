import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/logic/models_exporter.dart';

class PronoteDisciplineConverter {
  static disciplines(PronoteClient client, Map disciplinesData) {
    List<Discipline> disciplines = [];
    //Translate averages
    String generalAverage =
        client.utils.gradeTranslate(disciplinesData['donneesSec']['donnees']['moyGenerale']['V'] ?? "");
    String classGeneralAverage =
        client.utils.gradeTranslate(disciplinesData['donneesSec']['donnees']['moyClasse']['V'] ?? "");

    var rawDisciplines = disciplinesData['donneesSec']['donnees']['listeServices']['V'] ?? [];
    rawDisciplines.forEach((rawDiscipline) {
      String disciplineName = rawDiscipline["L"];
      List<Grade> gradesList = [];
      String minClassAverage = client.utils.gradeTranslate(rawDiscipline["moyMin"]["V"]);
      String maxClassAverage = client.utils.gradeTranslate(rawDiscipline["moyMax"]["V"]);
      String classAverage = client.utils.gradeTranslate(rawDiscipline["moyClasse"]["V"]);
      String average = client.utils.gradeTranslate(rawDiscipline["moyEleve"]["V"]);
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
    var rawGrades = disciplinesData['donneesSec']['donnees']['listeDevoirs']['V'] ?? [];
    //get grades
    List<Grade> _grades = grades(client, rawGrades);
    for (var element in disciplines) {
      (element.gradesList ?? []).addAll(_grades.where((grade) => grade.disciplineName == element.disciplineName));
    }
    return disciplines;
  }

  static List<Grade> grades(PronoteClient client, List gradesData) {
    List<Grade> grades = [];
    for (var gradeData in gradesData) {
      String value = client.utils.gradeTranslate(gradeData["note"]["V"] ?? "");
      String testName = gradeData["commentaire"] ?? "";
      String periodCode = gradeData["periode"]["V"]["N"] ?? "";
      String periodName = gradeData["periode"]["V"]["L"] ?? "";
      String disciplineCode = (gradeData["service"]["V"]["L"] ?? "").hashCode.toString();
      String? subdisciplineCode;
      String disciplineName = gradeData["service"]["V"]["L"];
      bool letters = (gradeData["note"]["V"] ?? "").contains("|");
      String weight = gradeData["coefficient"].toString();
      String scale = gradeData["bareme"]["V"];
      String min = client.utils.gradeTranslate(gradeData["noteMin"]["V"] ?? "");
      String max = client.utils.gradeTranslate(gradeData["noteMax"]["V"] ?? "");
      String classAverage = client.utils.gradeTranslate(gradeData["moyenne"]["V"] ?? "");
      DateTime? date = gradeData["date"]["V"] != null ? DateFormat("dd/MM/yyyy").parse(gradeData["date"]["V"]) : null;
      bool notSignificant = client.utils.gradeTranslate(gradeData["note"]["V"] ?? "") == "NonNote";
      String testType = "Interrogation";
      DateTime? entryDate =
          gradeData["date"]["V"] != null ? DateFormat("dd/MM/yyyy").parse(gradeData["date"]["V"]) : null;
      bool countAsZero = client.utils.shouldCountAsZero(client.utils.gradeTranslate(gradeData["note"]["V"] ?? ""));
      bool optional = gradeData["estFacultatif"] ?? false;
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
          optional: optional));
    }
    return grades;
  }
}
