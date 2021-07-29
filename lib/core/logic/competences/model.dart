import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/competences/levels.dart';

final CompetenceLevels levels = CompetenceLevels(
  verySatisfying: competencesLevels["verySatisfying"]!,
  almostAcquired: competencesLevels["almostAcquired"]!,
  fragile: competencesLevels["fragile"]!,
  satisfying: competencesLevels["satisfying"]!,
  commencement: competencesLevels["commencement"]!,
  insufficient: competencesLevels["insufficient"]!,
);

class Assessment {
  ///The date of the assessment
  final DateTime assessmentDate;

  ///The competences evaluated
  final List<Competence> competences;
  Assessment({required this.assessmentDate, required this.competences});
}

class Competence {
  ///E.G "Très satisfaisant"
  final String levelLabel;

  ///E.G "Très satisfaisant"
  final CompetenceLevel level;
  final CompetenceItem item;
  final CompetenceDomain? domain;
  final CompetencePillar? pillar;

  Competence({required this.levelLabel, required this.level, required this.item, this.domain, this.pillar});
}

class CompetenceDomain {
  final String? name;
  final String? id;
  CompetenceDomain({this.name, this.id});
}

class CompetenceItem {
  final String? name;
  final String? id;

  CompetenceItem({this.name, this.id});
}

class CompetenceLevel {
  final String name;
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

class CompetencePillar {
  final String? name;
  final String? id;

  CompetencePillar({this.name, this.id});
}
