import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/models_exporter.dart';

class MailsController extends ChangeNotifier {
  API? _api;

  bool loading = false;
  List<Mail>? mails;

  MailsController(API? api) {
    _api = api;
  }

  set api(API? api) {
    _api = api;
  }

  Future<void> refresh({bool force = false}) async {
    print("Refresh mails");
    loading = true;
    notifyListeners();
    try {
      mails = await (_api as APIEcoleDirecte).getMails(forceReload: force);
      notifyListeners();
    } catch (e) {
      print(e);
      loading = false;
    }
    loading = false;
    notifyListeners();
  }
}
