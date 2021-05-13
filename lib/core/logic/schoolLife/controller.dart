import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/usefulMethods.dart';

class SchoolLifeController extends ChangeNotifier {
  final api;
  API? _api;

  List<SchoolLifeTicket>? abscences;
  List<SchoolLifeTicket>? retards;
  List<SchoolLifeTicket>? abscences_cantine;

  List<SchoolLifeTicket>? tickets_list;

  SchoolLifeController(this.api) {
    _api = api;
  }

  Future<void> refresh({bool force = false, refreshFromOffline = false}) async {
    print("Refresh school_life tickets");
    notifyListeners();

    if (refreshFromOffline) {
      tickets_list = await _api!.getSchoolLife();
      notifyListeners();
    } else {
      tickets_list = await _api!.getSchoolLife();
      notifyListeners();
    }

    print(tickets_list);
    notifyListeners();
  }
}
