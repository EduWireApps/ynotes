import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/core/apis/EcoleDirecte/convertersExporter.dart';
import 'package:ynotes/core/apis/EcoleDirecte/ecoleDirecteCloud.dart';
import 'package:ynotes/core/apis/Pronote/PronoteCas.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logsPage.dart';
import 'package:ynotes/usefulMethods.dart';

import 'EcoleDirecte/ecoleDirecteMethods.dart';

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

final storage = new FlutterSecureStorage();

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

///Returning Ecole Directe Mails, **checking** bool is used to only returns old mail number
Future<List<Mail>?> getMails({bool? checking}) async {
  await EcoleDirecteMethod.testToken();
  String? id = appSys.currentSchoolAccount?.studentID;
  var url = 'https://api.ecoledirecte.com/v3/eleves/$id/messages.awp?verbe=getall&typeRecuperation=all';

  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';
  //encode Map to JSON
  var body = data;
  var response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
  });
  print("Starting the mails collection");

  if (response.statusCode == 200) {
    Map<String, dynamic> req = jsonDecode(utf8.decode(response.bodyBytes));
    if (req['code'] == 200) {
      print("Mail request succeeded");
      List<Mail> mailsList = [];
      List<Classeur> classeursList = [];

      //add the classeurs
      if (req['data']['classeurs'] != null) {
        var classeurs = req['data']['classeurs'];
        classeurs.forEach((element) {
          classeursList.add(Classeur(element["libelle"], element["id"]));
        });
      }
      List messagesList = [];
      if (req['data']['messages'] != null) {
        Map messages = req['data']['messages'];
        messages.forEach((key, value) {
          //We finally get in message items
          value.forEach((e) {
            messagesList.add(e);
          });
        });
        messagesList.forEach((element) {
          Map<String, dynamic> mailData = element;
          mailsList.add(EcoleDirecteMailConverter.mail(mailData));
        });
      }
      print("Returned mails");
      if (checking == null) {
        print("checking mails");
        List<Mail> receivedMails = mailsList.where((element) => element.mtype == "received").toList();
        appSys.updateSetting(appSys.settings!["system"], "lastMailCount", receivedMails.length);
        print("checked mails");
      }

      return mailsList;
    }
    //Return an error
    else {
      throw "Error.";
    }
  } else {
    print(response.statusCode);
    throw "Error.";
  }
}

Future<String?> readMail(String mailId, bool read) async {
  await EcoleDirecteMethod.testToken();
  String? id = appSys.currentSchoolAccount?.studentID;
  var url = 'https://api.ecoledirecte.com/v3/eleves/$id/messages/$mailId.awp?verbe=get&mode=destinataire';

  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';
  //encode Map to JSON
  var body = data;
  var response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
  });
  print("Starting the mail reading");
  try {
    if (response.statusCode == 200) {
      Map<String, dynamic> req = jsonDecode(response.body);
      if (req['code'] == 200) {
        String toDecode = req['data']['content'];

        toDecode = utf8.decode(base64.decode(toDecode.replaceAll("\n", "")));

        return toDecode;
      }
      //Return an error
      else {
        printWrapped(response.body);
        throw "Error wrong internal status code ";
      }
    } else {
      print(response.statusCode);
      throw "Error wrong status code";
    }
  } catch (e) {
    print("error during the mail reading $e");
  }
}

///The ecole directe api extended from the apiManager.dart API class
class APIEcoleDirecte extends API {
  APIEcoleDirecte(Offline offlineController) : super(offlineController);

//Get connection message and store token
  @override
  Future<List> apiStatus() async {
    return [1, "Pas de problème connu."];
  }

  @override
  Future app(String appname, {String? args, String? action, CloudItem? folder}) async {
    switch (appname) {
      case "mail":
        {
          print("Returning mails");
          List<Mail>? mails = await (getMails());

          return mails;
        }
      case "cloud":
        {
          print("Returning cloud");
          return await getCloud(args, action, folder);
        }
      case "mailRecipients":
        {
          print("Returing mail recipients");
          return (await EcoleDirecteMethod.fetchAnyData(
              EcoleDirecteMethod(this.offlineController).recipients, offlineController.recipients.getRecipients));
        }
    }
  }

  Future<http.Request> downloadRequest(Document document) async {
    var url = 'https://api.ecoledirecte.com/v3/telechargement.awp?verbe=get';
    await EcoleDirecteMethod.refreshToken();
    String? type = document.type;
    String? id = appSys.currentSchoolAccount?.studentID;
    String body = "leTypeDeFichier=$type&fichierId=$id&token=$token";
    http.Request request = http.Request('POST', Uri.parse(url));
    request.body = body.toString();
    return request;
  }

