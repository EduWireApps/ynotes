import 'dart:convert';

import 'package:ynotes/core/apis/ecole_directe/converters_exporter.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/anonymizer_utils.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class EcoleDirecteHomeworkConverter {
  static API_TYPE apiType = API_TYPE.ecoleDirecte;

  static YConverter homework = YConverter(
      apiType: apiType,
      logSlot: "Homework",
      anonymizer: (Map<dynamic, dynamic> accountData) {
        Map toAnonymize = {
          "nomProf": AnonymizerUtils.generateRandomString(8),
        };
        return AnonymizerUtils.severalValues(jsonEncode(accountData), toAnonymize);
      },
      converter: (Map<dynamic, dynamic> hwData) {
        List rawData = hwData['data']['matieres'];
        List<Homework> homeworkList = [];
        for (var homework in rawData) {
          try {
            if (homework['aFaire'] != null) {
              String encodedContent = "";
              String aFaireEncoded = "";
              bool toReturn = false;
              bool isATest = false;
              List<Document> documents = [];
              List<Document> sessionFiles = [];
              encodedContent = homework['aFaire']['contenu'];
              toReturn = homework['aFaire']['rendreEnLigne'];
              aFaireEncoded = homework['aFaire']['contenuDeSeance']['contenu'];
              var docs = homework['aFaire']['documents'];
              if (docs != null) {
                documents = EcoleDirecteDocumentConverter.documents.convert(docs);
              }
              var docsContenu = homework['aFaire']['contenuDeSeance']['documents'];
              if (docsContenu != null) {
                docsContenu.forEach((e) {
                  sessionFiles = EcoleDirecteDocumentConverter.documents.convert(docsContenu);
                });
              }
              isATest = homework['interrogation'];
              String rawContent = "";
              String sessionRawContent = "";
              rawContent = utf8.decode(base64.decode(encodedContent));
              sessionRawContent = utf8.decode(base64.decode(aFaireEncoded));
              String discipline = homework['matiere'];
              String disciplineCode = homework['codeMatiere'];
              String id = homework['id'].toString();

              rawContent = rawContent.replaceAllMapped(
                  RegExp(r'(>|\s)+(https?.+?)(<|\s)', multiLine: true, caseSensitive: false), (match) {
                return '${match.group(1)}<a href="${match.group(2)}">${match.group(2)}</a>${match.group(3)}';
              });

              DateTime entryDate = DateTime.parse(homework['aFaire']['donneLe']);
              bool done = false;
              String teacherName = homework['nomProf'];

              Homework hw = Homework(
                  discipline: discipline,
                  disciplineCode: disciplineCode,
                  id: id,
                  rawContent: rawContent,
                  sessionRawContent: sessionRawContent,
                  entryDate: entryDate,
                  done: done,
                  toReturn: toReturn,
                  isATest: isATest,
                  teacherName: teacherName,
                  loaded: true);
              hw.files.addAll(documents);
              hw.sessionFiles.addAll(sessionFiles);
              homeworkList.add(hw);
            }
          } catch (e) {
            CustomLogger.error(e, stackHint:"MjI=");
          }
        }
        return homeworkList;
      });

  static YConverter unloadedHomework = YConverter(
      apiType: apiType,
      converter: (Map<dynamic, dynamic> uhwData) {
        Map<String, dynamic> hwData = uhwData['data'];

        List<Homework> unloadedHWList = [];

        hwData.forEach((key, value) {
          value.forEach((var hw) {
            Map mappedHomework = hw;
            bool loaded = false;
            String discipline = mappedHomework["matiere"];
            String disciplineCode = mappedHomework["codeMatiere"].toString();
            String id = mappedHomework["idDevoir"].toString();
            DateTime date = DateTime.parse(key);
            DateTime entryDate = DateTime.parse(mappedHomework["donneLe"]);
            bool done = mappedHomework["effectue"] == "true";
            bool toReturn = mappedHomework["rendreEnLigne"] == "true";
            bool isATest = mappedHomework["interrogation"] == "true";

            unloadedHWList.add(Homework(
                discipline: discipline,
                disciplineCode: disciplineCode,
                id: id,
                date: date,
                entryDate: entryDate,
                done: done,
                toReturn: toReturn,
                isATest: isATest,
                loaded: loaded));
          });
        });
        return unloadedHWList;
      });

  static List<DateTime> homeworkDates(Map<String, dynamic> hwDatesData) {
    Map<String, dynamic> datesData = hwDatesData['data'];
    List<DateTime> dates = [];
    datesData.forEach((key, value) {
      dates.add(DateTime.parse(key));
    });
    return dates;
  }
}
