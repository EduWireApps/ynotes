import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

class EcoleDirecteDisciplineConverter {
  static List<Discipline> disciplines(Map<String, dynamic> disciplinesData) {
    List<Discipline> disciplinesList = List();
    List periodes = disciplinesData['data']['periodes'];
    List gradesData = disciplinesData['data']['notes'];
    Map<String, dynamic> settings = disciplinesData['data']['parametrage'];

    periodes.forEach((periodeElement) {
      try {
        //Make a list of grades

        List disciplines = periodeElement["ensembleMatieres"]["disciplines"];
        disciplines.forEach((rawData) {
          List profs = rawData['professeurs'];
          List<String> teachersNames = List<String>();

          profs.forEach((e) {
            teachersNames.add(e["nom"]);
          });
          //No one sub discipline
          if (rawData['codeSousMatiere'] == "") {
            disciplinesList.add(Discipline.fromEcoleDirecteJson(
                json: rawData,
                profs: teachersNames,
                periode: periodeElement["periode"],
                moyenneG: periodeElement["ensembleMatieres"]["moyenneGenerale"],
                bmoyenneClasse: periodeElement["ensembleMatieres"]["moyenneMax"],
                moyenneClasse: periodeElement["ensembleMatieres"]["moyenneClasse"],
                color: Colors.blue,
                showrank: settings["moyenneRang"] ?? false,
                effectifClasse: periodeElement["ensembleMatieres"]["effectif"],
                rangGeneral: (settings["moyenneRang"] ?? false) ? periodeElement["ensembleMatieres"]["rang"] : null));
          }
          //Sub discipline
          else {
            try {
              disciplinesList[disciplinesList.lastIndexWhere((disciplinesList) =>
                      disciplinesList.disciplineCode == rawData['codeMatiere'] &&
                      disciplinesList.period == periodeElement["periode"])]
                  .subdisciplineCode
                  .add(rawData['codeSousMatiere']);
            } catch (e) {
              print(e);
            }
          }
        });
        //Retrieve related grades for each discipline
        disciplinesList.forEach((discipline) {
          if (discipline.period == periodeElement["periode"]) {
            List<Grade> localGradesList = List<Grade>();

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
        print(e);
      }
    });
    return disciplinesList;
  }
}
