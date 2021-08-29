import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/core/apis/ecole_directe/converters_exporter.dart';
import 'package:ynotes/core/apis/ecole_directe/ecole_directe_cloud.dart';
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
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/secure_storage.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/useful_methods.dart';

import 'ecole_directe/ecole_directe_methods.dart';

//Create a secure storage
List<String> colorList = [
  "#f07aa0",
  "#17d0c9",
  "#a3f7bf",
  "#cecece",
  "#ffa41b",
  "#ff5151",
  "#b967e1",
  "#8a7ca7",
  "#f18867",
  "#ffc0da",
  "#739832",
  "#8ac6d1"
];

final storage = new CustomSecureStorage();

String? token;

///END OF THE API CLASS
void createStorage(String key, String? data) async {
  await storage.write(key: key, value: data);
}

///  CLOUD SUB API
/// Read this : called with two arguments. The first one is "args" and is used to add the path:

///       The second one has to be "CD", "PUSH", "RM"
///     E.G : "CD" navigate to the path and return the files and folder existing in it : ESPACES DE TRAVAILS and PERSONNAL CLOUDS are considered as folders
///      E.G : "PUSH" add a file to the path if it doesn't exist
///       E.G : "RM" remove a file to the path
Future<List<CloudItem>?> getCloud(String? args, String? action, CloudItem? item) async {
  if (action == "CD") {
    switch (args) {
      //Default repository. Every folder have to be followed by / => "/CLOUD/FOLDER/"
      //This action returns every cloud as folders

      case ("/"):
        {
          return await EcoleDirecteMethod(appSys.offline).cloudFolders();
        }
      default:
        {
          return changeFolder(args!);
        }
    }
  }
}

///The ecole directe api extended from the apiManager.dart API class
class APIEcoleDirecte extends API {
  late EcoleDirecteMethod methods;
  APIEcoleDirecte(Offline offlineController) : super(offlineController, apiName: "EcoleDirecte") {
    this.methods = EcoleDirecteMethod(offlineController);
  }

  @override
  Future<List> apiStatus() async {
    return [1, "Pas de problème connu."];
  }

//Get connection message and store token
  @override
  Future app(String appname, {String? args, String? action, CloudItem? folder}) async {
    switch (appname) {
      case "mail":
        {
          CustomLogger.log("ED", "Returning mails");
          List<Mail>? mails = await (getMails());

          return mails;
        }
      case "cloud":
        {
          CustomLogger.log("ED", "Returning cloud");
          return await getCloud(args, action, folder);
        }
      case "mailRecipients":
        {
          CustomLogger.log("ED", "Returing mail recipients");
          return (await EcoleDirecteMethod.fetchAnyData(
              methods.recipients, RecipientsOffline(offlineController).getRecipients));
        }
    }
  }

  Future<http.Request> downloadRequest(Document document) async {
    String? type = document.type;
    String? id = document.id;
    String data = 'data={"token": "$token"}';
    var url = "https://api.ecoledirecte.com/v3/telechargement.awp?verbe=post&leTypeDeFichier=$type&fichierId=$id";
    await methods.refreshToken();
    //encode Map to JSON
    var body = data;
    http.Request request = http.Request('POST', Uri.parse(url));
    request.body = body.toString();

    return request;
  }

  @override
//Getting grades
  Future<List<Discipline>?> getGrades({bool? forceReload}) async {
    return await EcoleDirecteMethod.fetchAnyData(methods.grades, DisciplinesOffline(offlineController).getDisciplines,
        forceFetch: forceReload ?? false);
  }

  Future<List<Homework>> getHomeworkFor(DateTime? dateHomework, {bool? forceReload}) async {
    return await EcoleDirecteMethod.fetchAnyData(methods.homeworkFor, HomeworkOffline(offlineController).getHomeworkFor,
        forceFetch: forceReload ?? false, offlineArguments: dateHomework, onlineArguments: dateHomework);
  }

//Get dates of the the next homework (based on the EcoleDirecte API)
  Future<List<Mail>>? getMails({bool? forceReload}) async {
    return await EcoleDirecteMethod.fetchAnyData(methods.mails, MailsOffline(this.offlineController).getAllMails,
        forceFetch: forceReload ?? false);
  }

//Get homeworks for a specific date
  Future<List<Homework>?> getNextHomework({bool? forceReload}) async {
    return await EcoleDirecteMethod.fetchAnyData(
        methods.nextHomework, HomeworkOffline(this.offlineController).getAllHomework,
        forceFetch: forceReload ?? false);
  }

