import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils.dart';

class EcoleDirecteDisciplineConverter {
  static List<Discipline> disciplines(Map<String, dynamic> disciplinesData) {
    List<Discipline> disciplinesList = [];
    List periodes = disciplinesData['data']['periodes'];
    List gradesData = disciplinesData['data']['notes'];
    Map<String, dynamic> settings = disciplinesData['data']['parametrage'];

    periodes.forEach((periodeElement) {
      try {
        //Make a list of grades

        List disciplines = periodeElement["ensembleMatieres"]["disciplines"];
        disciplines.forEach((rawData) {
          List profs = rawData['professeurs'];
          List<String> teachersNames = [];

          profs.forEach((e) {
            teachersNames.add(e["nom"]);
          });
          //No one sub discipline
          if (rawData['codeSousMatiere'] == "") {
            String? disciplineCode = rawData['codeMatiere'];
            String? disciplineName = rawData['discipline'];
            String? average = rawData['moyenne'];
            String? classAverage = rawData['moyenneClasse'];
            String? minClassAverage = rawData['moyenneMin'];
            String? maxClassAverage = rawData['moyenneMax'];
            String periodeName = periodeElement["periode"];
            String? periodeId = periodeElement["idPeriode"];
            String? generalAverage = periodeElement["ensembleMatieres"]["moyenneGenerale"];
            String? classGeneralAverage = periodeElement["ensembleMatieres"]["moyenneClasse"];
            String? maxClassGeneralAverage = periodeElement["ensembleMatieres"]["moyenneMax"];
            String? minClassGeneralAverage = periodeElement["ensembleMatieres"]["moyenneMin"];
            Color color = Colors.blue;
            bool showRank = settings["moyenneRang"] ?? false;
            int? disciplineRank = showRank ? rawData["rang"] : null;
            String? classNumber = periodeElement["ensembleMatieres"]["effectif"];
            String? generalRank =
                (settings["moyenneRang"] ?? false) ? periodeElement["ensembleMatieres"]["rang"] : null;
            String weight = rawData["coef"].toString();

            disciplinesList.add(Discipline(
                maxClassGeneralAverage: maxClassGeneralAverage,
                minClassGeneralAverage: minClassGeneralAverage,
                classGeneralAverage: classGeneralAverage,
                generalAverage: generalAverage,
                classAverage: classAverage,
                minClassAverage: minClassAverage,
                maxClassAverage: maxClassAverage,
                disciplineCode: disciplineCode,
                average: average,
                teachers: teachersNames,
                disciplineName: disciplineName,
                periodName: periodeName,
                color: color.value,
                disciplineRank: disciplineRank,
                classNumber: classNumber,
                generalRank: generalRank,
                weight: weight,
                periodCode: periodeId,
                subdisciplineCodes: [],
                subdisciplineNames: []));
          }
          //Sub discipline
          else {
            try {
              //We add sub discipline codes
              disciplinesList[disciplinesList.lastIndexWhere((disciplinesList) =>
                      disciplinesList.disciplineCode == rawData['codeMatiere'] &&
                      disciplinesList.periodName == periodeElement["periode"])]
                  .subdisciplineCodes!
                  .add(rawData['codeSousMatiere']);

              //We add sub discipline names
              disciplinesList[disciplinesList.lastIndexWhere((disciplinesList) =>
                      disciplinesList.disciplineCode == rawData['codeMatiere'] &&
                      disciplinesList.periodName == periodeElement["periode"])]
                  .subdisciplineNames!
                  .add(rawData['discipline']);
            } catch (e) {
              CustomLogger.error(e);
            }
          }
        });
        //Retrieve related grades for each discipline
        disciplinesList.forEach((discipline) {
          if (discipline.periodName == periodeElement["periode"]) {
            List<Grade> localGradesList = [];

            gradesData.forEach((element) {
              if (element["codeMatiere"] == discipline.disciplineCode &&
                  element["codePeriode"] == periodeElement["idPeriode"]) {
                String nomPeriode = periodeElement["periode"];
                localGradesList.add(Grade.fromEcoleDirecteJson(element, nomPeriode));
              }
            });

            discipline.gradesList = localGradesList;
          }
        });
      } catch (e) {
        CustomLogger.error(e);
      }
    });
    return disciplinesList;
  }
}
