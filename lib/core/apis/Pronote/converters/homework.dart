import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';

class PronoteHomeworkConverter {
  static List<Homework> homework(PronoteClient client, Map homeworkData) {
    List data = mapGet(homeworkData, ['donneesSec', 'donnees', 'ListeCahierDeTextes', 'V']) ?? [];
    data.forEach((singleHomeworkData) {
      String discipline = mapGet(singleHomeworkData, ["Matiere", "V", "L"]);
      String disciplineCode = mapGet(singleHomeworkData, ["Matiere", "V", "L"]).hashCode.toString();
      String id = DateFormat("dd/MM/yyyy").parse(singleHomeworkData["PourLe"]["V"]).toString() +
          disciplineCode +
          mapGet(singleHomeworkData, ["descriptif", "V"]).hashCode.toString();

      String rawContent = mapGet(singleHomeworkData, ["descriptif", "V"]);
      String sessionRawContent = null;
      DateTime date;
      DateTime entryDate;
      bool done;
      bool toReturn;
      bool isATest;
      List<Document> documents;
      List<Document> sessionDocuments;
      String teacherName;
      bool loaded;
    });
  }
}
