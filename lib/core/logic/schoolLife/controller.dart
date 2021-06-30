import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/loggingUtils.dart';

class SchoolLifeController extends ChangeNotifier {
  API? _api;

  bool loading = false;
  List<SchoolLifeTicket>? tickets;

  SchoolLifeController(API? api) {
    _api = api;
  }
  set api(API? api) {
    _api = api;
  }

  Future<void> refresh({bool force = false}) async {
    CustomLogger.log("SCHOOL LIFE", "Refresh tickets");
    loading = true;
    notifyListeners();
    try {
      tickets = await _api!.getSchoolLife(forceReload: force);
      notifyListeners();
    } catch (e) {
      CustomLogger.log("SCHOOL LIFE", "An error occured while refreshing");
      CustomLogger.error(e);
      loading = false;
      notifyListeners();
    }
    loading = false;
    notifyListeners();
  }
}
