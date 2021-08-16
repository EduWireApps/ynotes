import 'dart:convert';

import 'package:ynotes/core/logic/competences/models.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/extensions.dart';

class EcoleDirecteCompetencesConverter {
  static List<CompetencesDiscipline> competences(Map<dynamic, dynamic> competencesData) {
    List<CompetencesDiscipline> competencesDisciplinesList = [];

    List? rawLsunData = competencesData['data']['notes'];
    List? periodes = competencesData['data']['periodes'];

    if (rawLsunData != null) {
      rawLsunData.forEach((assessment) {
        if (assessment["elementsProgramme"] != null && assessment["elementsProgramme"].length > 0) {
          //First we create a new discipline
          String periodCode = assessment["codePeriode"];

          String disciplineName = assessment["libelleMatiere"];
          String disciplineCode = assessment["codeMatiere"];

          List<String> subdisciplineCodes = [];
          if (assessment["codeSousMatiere"] != null) subdisciplineCodes.add(assessment["codeSousMatiere"]);

          List<String> subdisciplineNames = [];
          if (assessment["libelleSousMatiere"] != null) subdisciplineNames.add(assessment["libelleSousMatiere"]);

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

            //We remove duplicates
            competencesDisciplinesList
                .firstWhere((element) =>
                    element.periodCode == competencesDiscipline.periodCode &&
                    element.disciplineCode == competencesDiscipline.disciplineCode)
                .subdisciplineCodes = (competencesDisciplinesList
                        .firstWhere((element) =>
                            element.periodCode == competencesDiscipline.periodCode &&
                            element.disciplineCode == competencesDiscipline.disciplineCode)
                        .subdisciplineCodes ??
                    [])
                .toSet()
                .toList();
            //We add all subdisciplineNames
            competencesDisciplinesList
                .firstWhere((element) =>
                    element.periodCode == competencesDiscipline.periodCode &&
                    element.disciplineCode == competencesDiscipline.disciplineCode)
                .subdisciplineNames
                ?.addAll(competencesDiscipline.subdisciplineNames ?? []);

            //We remove duplicates
            competencesDisciplinesList
                .firstWhere((element) =>
                    element.periodCode == competencesDiscipline.periodCode &&
                    element.disciplineCode == competencesDiscipline.disciplineCode)
                .subdisciplineNames = (competencesDisciplinesList
                        .firstWhere((element) =>
                            element.periodCode == competencesDiscipline.periodCode &&
                            element.disciplineCode == competencesDiscipline.disciplineCode)
                        .subdisciplineNames ??
                    [])
                .toSet()
                .toList();
          } else {
            competencesDisciplinesList.add(competencesDiscipline);
          }
        }
      });
      return _associatePeriods(competencesDisciplinesList, periodes);
    } else {
      return [];
    }
  }

  static List<CompetencesDiscipline> _associatePeriods(List<CompetencesDiscipline> disciplines, List? periodesData) {
    List<Period> periods = [];
    periodesData?.forEach((period) {
      periods.add(Period(period["periode"], period["codePeriode"]));
    });

    disciplines.forEach((discipline) {
      discipline.periodName = periods.firstWhere((element) => element.id == discipline.periodCode).name ?? "";
    });
    return disciplines;
  }

  static List<Competence> _competences(List competencesData, Map settings) {
    List<Competence> competences = [];
    competencesData.forEach((competence) {
      String domainName = competence["libelleCompetence"] ?? "";
      String domainId = competence["idCompetence"].toString();
      String itemName = competence["descriptif"] ?? "";
      String itemId = competence["idElemProg"].toString();
      CompetenceDomain domain = CompetenceDomain(name: domainName, id: domainId);
      CompetenceItem item = CompetenceItem(name: itemName, id: itemId);
      Competence _competence = Competence(
          domain: domain,
          item: item,
          level: _level(settings, competence["valeur"]),
          levelLabel: _level(settings, competence["valeur"]).name);
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
