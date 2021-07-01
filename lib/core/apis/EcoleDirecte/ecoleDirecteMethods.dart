import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/EcoleDirecte/converters/workspaces.dart';
import 'package:ynotes/core/apis/EcoleDirecte/convertersExporter.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/data/agenda/lessons.dart';
import 'package:ynotes/core/offline/data/disciplines/disciplines.dart';
import 'package:ynotes/core/offline/data/homework/homework.dart';
import 'package:ynotes/core/offline/data/homework/pinnedHomework.dart';
import 'package:ynotes/core/offline/data/mails/mails.dart';
import 'package:ynotes/core/offline/data/mails/recipients.dart';
import 'package:ynotes/core/offline/data/schoolLife/schoolLife.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/loggingUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/usefulMethods.dart';

import '../EcoleDirecte.dart';

class EcoleDirecteMethod {
  static const fakeToken = "a95fd30b-ca20-467b-8128-679f48e1498e";
  Offline _offlineController;
  EcoleDirecteMethod(this._offlineController);
  Future<List<Workspace>> workspaces() async {
    await EcoleDirecteMethod.testToken();
    String rootUrl = 'https://api.ecoledirecte.com/v3/E/';
    String method = "espacestravail.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    List<Workspace> workspaces = await request(
        data, rootUrl, method, EcoleDirecteWorkspacesConverter.workspaces, "Workspaces request returned an error:");
    return workspaces;
  }

  Future<List<Discipline>> grades() async {
    await EcoleDirecteMethod.testToken();
    String rootUrl = "https://api.ecoledirecte.com/v3/Eleves/";
    /*if (kDebugMode) {
      rootUrl = "http://192.168.1.99:3000/posts/2";
    }*/
    String method = "notes.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    List<Discipline>? disciplinesList = await request(
      data,
      rootUrl,
      method,
      EcoleDirecteDisciplineConverter.disciplines,
      "Grades request returned an error:",
      /*ignoreMethodAndId: kDebugMode, getRequest: kDebugMode*/
    );

    //Update colors;
    disciplinesList = await refreshDisciplinesListColors(disciplinesList ?? []);

    await DisciplinesOffline(_offlineController).updateDisciplines(disciplinesList);

    createStack();

    appSys.settings.system.lastGradeCount = (getAllGrades(disciplinesList, overrideLimit: true) ?? []).length;
    appSys.saveSettings();

    return disciplinesList;
  }

  homeworkDates() async {
    await EcoleDirecteMethod.testToken();
    String rootUrl = 'https://api.ecoledirecte.com/v3/Eleves/';
    String method = "cahierdetexte.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    List<DateTime> homeworkDates = await request(data, rootUrl, method, EcoleDirecteHomeworkConverter.homeworkDates,
        "Homework dates request returned an error:");

    homeworkDates.removeWhere((date) =>
        DateFormat("yyyy-MM-dd")
            .parse(date.toString())
            .difference(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()))
            .inDays >
        7);
    //Get pinned dates
    List<DateTime> pinnedDates = await PinnedHomeworkOffline(appSys.offline).getPinnedHomeworkDates();
    //Combine lists
    pinnedDates.forEach((element) {
      if (!homeworkDates.any((hwlistelement) => hwlistelement == element)) {
        homeworkDates.add(element);
      }
    });

    return homeworkDates;
  }

  Future<List<Homework>?> homeworkFor(DateTime date) async {
    await EcoleDirecteMethod.testToken();
    String dateToUse = DateFormat("yyyy-MM-dd").format(date).toString();
    String rootUrl = 'https://api.ecoledirecte.com/v3/Eleves/';
    String method = "cahierdetexte/$dateToUse.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    /*if (kDebugMode) {
      rootUrl = 'https://still-earth-97911.herokuapp.com/ecoledirecte/homework/' + dateToUse;
      method = "cahierdetexte.awp?verbe=get&";
      data = 'data={"token": "$fakeToken"}';
    }*/

    List<Homework>? homework = await request(
        data, rootUrl, method, EcoleDirecteHomeworkConverter.homework, "Homework request returned an error:",
        ignoreMethodAndId: false);
    homework?.forEach((hw) {
      hw.date = date;
    });
    if (homework != null) {
      await HomeworkOffline(_offlineController).updateHomework(homework);
      CustomLogger.log("ED", "Updated homework");
    }
    //await appSys.offline.homework.updateHomework(homework, add: true, forceAdd: true);
    return homework;
  }

  lessons(DateTime dateToUse) async {
    await EcoleDirecteMethod.testToken();
    String dateDebut = DateFormat("yyyy/MM/dd").format(getMonday(dateToUse));

    String dateFin = DateFormat("yyyy/MM/dd").format(getNextSunday(dateToUse));
    String data = 'data={"dateDebut":"$dateDebut","dateFin":"$dateFin", "avecTrous":false, "token": "$token"}';
    String rootUrl = "https://api.ecoledirecte.com/v3/E/";
    String method = "emploidutemps.awp?verbe=get&";
    try {
      List<Lesson>? lessonsList = await request(
          data, rootUrl, method, EcoleDirecteLessonConverter.lessons, "Lessons request returned an error:");
      int week = await getWeek(dateToUse);
      if (lessonsList != null) {
        await LessonsOffline(_offlineController).updateLessons(lessonsList, week);
      }

      return lessonsList;
    } catch (e) {
      return [];
    }
  }

  mails() async {
    await EcoleDirecteMethod.testToken();
    String data = 'data={"token": "$token"}';
    String rootUrl = "https://api.ecoledirecte.com/v3/eleves/";

    String method = "messages.awp?verbe=getall&typeRecuperation=all";
    List<Mail>? mails = await request(
      data,
      rootUrl,
      method,
      EcoleDirecteMailConverter.mails,
      "Mails request returned an error:",
    );
    if (mails != null) {
      await MailsOffline(_offlineController).updateMails(mails);
      CustomLogger.log("ED", "Updated mails");
    }
    return mails;
  }

  nextHomework() async {
    await EcoleDirecteMethod.testToken();
    String rootUrl = 'https://api.ecoledirecte.com/v3/Eleves/';
    String method = "cahierdetexte.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    List<Homework>? homeworkList = [];
    homeworkList = await request(
        data, rootUrl, method, EcoleDirecteHomeworkConverter.unloadedHomework, "UHomework request returned an error:",
        ignoreMethodAndId: false);
    if (homeworkList != null) {
      await HomeworkOffline(_offlineController).updateHomework(homeworkList);
      CustomLogger.log("ED", "Updated homework");
    }
    return homeworkList;
  }

  periods() async {
    await EcoleDirecteMethod.testToken();
    String data = 'data={"token": "$token"}';
    String rootUrl = "https://api.ecoledirecte.com/v3/Eleves/";
    /*if (kDebugMode) {
      rootUrl = "http://demo2235921.mockable.io/";
    }*/
    String method = "notes.awp?verbe=get&";
    List<Period> periodsList = await request(
      data,
      rootUrl,
      method,
      EcoleDirecteAccountConverter.periods,
      "Periods request returned an error:",
    );
    CustomLogger.log("ED", "Amount of periods: ${periodsList.length}");
    return periodsList;
  }

  Future<List<Recipient>> recipients() async {
    await EcoleDirecteMethod.testToken();
    String data = 'data={"token": "$token"}';
    String rootUrl = 'https://api.ecoledirecte.com/v3/messagerie/contacts/professeurs.awp?verbe=get';
    List<Recipient>? recipients = await request(
        data, rootUrl, "", EcoleDirecteMailConverter.recipients, "Recipients request returned an error:",
        ignoreMethodAndId: true);
    if (recipients != null) {
      await RecipientsOffline(appSys.offline).updateRecipients(recipients);
    }
    return recipients ?? [];
  }

  Future<List<SchoolLifeTicket>?> schoolLife() async {
    await EcoleDirecteMethod.testToken();
    String rootUrl = 'https://api.ecoledirecte.com/v3/eleves/';
    String method = "viescolaire.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    List<SchoolLifeTicket>? schoolLifeList = await request(
        data, rootUrl, method, EcoleDirecteSchoolLifeConverter.schoolLife, "School Life request returned an error:");
    if (schoolLifeList != null) {
      await SchoolLifeOffline(appSys.offline).update(schoolLifeList);
    }
    return schoolLifeList;
  }

