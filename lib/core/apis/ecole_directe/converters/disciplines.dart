import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/anonymizer_utils.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

import '../../model.dart';

class EcoleDirecteDisciplineConverter {
  static API_TYPE apiType = API_TYPE.ecoleDirecte;

  static YConverter disciplines = YConverter(
      apiType: apiType,
      logSlot: "Disciplines",
      anonymizer: (Map<dynamic, dynamic> accountData) {
        Map toAnonymize = {
          "nom": AnonymizerUtils.generateRandomString(8),
          "valeur": "7",
          "moyenne": "7",
          "moyenneClasse": "5",
          "rang": "Premier"
        };
        return AnonymizerUtils.severalValues(jsonEncode(accountData), toAnonymize);
      },
      converter: (Map<String, dynamic> disciplinesData) {
        List<Discipline> disciplinesList = [];
        List periodes = disciplinesData['data']['periodes'];
        List gradesData = disciplinesData['data']['notes'];
        Map<String, dynamic> settings = disciplinesData['data']['parametrage'];

        for (var periodeElement in periodes) {
          try {
            //Make a list of grades

            List disciplines = periodeElement["ensembleMatieres"]["disciplines"];
            for (var rawData in disciplines) {
              List profs = rawData['professeurs'];
              List<String> teachersNames = [];

              for (var e in profs) {
                teachersNames.add(e["nom"]);
              }
              //No one sub discipline
              if (rawData['codeSousMatiere'] == "") {
                String? disciplineCode = rawData['codeMatiere']?.toString();
                String? disciplineName = rawData['discipline']?.toString();
                String? average = rawData['moyenne']?.toString();
                String? classAverage = rawData['moyenneClasse'].toString();
                String? minClassAverage = rawData['moyenneMin']?.toString();
                String? maxClassAverage = rawData['moyenneMax']?.toString();
                String periodeName = periodeElement["periode"].toString();
                String? periodeId = periodeElement["idPeriode"]?.toString();
                String? generalAverage = periodeElement["ensembleMatieres"]["moyenneGenerale"]?.toString();
                String? classGeneralAverage = periodeElement["ensembleMatieres"]["moyenneClasse"]?.toString();
                String? maxClassGeneralAverage = periodeElement["ensembleMatieres"]["moyenneMax"]?.toString();
                String? minClassGeneralAverage = periodeElement["ensembleMatieres"]["moyenneMin"]?.toString();
                Color color = Colors.blue;
                bool showRank = settings["moyenneRang"] ?? false;
                int? disciplineRank = showRank ? rawData["rang"] : null;
                String? classNumber = periodeElement["ensembleMatieres"]["effectif"]?.toString();
                String? generalRank =
                    (settings["moyenneRang"] ?? false) ? periodeElement["ensembleMatieres"]["rang"]?.toString() : null;
                String weight = (settings["coefficientNote"] as bool) ? rawData["coef"].toString() : "1";

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
                  CustomLogger.error(e, stackHint: "MjA=");
                }
              }
            }
            //Retrieve related grades for each discipline
            for (var discipline in disciplinesList) {
              if (discipline.periodName == periodeElement["periode"]) {
                List<Grade> localGradesList = [];

                for (var element in gradesData) {
                  if (element["codeMatiere"] == discipline.disciplineCode &&
                      element["codePeriode"] == periodeElement["idPeriode"]) {
                    String nomPeriode = periodeElement["periode"];
                    localGradesList.add(Grade.fromEcoleDirecteJson(element, nomPeriode));
                  }
                }

                discipline.gradesList = localGradesList;
              }
            }
          } catch (e) {
            CustomLogger.error(e, stackHint: "MjE=");
          }
        }
        return disciplinesList;
      });
}
