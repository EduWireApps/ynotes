import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/models.dart';

class EcoleDirecteConverter {
  static List<CloudItem> cloudFolders(var cloudFoldersData) {
    List<CloudItem> cloudFolders = [];
    cloudFoldersData["data"].forEach((folderData) {
      String? date = folderData["creeLe"];
      try {
        var split = date?.split(" ");
        date = split?[0];
      } catch (e) {}
      String? title = folderData["titre"];
      String elementType = "FOLDER";
      String? author = folderData["creePar"];
      bool isRootDir = true;
      bool? isMemberOf = folderData["estMembre"];
      String id = folderData["id"].toString();
      cloudFolders.add(CloudItem(
        title,
        elementType,
        author,
        isRootDir,
        date,
        isMemberOf: isMemberOf,
        id: id,
      ));
    });
    return cloudFolders;
  }

//Returns discipline with grades
  static List<Discipline> disciplines(Map<String, dynamic> disciplinesData) {
    List<Discipline> disciplinesList = [];
    List periodes = disciplinesData['data']['periodes'];
    List? gradesData = disciplinesData['data']['notes'];
    Map<String, dynamic>? settings = disciplinesData['data']['parametrage'];

    periodes.forEach((periodeElement) {
      try {
        //Make a list of grades

        List disciplines = periodeElement["ensembleMatieres"]["disciplines"];
        disciplines.forEach((rawData) {
          List profs = rawData['professeurs'];
          List<String?> teachersNames = [];

          profs.forEach((e) {
            teachersNames.add(e["nom"]);
          });
          //No one sub discipline
          if (rawData['codeSousMatiere'] == "") {
            disciplinesList.add(Discipline.fromEcoleDirecteJson(
                json: rawData,
                profs: teachersNames,
                periode: periodeElement["periode"],
                moyenneG: periodeElement["ensembleMatieres"]["moyenneGenerale"],
                bmoyenneClasse: periodeElement["ensembleMatieres"]["moyenneMax"],
                moyenneClasse: periodeElement["ensembleMatieres"]["moyenneClasse"],
                color: Colors.blue,
                showrank: settings!["moyenneRang"] ?? false,
                effectifClasse: periodeElement["ensembleMatieres"]["effectif"],
                rangGeneral: (settings["moyenneRang"] ?? false) ? periodeElement["ensembleMatieres"]["rang"] : null));
          }
          //Sub discipline
          else {
            try {
              disciplinesList[disciplinesList.lastIndexWhere((disciplinesList) =>
                      disciplinesList.disciplineCode == rawData['codeMatiere'] &&
                      disciplinesList.period == periodeElement["periode"])]
                  .subdisciplineCode!
                  .add(rawData['codeSousMatiere']);
            } catch (e) {
              print(e);
            }
          }
        });
        //Retrieve related grades for each discipline
        disciplinesList.forEach((discipline) {
          if (discipline.period == periodeElement["periode"]) {
            List<Grade> localGradesList = [];

            gradesData!.forEach((element) {
              if (element["codeMatiere"] == discipline.disciplineCode &&
                  element["codePeriode"] == periodeElement["idPeriode"]) {
                String? nomPeriode = periodeElement["periode"];
                localGradesList.add(Grade.fromEcoleDirecteJson(element, nomPeriode));
              }
            });

            discipline.gradesList = localGradesList;
          }
        });
      } catch (e) {
        print(e);
      }
    });
    return disciplinesList;
  }

  static List<Document> documents(var filesData) {
    List<Document> documents = [];
    filesData.forEach((fileData) {
      String? libelle = fileData["libelle"];
      String id = fileData["id"].toString();
      String? type = fileData["type"];

      ///TO DO : replace length
      int length = 0;
      documents.add(Document(libelle, id, type, length));
    });
    return documents;
  }

