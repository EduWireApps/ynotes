import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/apis/Pronote/convertersExporter.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';

class PronoteHomeworkConverter {
  static List<Homework> homework(PronoteClient client, Map homeworkData) {
    List<Homework> hwList = List();
    List data = mapGet(homeworkData, ['donneesSec', 'donnees', 'ListeTravauxAFaire', 'V']) ?? [];
    data.forEach((singleHomeworkData) {
      String discipline = mapGet(singleHomeworkData, ["Matiere", "V", "L"]);
      String disciplineCode = mapGet(singleHomeworkData, ["Matiere", "V", "L"]).hashCode.toString();
      String id = DateFormat("dd/MM/yyyy").parse(singleHomeworkData["PourLe"]["V"]).toString() +
          disciplineCode +
          mapGet(singleHomeworkData, ["descriptif", "V"]).hashCode.toString();
      String rawContent = mapGet(singleHomeworkData, ["descriptif", "V"]);
      String sessionRawContent = null;
      DateTime date =  DateFormat("dd/MM/yyyy").parse(singleHomeworkData["PourLe"]["V"]);
      DateTime entryDate =  DateFormat("dd/MM/yyyy").parse(singleHomeworkData["DonneLe"]["V"]);
      bool done = false;
      bool toReturn = false;
      bool isATest = false;
                      print("a");

      List<Document> documents = PronoteDocumentConverter.documents(mapGet(singleHomeworkData, ["ListePieceJointe", "V"]));
      List<Document> sessionDocuments = [];
      String teacherName = "";
      bool loaded = true;
                      print("dfs");

      hwList.add(Homework(discipline, disciplineCode, id, rawContent, sessionRawContent, date, entryDate, done,
          toReturn, isATest, documents, sessionDocuments, teacherName, loaded));
                print("ended");

    });
    return hwList;
  }
}
