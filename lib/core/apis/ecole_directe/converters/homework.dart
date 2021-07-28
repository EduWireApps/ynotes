import 'dart:convert';

import 'package:ynotes/core/apis/ecole_directe/converters_exporter.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils.dart';

class EcoleDirecteHomeworkConverter {
  static List<Homework> homework(Map<String, dynamic> hwData) {
    List rawData = hwData['data']['matieres'];
    List<Homework> homeworkList = [];
    rawData.forEach((homework) {
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
            documents = EcoleDirecteDocumentConverter.documents(docs);
          }
          var docsContenu = homework['aFaire']['contenuDeSeance']['documents'];
          if (docsContenu != null) {
            docsContenu.forEach((e) {
              sessionFiles = EcoleDirecteDocumentConverter.documents(docsContenu);
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
              new RegExp(r'(>|\s)+(https?.+?)(<|\s)', multiLine: true, caseSensitive: false), (match) {
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
        CustomLogger.error(e);
      }
    });
    return homeworkList;
  }

  static List<DateTime> homeworkDates(Map<String, dynamic> hwDatesData) {
    Map<String, dynamic> datesData = hwDatesData['data'];
    List<DateTime> dates = [];
    datesData.forEach((key, value) {
      dates.add(DateTime.parse(key));
    });
    return dates;
  }

  static List<Homework> unloadedHomework(Map<String, dynamic> uhwData) {
    Map<String, dynamic> hwData = uhwData['data'];

    List<Homework> unloadedHWList = [];
            CustomLogger.log("test", "a");

    hwData.forEach((key, value) {

      value.forEach((var hw) {

        Map mappedHomework = hw;
        bool loaded = false;
        CustomLogger.log("test", "b");
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
  }
}