  static List<Homework> homework(Map<String, dynamic> hwData) {
    List rawData = hwData['data']['matieres'];
    List<Homework> homeworkList = [];
    rawData.forEach((homework) {
      try {
        if (homework['aFaire'] != null) {
          String? encodedContent = "";
          String? aFaireEncoded = "";
          bool? rendreEnLigne = false;
          bool? interrogation = false;
          List<Document> documentsAFaire = [];
          List<Document> documentsContenuDeCours = [];
          encodedContent = homework['aFaire']['contenu'];
          rendreEnLigne = homework['aFaire']['rendreEnLigne'];
          aFaireEncoded = homework['aFaire']['contenuDeSeance']['contenu'];
          var docs = homework['aFaire']['documents'];
          if (docs != null) {
            documentsAFaire = documents(docs);
          }
          var docsContenu = homework['aFaire']['contenuDeSeance']['documents'];
          if (docsContenu != null) {
            docsContenu.forEach((e) {
              documentsContenuDeCours = documents(docsContenu);
            });
          }
          interrogation = homework['interrogation'];
          String decodedContent = "";
          String decodedContenuDeSeance = "";
          decodedContent = utf8.decode(base64.decode(encodedContent!));
          decodedContenuDeSeance = utf8.decode(base64.decode(aFaireEncoded!));
          String? matiere = homework['matiere'];
          String? codeMatiere = homework['codeMatiere'];
          String id = homework['id'].toString();

          decodedContent = decodedContent.replaceAllMapped(
              new RegExp(r'(>|\s)+(https?.+?)(<|\s)', multiLine: true, caseSensitive: false), (match) {
            return '${match.group(1)}<a href="${match.group(2)}">${match.group(2)}</a>${match.group(3)}';
          });

          DateTime editingDate = DateTime.parse(homework['aFaire']['donneLe']);
          bool done = homework['aFaire']['effectue'] == 'true';
          String? teacherName = homework['nomProf'];
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

  static List<DateTime> homeworkDates(Map<String, dynamic> hwDatesData) {
    Map<String, dynamic> datesData = hwDatesData['data'];
    List<DateTime> dates = [];
    datesData.forEach((key, value) {
      dates.add(DateTime.parse(key));
    });
    return dates;
  }

  static Future<List<Lesson>> lessons(Map<String, dynamic> lessonData) async {
    List<Lesson> lessons = [];
    await Future.forEach(lessonData["data"], (dynamic lesson) async {
      String room = lesson["salle"].toString();
      List<String?> teachers = [lesson["prof"]];
      DateTime start = DateFormat("yyyy-MM-dd HH:mm").parse(lesson["start_date"]);
      DateTime end = DateFormat("yyyy-MM-dd HH:mm").parse(lesson["end_date"]);
      bool canceled = lesson["isAnnule"] == true;
      String matiere = lesson["matiere"];
      String codeMatiere = lesson["codeMatiere"].toString();
      Lesson parsedLesson = Lesson(
          room: room,
          teachers: teachers,
          start: start,
          end: end,
          canceled: canceled,
          discipline: matiere,
          disciplineCode: codeMatiere,
          id: (await getLessonID(start, end, matiere)).toString());
      lessons.add(parsedLesson);
    });

    return lessons;
  }

  static Mail mail(Map<String, dynamic> mailData) {
    var to = mailData["to"];
    String id = mailData["id"].toString();
    String messageType = mailData["mtype"] ?? "";
    bool isMailRead = mailData["read"] ?? false;
    String? idClasseur = mailData["idClasseur"].toString();
    Map from = mailData["from"] ?? "" as Map<dynamic, dynamic>;
    String subject = mailData["subject"] ?? "";
    String? date = mailData["date"];
    String loadedContent = "";
    List<Map<String, dynamic>> filesData = mailData["files"].cast<Map<String, dynamic>>();
    List<Document> files = documents(filesData);
    Mail mail = Mail(id, messageType, isMailRead, idClasseur, from as Map<String, dynamic>, subject, date,
        to: to, files: files);
    return mail;
  }

  static List<Period> periods(Map<String, dynamic> periodsData) {
    List rawPeriods = periodsData['data']['periodes'];
    List<Period> periods = [];
    rawPeriods.forEach((element) {
      periods.add(Period(element["periode"], element["idPeriode"]));
    });
    return periods;
  }

  static List<Recipient> recipients(var recipientsData) {
    List<Recipient> recipients = [];
    recipientsData["data"]["contacts"].forEach((recipientData) {
      String id = recipientData["id"].toString();
      String name = recipientData["prenom"].toString();
      bool isTeacher = recipientData["type"] == "P";
      String surname = recipientData["nom"].toString();
      String discipline = recipientData["classes"][0]["matiere"].toString();
      recipients.add(Recipient(name, surname, id, isTeacher, discipline));
    });
    return recipients;
  }

  static List<SchoolLifeTicket> schoolLife(Map<String, dynamic> schoolLifeData) {
    List rawschoolLife = schoolLifeData['data']['abscencesRetards'];
    List<SchoolLifeTicket> schoolLifeList = [];
    rawschoolLife.forEach((element) {
      String? libelle = element["libelle"];
      String? displayDate = element["displayDate"];
      String? motif = element["motif"];
      String? type = element["typeElement"];
      bool? isJustified = element["justifie"];
      schoolLifeList.add(SchoolLifeTicket(libelle, displayDate, motif, type, isJustified));
    });
    return schoolLifeList;
  }

  static List<Homework> unloadedHomework(Map<String, dynamic> uhwData) {
    Map<String, dynamic> hwData = uhwData['data'];
    List<Homework> unloadedHWList = [];
    hwData.forEach((key, value) {
      value.forEach((var hw) {
        Map mappedHomework = hw;
        bool loaded = false;
        String? matiere = mappedHomework["matiere"];
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
}
