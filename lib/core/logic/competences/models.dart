import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/competences/levels.dart';

final CompetenceLevels levels = CompetenceLevels(
  verySatisfying: competencesLevels["verySatisfying"]!,
  almostAcquired: competencesLevels["almostAcquired"]!,
  fragile: competencesLevels["fragile"]!,
  satisfying: competencesLevels["satisfying"]!,
  commencement: competencesLevels["commencement"]!,
  insufficient: competencesLevels["insufficient"]!,
);




@HiveType(typeId: 21)
class Assessment {
  @HiveField(0)

  ///The date of the assessment
  final DateTime assessmentDate;
  @HiveField(1)

  ///The competences evaluated
  final List<Competence> competences;
  Assessment({required this.assessmentDate, required this.competences});
}

@HiveType(typeId: 20)
class Competence {
  @HiveField(0)

  ///E.G "Très satisfaisant"
  final String levelLabel;
  @HiveField(1)

  ///E.G "Très satisfaisant"
  final CompetenceLevel level;
  @HiveField(2)
  final CompetenceItem item;
  @HiveField(3)
  final CompetenceDomain? domain;
  @HiveField(4)

  ///NB Doesn't exist for ED
  final CompetencePillar? pillar;

  Competence({required this.levelLabel, required this.level, required this.item, this.domain, this.pillar});
}

@HiveType(typeId: 19)
class CompetenceDomain {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? id;
  CompetenceDomain({this.name, this.id});
}

@HiveType(typeId: 18)
class CompetenceItem {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? id;

  CompetenceItem({this.name, this.id});
}

@HiveType(typeId: 17)
class CompetenceLevel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final Color defaultColor;
  CompetenceLevel({required this.name, required this.defaultColor});
}

class CompetenceLevels {
  final CompetenceLevel verySatisfying;
  final CompetenceLevel satisfying;
  final CompetenceLevel almostAcquired;
  final CompetenceLevel fragile;
  final CompetenceLevel commencement;
  final CompetenceLevel insufficient;
  CompetenceLevels(
      {required this.verySatisfying,
      required this.satisfying,
      required this.almostAcquired,
      required this.fragile,
      required this.commencement,
      required this.insufficient});
}

@HiveType(typeId: 16)
class CompetencePillar {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? id;

  CompetencePillar({this.name, this.id});
}

@HiveType(typeId: 15)
class CompetencesDiscipline {
  @HiveField(0)
  final String disciplineName;
  @HiveField(1)
  final String? disciplineCode;
  @HiveField(2)
  final List<String?>? subdisciplineCodes;
  @HiveField(4)
  final List<String?>? subdisciplineNames;
  @HiveField(5)
  final String periodCode;
  @HiveField(6)
  final String periodName;
  @HiveField(7)
  final List<String?>? teachers;
  @HiveField(8)
  Color? color;
  @HiveField(9)
  final List<Assessment>? assessmentsList;

  CompetencesDiscipline(
      {required this.disciplineName,
      this.disciplineCode,
      this.subdisciplineCodes,
      this.subdisciplineNames,
      required this.periodCode,
      required this.periodName,
      this.teachers,
      this.color,
      this.assessmentsList});
}
