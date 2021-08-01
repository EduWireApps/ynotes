import 'dart:convert';

import 'package:ynotes/core/logic/competences/models.dart';
import 'package:ynotes/extensions.dart';

class EcoleDirecteCompetencesConverter {
  static List<CompetencesDiscipline> competences(Map<dynamic, dynamic> competencesData) {
    List<CompetencesDiscipline> competencesDisciplinesList = [];

    List? rawLsunData = competencesData['data']['notes'];
    if (rawLsunData != null) {
      rawLsunData.forEach((assessment) {
        if (assessment["elementsProgramme"] != null && assessment["elementsProgramme"].length > 0) {
          //First we create a new discipline
          String periodCode = assessment["libelleMatiere"];

          String disciplineName = assessment["libelleMatiere"];
          String disciplineCode = assessment["codeMatiere"];
          List<String> subdisciplineCodes = [];
          subdisciplineCodes.add(assessment["codeSousMatiere"]);
          List<String> subdisciplineNames = [];
          subdisciplineNames.add(assessment["libelleSousMatiere"]);

          List<Competence> competences =
              _competences(assessment["elementsProgramme"], competencesData['data']["parametrage"]);
          Assessment _assessment =
              Assessment(assessmentDate: DateTime.parse(assessment["date"]), competences: competences);

          CompetencesDiscipline competencesDiscipline = CompetencesDiscipline(
              disciplineName: disciplineName,
              disciplineCode: disciplineCode,
              periodCode: periodCode,
              periodName: "",
              subdisciplineCodes: subdisciplineCodes,
              subdisciplineNames: subdisciplineNames,
              assessmentsList: [_assessment]);

          if (competencesDisciplinesList.any((element) =>
              element.periodCode == competencesDiscipline.periodCode &&
              element.disciplineCode == competencesDiscipline.disciplineCode)) {
            //We add all assessments
            competencesDisciplinesList
                .firstWhere((element) =>
                    element.periodCode == competencesDiscipline.periodCode &&
                    element.disciplineCode == competencesDiscipline.disciplineCode)
                .assessmentsList
                ?.addAll(competencesDiscipline.assessmentsList ?? []);
            //We add all subdisciplineCodes

            competencesDisciplinesList
                .firstWhere((element) =>
                    element.periodCode == competencesDiscipline.periodCode &&
                    element.disciplineCode == competencesDiscipline.disciplineCode)
                .subdisciplineCodes
                ?.addAll(competencesDiscipline.subdisciplineCodes ?? []);

            //We add all subdisciplineNames

            competencesDisciplinesList
                .firstWhere((element) =>
                    element.periodCode == competencesDiscipline.periodCode &&
                    element.disciplineCode == competencesDiscipline.disciplineCode)
                .subdisciplineNames
                ?.addAll(competencesDiscipline.subdisciplineNames ?? []);
          } else {
            competencesDisciplinesList.add(competencesDiscipline);
          }
        }
      });
      return competencesDisciplinesList;
    } else {
      return [];
    }
  }

  static List<Competence> _competences(List competencesData, Map settings) {
    List<Competence> competences = [];
    competencesData.forEach((competence) {
      String domainName = competence["libelleCompetence"];
      String domainId = competence["idCompetence"];
      String itemName = competence["descriptif"];
      String itemId = competence["idElemProg"];
      CompetenceDomain domain = CompetenceDomain(name: domainName, id: domainId);
      CompetenceItem item = CompetenceItem(name: itemName, id: itemId);
      Competence _competence = Competence(
          domain: domain,
          item: item,
          level: _level(settings, competence["niveau"]),
          levelLabel: _level(settings, competence["niveau"]).name);
      competences.add(_competence);
    });
    return competences;
  }

  static CompetenceLevel _level(Map settings, String level) {
    return CompetenceLevel(
        defaultColor: HexColor.fromHex(settings["couleurEval$level"]),
        name: utf8.decode(base64Decode(settings["libelleEval$level"])));
  }
}
