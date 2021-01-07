import 'dart:convert';

import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/apis/Pronote/PronoteCas.dart';
import 'package:ynotes/apis/utils.dart';

import '../../classes.dart';

class EcoleDirecteConverter {
  static Mail mail(Map<String, dynamic> mailData) {
    var to = mailData["to"];
    String id = mailData["id"].toString() ?? "";
    String messageType = mailData["mtype"] ?? "";
    bool isMailRead = mailData["read"] ?? false;
    String idClasseur = mailData["idClasseur"].toString() ?? null;
    Map from = mailData["from"] ?? "";
    String subject = mailData["subject"] ?? "";
    String date = mailData["date"];

    String loadedContent = "";
    List<Map<String, dynamic>> filesData =
        mailData["files"].cast<Map<String, dynamic>>();
    List<Document> files = documents(filesData);
    Mail mail = Mail(
        id, messageType, isMailRead, idClasseur, from, subject, date,
        to: to, files: files);
    return mail;
  }

//Returns discipline with grades
  static List<Discipline> disciplines(Map<String, dynamic> disciplinesData) {
    List<Discipline> disciplinesList = List();
    List periodes = disciplinesData['data']['periodes'];
    List gradesData = disciplinesData['data']['notes'];
    Map<String, dynamic> settings = disciplinesData['data']['parametrage'];

    periodes.forEach((periodeElement) {
      Color color = Colors.green;
      //Make a list of grades

      List disciplines = periodeElement["ensembleMatieres"]["disciplines"];
      disciplines.forEach((rawData) {
        List profs = rawData['professeurs'];
        final List<String> teachersNames = List<String>();

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
              moyenneClasse: periodeElement["ensembleMatieres"]
                  ["moyenneClasse"],
              color: Colors.blue,
              showrank: settings["moyenneRang"] ? true : false,
              effectifClasse: periodeElement["ensembleMatieres"]["effectif"],
              rangGeneral: settings["moyenneRang"]
                  ? periodeElement["ensembleMatieres"]["rang"]
                  : null));
        }
        //Sub discipline
        else {
          try {
            disciplinesList[disciplinesList.lastIndexWhere((disciplinesList) =>
                    disciplinesList.codeMatiere == rawData['codeMatiere'] &&
                    disciplinesList.periode == periodeElement["periode"])]
                .codeSousMatiere
                .add(rawData['codeSousMatiere']);
          } catch (e) {
            print(e);
          }
        }
      });
      //Retrieve related grades for each discipline
      disciplinesList.forEach((discipline) {
        if (discipline.periode == periodeElement["periode"]) {
          final List<Grade> localGradesList = List<Grade>();

          gradesData.forEach((element) {
            if (element["codeMatiere"] == discipline.codeMatiere &&
                element["codePeriode"] == periodeElement["idPeriode"]) {
              String nomPeriode = periodeElement["periode"];
              localGradesList
                  .add(Grade.fromEcoleDirecteJson(element, nomPeriode));
            }
          });

          discipline.gradesList = localGradesList;
        }
      });
    });

    return disciplinesList;
  }

  static List<Period> periods(Map<String, dynamic> periodsData) {
    List rawPeriods = periodsData['data']['periodes'];
    List<Period> periods = List();
    rawPeriods.forEach((element) {
      periods.add(Period(element["periode"], element["idPeriode"]));
    });
    return periods;
  }

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

        unloadedHWList.add(Homework(
            matiere,
            codeMatiere,
            id,
            null,
            null,
            date,
            null,
            done,
            rendreEnLigne,
            interrogation,
            null,
            null,
            null,
            loaded));
      });
    });
    return unloadedHWList;
  }

  static List<Homework> homework(Map<String, dynamic> hwData) {
    List rawData = hwData['data']['matieres'];
    List<Homework> homeworkList = List();
    rawData.forEach((homework) {
      if (homework['aFaire'] != null) {
        String encodedContent = "";
        String aFaireEncoded = "";
        bool rendreEnLigne = false;
        bool interrogation = false;
        List<Document> documentsAFaire = List<Document>();
        List<Document> documentsContenuDeCours = List<Document>();
        encodedContent = homework['aFaire']['contenu'];
        rendreEnLigne = homework['aFaire']['rendreEnLigne'];
        aFaireEncoded = homework['contenuDeSeance']['contenu'];
        var docs = homework['aFaire']['documents'];
        if (docs != null) {
          documentsAFaire = documents(docs);
        }
        var docsContenu = homework['contenuDeSeance']['documents'];
        if (docsContenu != null) {
          docsContenu.forEach((e) {
            documentsContenuDeCours = documents(docsContenu);
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
            new RegExp(r'(>|\s)+(https?.+?)(<|\s)',
                multiLine: true, caseSensitive: false), (match) {
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
    });
    return homeworkList;
  }

  static Future<List<Lesson>> lessons(Map<String, dynamic> lessonData) async {
    List<Lesson> lessons = List();
    await Future.forEach(lessonData["data"], (lesson) async {
      String room = lesson["salle"].toString();
      List<String> teachers = [lesson["prof"]];
      DateTime start =
          DateFormat("yyyy-MM-dd HH:mm").parse(lesson["start_date"]);
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
          matiere: matiere,
          codeMatiere: codeMatiere,
          id: (await getLessonID(start, end, matiere)).toString());
      lessons.add(parsedLesson);
    });

    return lessons;
  }

  static List<Document> documents(var filesData) {
    List<Document> documents = List();
    filesData.forEach((fileData) {
      String libelle = fileData["libelle"];
      String id = fileData["id"].toString();
      String type = fileData["type"];

      ///TO DO : replace length
      int length = 0;
      documents.add(Document(libelle, id, type, length));
    });
    return documents;
  }

  static List<CloudItem> cloudFolders(var cloudFoldersData) {
    List<CloudItem> cloudFolders = List();
    cloudFoldersData["data"].forEach((folderData) {
      String date = folderData["creeLe"];
      try {
        var split = date.split(" ");
        date = split[0];
      } catch (e) {}
      String title = folderData["titre"];
      String elementType = "FOLDER";
      String author = folderData["creePar"];
      bool isRootDir = true;
      bool isMemberOf = folderData["estMembre"];
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

  static List<Recipient> recipients(var recipientsData) {
    List<Recipient> recipients = List();
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
}