//Bool value and Token validity tester
  static fetchAnyData(dynamic onlineFetch, dynamic offlineFetch,
      {bool forceFetch = false, isOfflineLocked = false, onlineArguments, offlineArguments}) async {
    //Test connection status
    var connectivityResult = await (Connectivity().checkConnectivity());
    //Offline
    if (connectivityResult == ConnectivityResult.none && !isOfflineLocked) {
      return await ((offlineArguments != null) ? offlineFetch(offlineArguments) : offlineFetch());
    } else if (forceFetch && !isOfflineLocked) {
      try {
        await ((onlineArguments != null) ? onlineFetch(onlineArguments) : onlineFetch());
        return await ((offlineArguments != null) ? offlineFetch(offlineArguments) : offlineFetch());
      } catch (e) {
        CustomLogger.error(e);
        return await ((offlineArguments != null) ? offlineFetch(offlineArguments) : offlineFetch());
      }
    } else {
      //Offline data;
      var data;
      if (!isOfflineLocked) {
        try {
          data = await ((offlineArguments != null) ? offlineFetch(offlineArguments) : offlineFetch());
        } catch (e) {
          CustomLogger.error(e);
        }
      }
      if (data == null) {
        try {
          await ((onlineArguments != null) ? onlineFetch(onlineArguments) : onlineFetch());
          return await ((offlineArguments != null) ? offlineFetch(offlineArguments) : offlineFetch());
        } catch (e) {
          CustomLogger.error(e);
        }
      }
      return data;
    }
  }

  static getMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static getNextSunday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1)).add(Duration(days: 6));
  }

