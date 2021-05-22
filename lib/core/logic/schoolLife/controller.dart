import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

class SchoolLifeController extends ChangeNotifier {
  final api;
  API? _api;

  bool loading = false;
  List<SchoolLifeTicket>? tickets;

  SchoolLifeController(this.api) {
    _api = api;
  }

  Future<void> refresh({bool force = false}) async {
    print("Refresh schoolLife tickets");
    loading = true;
    notifyListeners();
    try {
      tickets = await _api!.getSchoolLife(forceReload: force);
      notifyListeners();
    } catch (e) {
      print(e);
      loading = false;
    }
    loading = false;
    notifyListeners();
  }
}