  @override
  Future<List<Lesson>?> getNextLessons(DateTime dateToUse, {bool? forceReload = false}) async {
    List<Lesson>? lessons = await EcoleDirecteMethod.fetchAnyData(
        methods.lessons, LessonsOffline(offlineController).get,
        forceFetch: forceReload ?? false, onlineArguments: dateToUse, offlineArguments: await getWeek(dateToUse));

    return (lessons ?? [])
        .where((lesson) =>
            DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start!)) ==
            DateTime.parse(DateFormat("yyyy-MM-dd").format(dateToUse)))
        .toList();
  }

  Future<List<SchoolLifeTicket>> getSchoolLife({bool forceReload = false}) async {
    return await EcoleDirecteMethod.fetchAnyData(methods.schoolLife, SchoolLifeOffline(offlineController).get,
        forceFetch: forceReload);
  }

  Future<List> login(username, password, {Map? additionnalSettings}) async {
    methods = EcoleDirecteMethod(offlineController, demo: additionnalSettings?["demo"]);

    final prefs = await SharedPreferences.getInstance();
    if (username == null) {
      username = "";
    }
    if (password == null) {
      password = "";
    }

    var url = methods.endpoints.login;
    print(["", ""]);
    Map<String, String> headers = {"Content-type": "text/plain"};
    String data = 'data={"identifiant": "$username", "motdepasse": "$password"}';
    //encode Map to JSON
    var body = data;
    var response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
      throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> req = jsonDecode(response.body);
      if (req['code'] == 200) {
        try {
          //we register accounts
          //Put the value of the name in a variable
          //
          try {
            appSys.account = EcoleDirecteAccountConverter.account(req);
          } catch (e) {
            CustomLogger.log("ED", "Impossible to get accounts " + e.toString());
            CustomLogger.error(e);
          }

          if (appSys.account != null && appSys.account!.managableAccounts != null) {
            await storage.write(key: "appAccount", value: jsonEncode(appSys.account!.toJson()));
            appSys.currentSchoolAccount = appSys.account!.managableAccounts![0];
          } else {
            return [0, "Impossible de collecter les comptes."];
          }

          String userID = req['data']['accounts'][0]['id'].toString();
          String classe;
          try {
            classe = req['data']['accounts'][0]['profile']["classe"]["libelle"] ?? "";
          } catch (e) {
            classe = "";
          }
          //Store the token
          token = req['token'];

          //Create secure storage for credentials
          createStorage("password", password ?? "");
          createStorage("username", username ?? "");
          //IMPORTANT ! store the user ID
          createStorage("userID", userID);
          createStorage("classe", classe);
          createStorage("demo", additionnalSettings?["demo"].toString());
          //random date
          createStorage("startday", DateTime.parse("2020-02-02").toString());

          //Ensure that the user will not see the carousel anymore
          prefs.setBool('firstUse', false);
        } catch (e) {
          CustomLogger.log("ED", "Error while getting user info " + e.toString());
          //log in file
          CustomLogger.saveLog(object: "ERROR", text: "Ecole Directe: " + e.toString());
        }
        this.loggedIn = true;
        return [1, "Bienvenue ${appSys.account?.name ?? "Invité"} !"];
      }
      //Return an error
      else {
        String? message = req['message'];
        if (message != null) {
          message = utf8.decode(message.codeUnits);
        }
        return [0, "Oups ! Une erreur a eu lieu :\n$message"];
      }
    } else {
      return [0, "Erreur"];
    }
  }

  Future<List<Recipient>?> mailRecipients() async {
    return (await EcoleDirecteMethod.fetchAnyData(
        methods.recipients, RecipientsOffline(offlineController).getRecipients));
  }

  Future<String?> readMail(String mailId, bool read, bool received) async {
    await methods.testToken();
    String? id = appSys.currentSchoolAccount?.studentID;
    String settingMode = received ? "destinataire" : "expediteur";
    var url = 'https://api.ecoledirecte.com/v3/eleves/$id/messages/$mailId.awp?verbe=get&mode=$settingMode';

    Map<String, String> headers = {"Content-type": "text/plain"};
    String data = 'data={"token": "$token"}';
    //encode Map to JSON
    var body = data;
    var response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
      throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
    });
    CustomLogger.log("ED", "Starting the mail reading");
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> req = jsonDecode(response.body);
        if (req['code'] == 200) {
          String toDecode = req['data']['content'];
          toDecode = utf8.decode(base64.decode(toDecode.replaceAll("\n", "")));
          await MailsOffline(offlineController).updateMailContent(toDecode, mailId);
          return toDecode;
        }
        //Return an error
        else {
          CustomLogger.logWrapped("ED", "Response body", response.body);
          throw "Error wrong internal status code ";
        }
      } else {
        CustomLogger.log("ERROR", "${response.statusCode}: wrong status code.");
        throw "Error wrong status code";
      }
    } catch (e) {
      CustomLogger.log("ED", "error during the mail reading $e");
    }
  }

  @override
  Future<bool?> testNewGrades() async {
    try {
      //Getting the offline count of grades
      List<Grade> listOfflineGrades =
          getAllGrades(await DisciplinesOffline(offlineController).getDisciplines(), overrideLimit: true)!;
      CustomLogger.log("ED", "Offline length is ${listOfflineGrades.length}");
      //Getting the online count of grades
      List<Grade> listOnlineGrades = getAllGrades(await methods.grades(), overrideLimit: true)!;
      CustomLogger.log("ED", "Online length is ${listOnlineGrades.length}");
      return (listOfflineGrades.length < listOnlineGrades.length);
    } catch (e) {
      CustomLogger.error(e);
      return null;
    }
  }

  @override
  Future uploadFile(String contexte, String id, String filepath) async {
    switch (contexte) {
      case ("CDT"):
        {
          //Ensure that token is refreshed
          await methods.testToken();
          var uri = Uri.parse('https://api.ecoledirecte.com/v3/televersement.awp?verbe=post&mode=CDT');
          var request = http.MultipartRequest('POST', uri)
            ..headers["user-agent"] = "PostmanRuntime/7.25.0"
            ..headers["accept"] = "*/*"
            ..fields['asap'] = '\nContent-Disposition: form-data; name="data"\n\n{"token":"$token","idContexte":$id}';

          var response = await request.send();
          if (response.statusCode == 200) CustomLogger.log("ED", "File uploaded");
          response.stream.transform(utf8.decoder).listen((value) {
            CustomLogger.log("ED", "File stream value: $value");
          });
        }
    }
  }

  ///END OF THE API CLASS
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
