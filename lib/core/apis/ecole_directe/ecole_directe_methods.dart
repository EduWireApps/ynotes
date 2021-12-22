import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/ecole_directe/converters_exporter.dart';
import 'package:ynotes/core/apis/ecole_directe/endpoints/ecole_directe_endpoints.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/data/agenda/lessons.dart';
import 'package:ynotes/core/offline/data/disciplines/disciplines.dart';
import 'package:ynotes/core/offline/data/homework/homework.dart';
import 'package:ynotes/core/offline/data/mails/mails.dart';
import 'package:ynotes/core/offline/data/mails/recipients.dart';
import 'package:ynotes/core/offline/data/school_life/school_life.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/useful_methods.dart';

import '../ecole_directe.dart';

class EcoleDirecteMethod {
  final Offline _offlineController;
  late EcoleDirecteEndpoints endpoints;

  EcoleDirecteMethod(this._offlineController, {bool demo = false}) {
    endpoints = EcoleDirecteEndpoints(debug: demo);
  }
  Future<List<CloudItem>?> cloudFolders() async {
    await testToken();

    String data = 'data={"token": "$token"}';
    List<CloudItem>? cloudFolders = await request(
      data: data,
      url: endpoints.workspaces,
      converter: EcoleDirecteCloudConverter.cloudFolders,
      onErrorBody: "Cloud folders request returned an error:",
    );

    return cloudFolders;
  }

  Future<List<Discipline>> grades() async {
    await testToken();

    String data = 'data={"token": "$token"}';
    List<Discipline>? disciplinesList = await request(
      data: data,
      url: endpoints.grades,
      converter: EcoleDirecteDisciplineConverter.disciplines,
      onErrorBody: "Grades request returned an error:",
    );

    //Update colors;
    disciplinesList = await refreshDisciplinesListColors(disciplinesList ?? []);

    await DisciplinesOffline(_offlineController)
        .updateDisciplines(disciplinesList);

    createStack();

    appSys.settings.system.lastGradeCount =
        (getAllGrades(disciplinesList, overrideLimit: true) ?? []).length;
    appSys.saveSettings();

    return disciplinesList;
  }

  Future<List<Homework>?> homeworkFor(DateTime date) async {
    await testToken();
    String dateToUse = DateFormat("yyyy-MM-dd").format(date).toString();
    String data = 'data={"token": "$token"}';
    /*if (kDebugMode) {
      rootUrl = 'https://still-earth-97911.herokuapp.com/ecoledirecte/homework/' + dateToUse;
      method = "cahierdetexte.awp?verbe=get&";
      data = 'data={"token": "$fakeToken"}';
    }*/

    List<Homework>? homework = await request(
      data: data,
      url: endpoints.homeworkFor(dateToUse),
      converter: EcoleDirecteHomeworkConverter.homework,
      onErrorBody: "Homework request returned an error:",
    );
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
    await testToken();
    String dateDebut = DateFormat("yyyy/MM/dd").format(getMonday(dateToUse));
    String dateFin = DateFormat("yyyy/MM/dd").format(getNextSunday(dateToUse));
    String data =
        'data={"token": "$token", "dateDebut":"$dateDebut", "dateFin":"$dateFin"}';
    try {
      List<Lesson>? lessonsList = await request(
        data: data,
        url: endpoints.lessons,
        converter: EcoleDirecteLessonConverter.lessons,
        onErrorBody: "Lessons request returned an error:",
      );
      int week = await getWeek(dateToUse);

      if (lessonsList != null) {
        await LessonsOffline(_offlineController)
            .updateLessons(lessonsList, week);
      }

      return lessonsList;
    } catch (e) {
      return [];
    }
  }

  mails() async {
    await testToken();
    String data = 'data={"token": "$token"}';
    List<Mail>? mails = await request(
      data: data,
      url: endpoints.mails,
      converter: EcoleDirecteMailConverter.mails,
      onErrorBody: "Mails request returned an error:",
    );

    if (mails != null) {
      await MailsOffline(_offlineController).updateMails(mails);
      CustomLogger.log("ED", "Updated mails");
    }
    return mails;
  }

  nextHomework() async {
    await testToken();

    String data = 'data={"token": "$token"}';

    List<Homework>? homeworkList = await request(
      data: data,
      url: endpoints.nextHomework,
      converter: EcoleDirecteHomeworkConverter.unloadedHomework,
      onErrorBody: "UHomework request returned an error:",
    );

    if (homeworkList != null) {
      await HomeworkOffline(_offlineController).updateHomework(homeworkList);
      CustomLogger.log("ED", "Updated homework");
    }
    return homeworkList;
  }

  Future<List<Recipient>> recipients() async {
    await testToken();
    String data = 'data={"token": "$token"}';
    List<Recipient>? recipients = await request(
      data: data,
      url: endpoints.recipients,
      converter: EcoleDirecteMailConverter.recipients,
      onErrorBody: "Recipients request returned an error:",
    );
    if (recipients != null) {
      await RecipientsOffline(appSys.offline).updateRecipients(recipients);
    }
    return recipients ?? [];
  }

