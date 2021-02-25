import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/services/shared_preferences.dart';
import 'package:ynotes/usefulMethods.dart';

class SchoolLifeController extends ChangeNotifier {
  final api;
  API _api;

  List<SchoolLifeTicket> abscences;
  List<SchoolLifeTicket> retards;
  List<SchoolLifeTicket> abscences_cantine;

  SchoolLifeController(this.api) {
    _api = api;
  }
}
