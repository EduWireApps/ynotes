import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/competences/model.dart';

final Map<String, CompetenceLevel> competencesLevels = {
  "verySatisfying": CompetenceLevel(name: "Très satisfaisant", defaultColor: Colors.red),
  "satisfying": CompetenceLevel(name: "Satisfaisant", defaultColor: Colors.red),
  "almostAcquired": CompetenceLevel(name: "Presque acquis", defaultColor: Colors.red),
  "fragile": CompetenceLevel(name: "Maîtrise fragile", defaultColor: Colors.blue),
  "commencement": CompetenceLevel(name: "Début de maîtrise", defaultColor: Colors.red),
  "insufficient": CompetenceLevel(name: "Maîtrise insuffisante", defaultColor: Colors.red),
};