  refreshToken() async {
//Get the password in the secure storage
    String? password = await KVS.read(key: "password");
    String? username = await KVS.read(key: "username");
    var url = endpoints.login;
    CustomLogger.log("LOGIN", url);
    Map<String, String> headers = {"Content-type": "text/plain"};
    String data =
        'data={"identifiant": "$username", "motdepasse": "$password"}';
    //encode Map to JSON
    var body = data;
    var response = await http
        .post(Uri.parse(url), headers: headers, body: body)
        .catchError((e) {
      throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard. ${e.toString()}");
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> req = jsonDecode(response.body);
      if (req['code'] == 200) {
        token = req['token'];
      }
      //Return an error
      else {
        CustomLogger.log("LOGIN", req['code']);
        throw "Error while refreshing token. (internal code)";
      }
    } else {
      CustomLogger.log("LOGIN", url);

      throw "Error while refreshing token. (server code : ${response.statusCode})";
    }
  }

//Bool value and Token validity tester
  Future<List<SchoolLifeTicket>?> schoolLife() async {
    await testToken();
    String data = 'data={"token": "$token"}';
    List<SchoolLifeTicket>? schoolLifeList = await request(
        data: data,
        url: endpoints.schoolLife,
        converter: EcoleDirecteSchoolLifeConverter.schoolLife,
        onErrorBody: "School Life request returned an error:");
    if (schoolLifeList != null) {
      await SchoolLifeOffline(appSys.offline).update(schoolLifeList);
    }
    return schoolLifeList;
  }

  Future sendMail(
      String? subject, String content, List<Recipient> recipientsList) async {
    String recipients = "";

    String parsedContent = base64Encode(utf8.encode(HtmlCharacterEntities.encode(
        content,
        characters:
            "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿŒœŠšŸƒˆ˜")));
    for (var element in recipientsList) {
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
    }

    await testToken();
    String? id = appSys.currentSchoolAccount?.studentID ?? "";
    var url =
        'https://api.ecoledirecte.com/v3/eleves/$id/messages.awp?verbe=post';

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
    var response = await http
        .post(Uri.parse(url), headers: headers, body: body)
        .catchError((e) {
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

  Future<bool?> testToken() async {
    if (token == "" || token == null) {
      await refreshToken();
      return false;
    } else {
      var url = endpoints.testToken;
      Map<String, String> headers = {"Content-type": "text/plain"};
      String data = 'data={"token": "$token"}';
      //encode Map to JSON
      var body = data;

      var response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        Map<String, dynamic> req = jsonDecode(response.body);
        if (req['code'] == 200) {
          return true;
        } else {
          await refreshToken();
          return false;
        }
      } else {
        await refreshToken();
        return false;
      }
    }
  }

//Refresh the token if expired
  static fetchAnyData(dynamic onlineFetch, dynamic offlineFetch,
      {bool forceFetch = false,
      isOfflineLocked = false,
      onlineArguments,
      offlineArguments}) async {
    //Test connection status
    var connectivityResult = await (Connectivity().checkConnectivity());
    //Offline
    if (connectivityResult == ConnectivityResult.none && !isOfflineLocked) {
      return await ((offlineArguments != null)
          ? offlineFetch(offlineArguments)
          : offlineFetch());
    } else if (forceFetch && !isOfflineLocked) {
      try {
        await ((onlineArguments != null)
            ? onlineFetch(onlineArguments)
            : onlineFetch());
        return await ((offlineArguments != null)
            ? offlineFetch(offlineArguments)
            : offlineFetch());
      } catch (e) {
        CustomLogger.error(e, stackHint: "Ng==");
        return await ((offlineArguments != null)
            ? offlineFetch(offlineArguments)
            : offlineFetch());
      }
    } else {
      //Offline data;
      dynamic data;
      if (!isOfflineLocked) {
        try {
          data = await ((offlineArguments != null)
              ? offlineFetch(offlineArguments)
              : offlineFetch());
        } catch (e) {
          CustomLogger.error(e, stackHint: "Nw==");
        }
      }
      if (data == null) {
        try {
          await ((onlineArguments != null)
              ? onlineFetch(onlineArguments)
              : onlineFetch());
          return await ((offlineArguments != null)
              ? offlineFetch(offlineArguments)
              : offlineFetch());
        } catch (e) {
          CustomLogger.error(e, stackHint: "OA==");
        }
      }
      return data;
    }
  }

//Returns the suitable function according to connection state
  static getMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static getNextSunday(DateTime date) {
    return date
        .subtract(Duration(days: date.weekday - 1))
        .add(const Duration(days: 6));
  }

  static Future<dynamic> request(
      {required String data,
      required String url,
      required YConverter converter,
      required String onErrorBody,
      Map<String, String>? headers,
      bool getRequest = false}) async {
    try {
      String finalUrl = url;
      headers ??= {"Content-type": "text/plain"};
      dynamic response;
      if (getRequest) {
        response = await http.get(Uri.parse(finalUrl), headers: headers);
      } else {
        response =
            await http.post(Uri.parse(finalUrl), headers: headers, body: data);
      }

      CustomLogger.logWrapped("ED", "Final url", finalUrl);
      Map<String, dynamic>? responseData =
          json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 &&
          responseData != null &&
          responseData['code'] != null &&
          responseData['code'] == 200) {
        dynamic parsedData;
        try {
          parsedData = await converter.convert(responseData);
        } catch (e) {
          throw (onErrorBody + " - during conversion - " + e.toString());
        }
        return parsedData;
      } else {
        CustomLogger.logWrapped("ED", "Response data", responseData.toString());
        throw (onErrorBody +
            "  Server returned wrong statuscode : ${response.statusCode}");
      }
    } catch (e) {
      throw (onErrorBody + " " + e.toString());
    }
  }

  // static getSchoolLife() async {}
}