//Refresh the token if expired
  static refreshToken() async {
//Get the password in the secure storage
    String? password = await storage.read(key: "password");
    String? username = await storage.read(key: "username");
    var url = 'https://api.ecoledirecte.com/v3/login.awp';
    Map<String, String> headers = {"Content-type": "text/plain"};
    String data = 'data={"identifiant": "$username", "motdepasse": "$password"}';
    //encode Map to JSON
    var body = data;
    var response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
      throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard. ${e.toString()}");
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> req = jsonDecode(response.body);
      if (req['code'] == 200) {
        token = req['token'];
      }
      //Return an error
      else {
        throw "Error while refreshing token.";
      }
    } else {
      throw "Error while refreshing token.";
    }
  }

//Returns the suitable function according to connection state
  static Future<dynamic> request(String data, String rootUrl, String urlMethod, Function converter, String onErrorBody,
      {Map<String, String>? headers, bool ignoreMethodAndId = false, bool getRequest = false}) async {
    try {
      String id = appSys.currentSchoolAccount?.studentID ?? "";

      String finalUrl = rootUrl + id + "/" + urlMethod;
      if (ignoreMethodAndId) {
        finalUrl = rootUrl;
      }
      if (headers == null) {
        headers = {"Content-type": "text/plain"};
      }
      var response;
      if (getRequest) {
        response = await http.get(Uri.parse(finalUrl), headers: headers);
      } else {
        response = await http.post(Uri.parse(finalUrl), headers: headers, body: data);
      }
      CustomLogger.logWrapped("ED", "Final url", finalUrl);
      Map<String, dynamic>? responseData = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 &&
          responseData != null &&
          responseData['code'] != null &&
          responseData['code'] == 200) {
        var parsedData;
        try {
          parsedData = await converter(responseData);
        } catch (e) {
          throw (onErrorBody + " - during conversion - " + e.toString());
        }
        return parsedData;
      } else {
        CustomLogger.logWrapped("ED", "Response data", responseData.toString());
        throw (onErrorBody + "  Server returned wrong statuscode : ${response.statusCode}");
      }
    } catch (e) {
      throw (onErrorBody + " " + e.toString());
    }
  }

  static Future sendMail(String? subject, String content, List<Recipient> recipientsList) async {
    String recipients = "";

    String parsedContent = base64Encode(utf8.encode(HtmlCharacterEntities.encode(content,
        characters: "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿŒœŠšŸƒˆ˜")));
    recipientsList.forEach((element) {
      String eOrp = element.isTeacher! ? "P" : "E";
      int? id = int.tryParse(element.id!);
      String? surname = element.surname;
      String? name = element.name;

      recipients += """{
                        "to_cc_cci": "to",
                        "type": "$eOrp",
                        "id": $id,
                        "isSelected": true,
                        "nom": "$name",
                        "prenom": "$surname",
                        "fonction": {
                            "id": 0,
                            "libelle": ""
                        },
                        "classe": {
                            "id": 0,
                            "libelle": "",
                            "code": ""
                        },
                        "classes": [],
                        "responsable": {
                            "id": 0,
                            "typeResp": "",
                            "versQui": "",
                            "contacts": []
                        }
                    },""";
    });

    await EcoleDirecteMethod.testToken();
    String? id = appSys.currentSchoolAccount?.studentID ?? "";
    var url = 'https://api.ecoledirecte.com/v3/eleves/$id/messages.awp?verbe=post';

    Map<String, String> headers = {"Content-type": "text/plain"};
    String data = """data={
    "message": {
        "groupesDestinataires": [
            {
                "destinataires": [
                    $recipients
                ],
            }
        ],
        "content": "$parsedContent",
        "subject": "$subject",
        "files": []
    },
    "anneeMessages": "",
    "token": "$token"
    }""";

    CustomLogger.logWrapped("ED", "Mail data to send", data);
    var body = data;
    var response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
      throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
    });
    CustomLogger.log("ED", "Starting the mail reading");
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> req = jsonDecode(response.body);
        if (req['code'] == 200) {
          CustomLogger.log("ED", "Mail sent");
          return;
        }
        //Return an error
        else {
          throw "Error wrong internal status code ";
        }
      } else {
        CustomLogger.log("ERROR", "${response.statusCode}: wrong status code.");
        throw "Error wrong status code";
      }
    } catch (e) {
      throw ("Error while sending mail $e");
    }
  }

  static Future<bool?> testToken() async {
    if (token == "" || token == null) {
      await EcoleDirecteMethod.refreshToken();
      return false;
    } else {
      String? id = appSys.currentSchoolAccount?.studentID ?? "";
      var url = 'https://api.ecoledirecte.com/v3/eleves/$id/timeline.awp?verbe=get&';
      Map<String, String> headers = {"Content-type": "text/plain"};
      String data = 'data={"token": "$token"}';
      //encode Map to JSON
      var body = data;

      var response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        Map<String, dynamic> req = jsonDecode(response.body);
        if (req['code'] == 200) {
          return true;
        } else {
          await EcoleDirecteMethod.refreshToken();
          return false;
        }
      } else {
        await EcoleDirecteMethod.refreshToken();
        return false;
      }
    }
  }

  // static getSchoolLife() async {}
}
