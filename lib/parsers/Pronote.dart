import 'dart:ui';

import '../apiManager.dart';
import 'package:flutter/services.dart';

class APIPronote extends API {
  @override
  Future<List<DateTime>> getDatesNextHomework() {
    return Future.delayed(Duration(seconds: 0),
        () => throw "Pronote n'est pas encore implémenté");
  }

  @override
  Future<List<discipline>> getGrades({bool forceReload}) {
    return Future.delayed(Duration(seconds: 0),
        () => throw "Pronote n'est pas encore implémenté");
  }

  @override
  Future<List<homework>> getHomeworkFor(DateTime dateHomework) {
    return Future.delayed(Duration(seconds: 0),
        () => throw "Pronote n'est pas encore implémenté");
  }

  @override
  Future<List<homework>> getNextHomework({bool forceReload}) {
    return Future.delayed(Duration(seconds: 0),
        () => throw "Pronote n'est pas encore implémenté");
  }

  @override
  Future<String> login(username, password) async {}
  
  @override
  Future<bool> testNewGrades() async {

    return null;
  }

  @override
  Future app(String appname, {String args, String action, CloudItem folder}) {
    
    // TODO: implement app
    throw UnimplementedError();
  }

  @override
  Future uploadFile(String contexte, String id, String filepath) {
    // TODO: implement sendFile
    throw UnimplementedError();
  }
}
