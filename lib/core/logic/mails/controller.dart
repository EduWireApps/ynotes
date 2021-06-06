import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/EcoleDirecte.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

class MailsController extends ChangeNotifier {
  final api;
  API? _api;

  bool loading = false;
  List<Mail>? mails;

  MailsController(this.api) {
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
