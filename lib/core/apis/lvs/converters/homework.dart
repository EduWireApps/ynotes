import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/models_exporter.dart';

class LvsHomeworkConverter {
  static List<Homework> homework(hwsData) {
    List hws = json.decode(hwsData);

    List<Homework> hwList = [];
    hws.forEach((hw) {
      String discipline = hw['subject'];
      DateTime date = DateFormat('yyyy-MM-dd').parse(hw['start_date']);
      bool done = false;
      String teacherName = hw['text'];
      hw['activitesData'].forEach((hwContent) {
        String id = hwContent['id'].toString();
        String rawContent = hwContent['description'];
        bool toReturn = false;
        bool isATest = false;
        bool loaded = true;

        if (['SURV', 'EVAL', 'PSURV'].contains(hwContent['code'])) {
          isATest = true;
        }

        hwList.add(Homework(
          discipline: discipline,
          id: id,
          rawContent: rawContent,
          date: date,
          done: done,
          toReturn: toReturn,
          teacherName: teacherName,
          loaded: loaded,
          isATest: isATest,
        ));
      });
    });
    return hwList;
  }

  static get_af(List af, hw_client) {
    var text = '';
    List<Document> docs = [];
    if (!af.isEmpty) {
      text = text + '<br /><br /><strong>Pièces jointes</strong>: <br /><br />';
      af.forEach((file) {
        var f_url = file['url'];
        docs.add(Document(
            documentName: file['nom'],
            id: f_url.substring(
                f_url.lastIndexOf('fichierId=') + 'fichierId='.length)));
      });
    }
    print(docs);
    return docs;
  }
}
