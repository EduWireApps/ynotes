import 'dart:convert';

import 'package:ynotes/core/apis/EcoleDirecte/convertersExporter.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

class EcoleDirecteHomeworkConverter {
  static List<DateTime> homeworkDates(Map<String, dynamic> hwDatesData) {
    Map<String, dynamic> datesData = hwDatesData['data'];
    List<DateTime> dates = List();
    datesData.forEach((key, value) {
      dates.add(DateTime.parse(key));
    });
    return dates;
  }

  static List<Homework> unloadedHomework(Map<String, dynamic> uhwData) {
    Map<String, dynamic> hwData = uhwData['data'];
    List<Homework> unloadedHWList = List();
    hwData.forEach((key, value) {
      value.forEach((var hw) {
        Map mappedHomework = hw;
        bool loaded = false;
        String matiere = mappedHomework["matiere"];
        String codeMatiere = mappedHomework["codeMatiere"].toString();
        String id = mappedHomework["idDevoir"].toString();
        DateTime date = DateTime.parse(key);
        DateTime datePost = DateTime.parse(mappedHomework["donneLe"]);
        bool done = mappedHomework["effectue"] == "true";
        bool rendreEnLigne = mappedHomework["rendreEnLigne"] == "true";
        bool interrogation = mappedHomework["interrogation"] == "true";

        unloadedHWList.add(Homework(matiere, codeMatiere, id, null, null, date, null, done, rendreEnLigne,
            interrogation, null, null, null, loaded));
      });
    });
    return unloadedHWList;
  }

  static List<Homework> homework(Map<String, dynamic> hwData) {
    List rawData = hwData['data']['matieres'];
    List<Homework> homeworkList = List();
    rawData.forEach((homework) {
      try {
        if (homework['aFaire'] != null) {
          String encodedContent = "";
          String aFaireEncoded = "";
          bool rendreEnLigne = false;
          bool interrogation = false;
          List<Document> documentsAFaire = List<Document>();
          List<Document> documentsContenuDeCours = List<Document>();
          encodedContent = homework['aFaire']['contenu'];
          rendreEnLigne = homework['aFaire']['rendreEnLigne'];
          aFaireEncoded = homework['aFaire']['contenuDeSeance']['contenu'];
          var docs = homework['aFaire']['documents'];
          if (docs != null) {
            documentsAFaire = EcoleDirecteDocumentConverter.documents(docs);
          }
          var docsContenu = homework['aFaire']['contenuDeSeance']['documents'];
          if (docsContenu != null) {
            docsContenu.forEach((e) {
              documentsContenuDeCours = EcoleDirecteDocumentConverter.documents(docsContenu);
            });
          }
          interrogation = homework['interrogation'];
          String decodedContent = "";
          String decodedContenuDeSeance = "";
          decodedContent = utf8.decode(base64.decode(encodedContent));
          decodedContenuDeSeance = utf8.decode(base64.decode(aFaireEncoded));
          String matiere = homework['matiere'];
          String codeMatiere = homework['codeMatiere'];
          String id = homework['id'].toString();

          decodedContent = decodedContent.replaceAllMapped(
              new RegExp(r'(>|\s)+(https?.+?)(<|\s)', multiLine: true, caseSensitive: false), (match) {
            return '${match.group(1)}<a href="${match.group(2)}">${match.group(2)}</a>${match.group(3)}';
          });

          DateTime editingDate = DateTime.parse(homework['aFaire']['donneLe']);
          bool done = homework['aFaire']['effectue'] == 'true';
          String teacherName = homework['nomProf'];
          homeworkList.add(new Homework(
              matiere,
              codeMatiere,
              id,
              decodedContent,
              decodedContenuDeSeance,
              null,
              editingDate,
              done,
              rendreEnLigne,
              interrogation,
              documentsAFaire,
              documentsContenuDeCours,
              teacherName,
              true));
        }
      } catch (e) {
        print(e.toString());
      }
    });
    return homeworkList;
  }
}
