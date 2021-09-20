import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/pronote/converters_exporter.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';

class PronoteHomeworkConverter {
  static List<Homework> homework(PronoteClient client, Map homeworkData) {
    List<Homework> hwList = [];
    List data = mapGet(homeworkData, ['donneesSec', 'donnees', 'ListeTravauxAFaire', 'V']) ?? [];
    for (var singleHomeworkData in data) {
      String discipline = mapGet(singleHomeworkData, ["Matiere", "V", "L"]);
      String disciplineCode = mapGet(singleHomeworkData, ["Matiere", "V", "L"]).hashCode.toString();
      String id = DateFormat("dd/MM/yyyy").parse(singleHomeworkData["PourLe"]["V"]).toString() +
          disciplineCode +
          mapGet(singleHomeworkData, ["descriptif", "V"]).hashCode.toString();
      String rawContent = mapGet(singleHomeworkData, ["descriptif", "V"]);
      String? sessionRawContent;
      DateTime date = DateFormat("dd/MM/yyyy").parse(singleHomeworkData["PourLe"]["V"]);
      DateTime entryDate = DateFormat("dd/MM/yyyy").parse(singleHomeworkData["DonneLe"]["V"]);
      bool done = false;
      bool toReturn = false;
      bool isATest = false;

      List<Document> documents =
          PronoteDocumentConverter.documents(mapGet(singleHomeworkData, ["ListePieceJointe", "V"]));

      List<Document> sessionFiles = [];
      String teacherName = "";
      bool loaded = true;

      Homework hw = Homework(
          discipline: discipline,
          disciplineCode: disciplineCode,
          id: id,
          rawContent: rawContent,
          sessionRawContent: sessionRawContent,
          date: date,
          entryDate: entryDate,
          done: done,
          toReturn: toReturn,
          isATest: isATest,
          teacherName: teacherName,
          loaded: loaded);
      hw.files.addAll(documents);
      hw.sessionFiles.addAll(sessionFiles);
      hwList.add(hw);
    }
    return hwList;
  }
}