  Future<List<DateTime>> getDatesNextHomework() async {
    return await EcoleDirecteMethod(this.offlineController).homeworkDates();
  }

//Get dates of the the next homework (based on the EcoleDirecte API)
  @override
//Getting grades
  Future<List<Discipline>> getGrades({bool? forceReload}) async {
    return await EcoleDirecteMethod.fetchAnyData(
        EcoleDirecteMethod(this.offlineController).grades, offlineController.disciplines.getDisciplines,
        forceFetch: forceReload ?? false, isOfflineLocked: this.offlineController.locked);
  }

//Get homeworks for a specific date
  Future<List<Homework>> getHomeworkFor(DateTime? dateHomework) async {
    return await EcoleDirecteMethod(this.offlineController).homeworkFor(dateHomework!);
  }

  Future<List<Homework>> getNextHomework({bool? forceReload}) async {
    return await EcoleDirecteMethod.fetchAnyData(
        EcoleDirecteMethod(this.offlineController).nextHomework, offlineController.homework.getHomework,
        forceFetch: forceReload ?? false);
  }

  @override
  Future<List<Lesson>?> getNextLessons(DateTime dateToUse, {bool? forceReload = false}) async {
    List<Lesson>? lessons = await EcoleDirecteMethod.fetchAnyData(
        EcoleDirecteMethod.lessons, offlineController.lessons.get,
        forceFetch: forceReload ?? false,
        isOfflineLocked: super.offlineController.locked,
        onlineArguments: dateToUse,
        offlineArguments: await getWeek(dateToUse));

    return (lessons ?? [])
        .where((lesson) =>
            DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start!)) ==
            DateTime.parse(DateFormat("yyyy-MM-dd").format(dateToUse)))
        .toList();
  }

  @override
  Future<List<Period>?> getPeriods() async {
    try {
      var a = await EcoleDirecteMethod.fetchAnyData(
          EcoleDirecteMethod(this.offlineController).periods, offlineController.disciplines.getPeriods);
      return a;
    } catch (e) {
      print(e);
    }
  }

  Future<List> login(username, password, {url, cas, mobileCasLogin}) async {
    final prefs = await SharedPreferences.getInstance();
    if (username == null) {
      username = "";
    }
    if (password == null) {
      password = "";
    }

    var url = 'https://api.ecoledirecte.com/v3/login.awp';
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
            print("Impossible to get accounts " + e.toString());
            print(e);
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
          //random date
          createStorage("startday", DateTime.parse("2020-02-02").toString());

          //Ensure that the user will not see the carousel anymore
          prefs.setBool('firstUse', false);
        } catch (e) {
          print("Error while getting user info " + e.toString());
          //log in file
          logFile(e.toString());
        }
        this.loggedIn = true;
        return [1, "Bienvenue ${appSys.account?.name ?? "Invité"} !"];
      }
      //Return an error
      else {
        String? message = req['message'];
        return [0, "Oups ! Une erreur a eu lieu :\n$message"];
      }
    } else {
      return [0, "Erreur"];
    }
  }

  @override
  Future<bool?> testNewGrades() async {
    try {
      //Getting the offline count of grades
      List<Grade> listOfflineGrades =
          getAllGrades(await appSys.offline.disciplines.getDisciplines(), overrideLimit: true)!;
      print("Offline length is ${listOfflineGrades.length}");
      //Getting the online count of grades
      List<Grade> listOnlineGrades =
          getAllGrades(await EcoleDirecteMethod(this.offlineController).grades(), overrideLimit: true)!;
      print("Online length is ${listOnlineGrades.length}");
      return (listOfflineGrades.length < listOnlineGrades.length);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future uploadFile(String contexte, String id, String filepath) async {
    switch (contexte) {
      case ("CDT"):
        {
          //Ensure that token is refreshed
          await EcoleDirecteMethod.testToken();
          var uri = Uri.parse('https://api.ecoledirecte.com/v3/televersement.awp?verbe=post&mode=CDT');
          var request = http.MultipartRequest('POST', uri)
            ..headers["user-agent"] = "PostmanRuntime/7.25.0"
            ..headers["accept"] = "*/*"
            ..fields['asap'] = '\nContent-Disposition: form-data; name="data"\n\n{"token":"$token","idContexte":$id}';

          var response = await request.send();
          if (response.statusCode == 200) print('Uploaded!');
          response.stream.transform(utf8.decoder).listen((value) {
            print(value);
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
