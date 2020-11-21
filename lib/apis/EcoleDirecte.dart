import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:alice/alice.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as sta;
import 'package:ynotes/UI/screens/logsPage.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/apis/EcoleDirecte/ecoleDirecteCloud.dart';
import 'package:ynotes/apis/EcoleDirecte/ecoleDirecteConverters.dart';
import 'package:ynotes/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/apis/Pronote/PronoteCas.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/classes.dart';

import 'EcoleDirecte/ecoleDirecteMethods.dart';

sta.Stack<String> Colorstack = sta.Stack();
void createStack() {
  colorList.forEach((color) {
    Colorstack.push(color);
  });
}

Alice alice = Alice();
//Create a secure storage
void CreateStorage(String key, String data) async {
  await storage.write(key: key, value: data);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

String token;

final storage = new FlutterSecureStorage();
List<String> colorList = ["#f07aa0", "#17d0c9", "#a3f7bf", "#cecece", "#ffa41b", "#ff5151", "#b967e1", "#8a7ca7", "#f18867", "#ffc0da", "#739832", "#8ac6d1"];

///The ecole directe api extended from the apiManager.dart API class
class APIEcoleDirecte extends API {
  @override
  // TODO: implement listApp
  List<App> get listApp => [App("Messagerie", MdiIcons.mail, route: "mail"), App("Cloud", Icons.cloud, route: "cloud")];
  @override
//Get connection message and store token
  Future<String> login(username, password, {url, cas}) async {
    final prefs = await SharedPreferences.getInstance();
    if (username == null) {
      username = "";
    }
    if (password == null) {
      password = "";
    }

    var url = 'https://api.ecoledirecte.com/v3/login.awp';
    Map<String, String> headers = {"Content-type": "texet/plain"};
    String data = 'data={"identifiant": "$username", "motdepasse": "$password"}';
    //encode Map to JSON
    var body = data;
    var response = await http.post(url, headers: headers, body: body).catchError((e) {
      return "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> req = jsonDecode(response.body);
      if (req['code'] == 200) {
        try {
          //Put the value of the name in a variable
          actualUser = req['data']['accounts'][0]['prenom'] ?? "Invité";
          ;
          CreateStorage("userFullName", actualUser ?? "");
          String userID = req['data']['accounts'][0]['id'].toString() ?? "";
          String classe;
          try {
            classe = req['data']['accounts'][0]['profile']["classe"]["libelle"] ?? "";
          } catch (e) {
            classe = "";
          }
          //Store the token
          token = req['token'];
          //Create secure storage for credentials

          CreateStorage("password", password ?? "");
          CreateStorage("username", username ?? "");
          //IMPORTANT ! store the user ID
          CreateStorage("userID", userID ?? "");
          CreateStorage("classe", classe ?? "");
          //random date
          CreateStorage("startday", DateTime.parse("2020-02-02").toString());

          //Ensure that the user will not see the carousel anymore
          prefs.setBool('firstUse', false);
        } catch (e) {
          print("Error while getting user info " + e.toString());
          //log in file
          logFile(e.toString());
        }
        this.loggedIn = true;
        return "Bienvenue ${actualUser[0].toUpperCase()}${actualUser.substring(1).toLowerCase()} !";
      }
      //Return an error
      else {
        String message = req['message'];
        return "Oups ! Une erreur a eu lieu :\n$message";
      }
    } else {
      return "Erreur";
    }
  }

  @override
  Future<List<Period>> getPeriods() async {
    return await EcoleDirecteMethod.fetchAnyData(EcoleDirecteMethod.periods, offline.periods);
  }

  @override
//Getting grades
  Future<List<Discipline>> getGrades({bool forceReload}) async {
    return await EcoleDirecteMethod.fetchAnyData(EcoleDirecteMethod.grades, offline.disciplines, forceFetch: forceReload ?? false);
  }

  Future<List<DateTime>> getDatesNextHomework() async {
    return await EcoleDirecteMethod.homeworkDates();
  }

//Get dates of the the next homework (based on the EcoleDirecte API)
  Future<List<Homework>> getNextHomework({bool forceReload}) async {
    return await EcoleDirecteMethod.fetchAnyData(EcoleDirecteMethod.nextHomework, offline.homework, forceFetch: forceReload ?? false);
  }

//Get homeworks for a specific date
  Future<List<Homework>> getHomeworkFor(DateTime dateHomework) async {
    return await EcoleDirecteMethod.homeworkFor(dateHomework);
  }

  @override
  Future<bool> testNewGrades() async {
    try {
      //Getting the offline count of grades
      List<Grade> listOfflineGrades = getAllGrades(await offline.disciplines(), overrideLimit: true);
      print("Offline length is ${listOfflineGrades.length}");
      //Getting the online count of grades
      List<Grade> listOnlineGrades = getAllGrades(await EcoleDirecteMethod.grades(), overrideLimit: true);
      print("Online length is ${listOnlineGrades.length}");
      return (listOfflineGrades.length < listOnlineGrades.length);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future app(String appname, {String args, String action, CloudItem folder}) async {
    switch (appname) {
      case "mail":
        {
          print("Returning mails");
          List<Mail> mails = await getMails();

          return mails;
        }
        break;
      case "cloud":
        {
          print("Returning cloud");
          return await getCloud(args, action, folder);
        }
        break;
      case "mailRecipients":
        {
          print("Returing mail recipients");
          return (await EcoleDirecteMethod.fetchAnyData(EcoleDirecteMethod.recipients, offline.recipients));
        }
        break;
    }
  }

  @override
  Future uploadFile(String contexte, String id, String filepath) async {
    switch (contexte) {
      case ("CDT"):
        {
          var altClient = HttpClient();

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

  @override
  Future getNextLessons(DateTime dateToUse, {bool forceReload = false}) async {
    try {
      print("Getting next lessons");
      int week = await get_week(dateToUse);
      List<Lesson> toReturn;
      var connectivityResult = await (Connectivity().checkConnectivity());
      //get lessons from offline storage
      var offlineLesson = await offline.lessons(week);
      if (offlineLesson != null) {
        //Important init to return
        toReturn = List();

        toReturn.addAll(offlineLesson);
        //filter lessons
        toReturn.removeWhere((lesson) => DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start)) != DateTime.parse(DateFormat("yyyy-MM-dd").format(dateToUse)));
      } else {
        toReturn = null;
      }
      //Check if needed to force refresh if not offline
      if ((forceReload == true || toReturn == null) && connectivityResult != ConnectivityResult.none) {
        try {
          print("Getting next lessons from online");
          List<Lesson> onlineLessons = await EcoleDirecteMethod.lessons(dateToUse, week);

          await offline.updateLessons(onlineLessons, week);

          toReturn = onlineLessons;
        } catch (e) {
          print(e.toString());
        }
      }

      toReturn.sort((a, b) => a.start.compareTo(b.start));
      return toReturn.where((lesson) => DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start)) == DateTime.parse(DateFormat("yyyy-MM-dd").format(dateToUse))).toList();
    } catch (e) {
      print("Error while getting next lessons " + e.toString());
    }
  }

  Future<http.Request> downloadRequest(Document document) async {
    var url = 'https://api.ecoledirecte.com/v3/telechargement.awp?verbe=get';
    await EcoleDirecteMethod.refreshToken();
    Map<String, String> headers = {"Content-type": "x"};
    String type = document.type;
    String id = document.id;
    String body = "leTypeDeFichier=$type&fichierId=$id&token=$token";
    http.Request request = http.Request('POST', Uri.parse(url));
    request.body = body.toString();
    return request;
  }

  ///END OF THE API CLASS
}

///  CLOUD SUB API
/// Read this : called with two arguments. The first one is "args" and is used to add the path:

///       The second one has to be "CD", "PUSH", "RM"
///     E.G : "CD" navigate to the path and return the files and folder existing in it : ESPACES DE TRAVAILS and PERSONNAL CLOUDS are considered as folders
///      E.G : "PUSH" add a file to the path if it doesn't exist
///       E.G : "RM" remove a file to the path
Future getCloud(String args, String action, CloudItem item) async {
  if (action == "CD") {
    switch (args) {
      //Default repository. Every folder have to be followed by / => "/CLOUD/FOLDER/"
      //This action returns every cloud as folders

      case ("/"):
        {
          return await EcoleDirecteMethod.cloudFolders();
        }
        break;
      default:
        {
          return changeFolder(args);
        }
        break;
    }
  }
}

///Returning Ecole Directe Mails, **checking** bool is used to only returns old mail number
Future getMails({bool checking}) async {
  await EcoleDirecteMethod.testToken();
  String id = await storage.read(key: "userID");
  var url = 'https://api.ecoledirecte.com/v3/eleves/$id/messages.awp?verbe=getall&typeRecuperation=all';

  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';
  //encode Map to JSON
  var body = data;
  var response = await http.post(url, headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
  });
  print("Starting the mails collection");

  if (response.statusCode == 200) {
    Map<String, dynamic> req = jsonDecode(utf8.decode(response.bodyBytes));
    if (req['code'] == 200) {
      print("Mail request succeeded");
      List<Mail> mailsList = List<Mail>();
      List<Classeur> classeursList = List<Classeur>();

      //add the classeurs
      if (req['data']['classeurs'] != null) {
        var classeurs = req['data']['classeurs'];
        classeurs.forEach((element) {
          classeursList.add(Classeur(element["libelle"], element["id"]));
        });
      }
      List messagesList = List();
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
          mailsList.add(EcoleDirecteConverter.mail(mailData));
        });
      }
      print("Returned mails");
      if (checking == null) {
        print("checking mails");
        List<Mail> receivedMails = mailsList.where((element) => element.mtype == "received").toList();

        setIntSetting("mailNumber", receivedMails.length);
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

Future readMail(String mailId, bool read) async {
  await EcoleDirecteMethod.testToken();
  String id = await storage.read(key: "userID");
  var url = 'https://api.ecoledirecte.com/v3/eleves/$id/messages/$mailId.awp?verbe=get&mode=destinataire';

  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';
  //encode Map to JSON
  var body = data;
  var response = await http.post(url, headers: headers, body: body).catchError((e) {
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


Future<int> getColor(String disciplineName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//prefs.clear();

  if (prefs.containsKey(disciplineName)) {
    String color = prefs.getString(disciplineName);
    return HexColor(color).value;
  } else {
    if (Colorstack.isEmpty) {
      createStack();
    }
    await prefs.setString(disciplineName, Colorstack.pop());

    String color = prefs.getString(disciplineName);

    return HexColor(color).value;
  }
}
