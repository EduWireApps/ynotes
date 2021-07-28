import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/models_exporter.dart';

class WorkspacesController extends ChangeNotifier {
  API? _api;

  bool loading = false;
  List<Workspace>? workspaces;
  List<CloudItem>? items;
  String path = "/";
  String? cloudUsedFolder = "";
  WorkspacesController(API? api) {
    _api = api;
  }
  set api(API? api) {
    _api = api;
  }

  back() {
    if (path != "/") {
      var splits = path.split("/");
      print(splits.length);
      if (splits.length > 2) {
        var finalList = splits.sublist(1, splits.length - 2);
        var concatenate = StringBuffer();

        finalList.forEach((item) {
          concatenate.write(r'/' + item);
        });
        print(concatenate);

        path = concatenate.toString() + '/';
      } else {
        path = "/";
      }
    }
    notifyListeners();
  }

  Future<void> changeFolder(CloudItem clicked) async {
    //Update path
    if (clicked.type == "FOLDER") {
      if (path == "/") {
        cloudUsedFolder = clicked.id;
      }
      path += clicked.title! + "/";
    }
    notifyListeners();
  }

  Future<void> refresh({bool force = false}) async {
    print("Refresh workspaces");
    loading = true;
    notifyListeners();
    try {
      workspaces = await (_api as APIEcoleDirecte).getWorkspaces();
      notifyListeners();
    } catch (e) {
      print(e);
      loading = false;
      notifyListeners();
    }
    loading = false;
    notifyListeners();
  }
}
