import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

class PronoteMethod {
  final PronoteClient client;
  final SchoolAccount account;

  PronoteMethod(this.client, this.account);

  accounts() {}

  lessons(DateTime dateToUse, int week) {}

  grades() {}

  nextHomework() async {
    
  }

  Future<List<Homework>> homeworkFor(DateTime date) async {
  }

  Future<List<CloudItem>> cloudFolders() async {

  }

  request(String functionName, {var data}) {}

  fetchAnyData()
  {}
}
