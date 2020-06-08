import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/collection.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as sta;
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/offline.dart';
import 'package:ynotes/apiManager.dart';

sta.Stack<String> Colorstack = sta.Stack();
void createStack() {
  CoolcolorList.forEach((color) {
    Colorstack.push(color);
  });
}

//Create a secure storage
void CreateStorage(String key, String data) async {
  await storage.write(key: key, value: data);
}

ReadStorage(_key) async {
  String u = await storage.read(key: "username");
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
List<String> CoolcolorList = [
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

//The ecole directe api extended from the apiManager.dart API class
class APIEcoleDirecte extends API {
  @override
//Get connection message and store token
  Future<String> login(username, password) async {
    final prefs = await SharedPreferences.getInstance();
    if (username == null) {
      username = "";
    }
    if (password == null) {
      password = "";
    }

    var url = 'https://api.ecoledirecte.com/v3/login.awp';
    Map<String, String> headers = {"Content-type": "texet/plain"};
    String data =
        'data={"identifiant": "$username", "motdepasse": "$password"}';
    //encode Map to JSON
    var body = data;
    var response =
        await http.post(url, headers: headers, body: body).catchError((e) {
      return "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> req = jsonDecode(response.body);
      if (req['code'] == 200) {
        //Put the value of the name in a variable
        actualUser = req['data']['accounts'][0]['prenom'];
        String userID = req['data']['accounts'][0]['id'].toString();
        //Store the token
        token = req['token'];
        //Create secure storage for credentials
        CreateStorage("password", password);
        CreateStorage("username", username);
        //IMPORTANT ! store the user ID
        CreateStorage("userID", userID);

        //Ensure that the user will not see the carousel anymore
        prefs.setBool('firstUse', false);
        return "Bienvenue ${actualUser[0].toUpperCase()}${actualUser.substring(1).toLowerCase()} !";
      }
      //Return an error
      else {
        String message = req['message'];
        return "Oups ! Une erreur a eu lieu :\n$message" ;
      }
    } else {
      return "Erreur";
    }
  }

  @override
//Getting grades
  Future<List<discipline>> getGrades({bool forceReload}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var offlineGrades = await getGradesFromDB(
        online: connectivityResult != ConnectivityResult.none);

    //If force reload enabled the grades will be loaded online
    if ((connectivityResult == ConnectivityResult.none ||
            forceReload == false ||
            forceReload == null) &&
        offlineGrades != null) {
      print("Loading grades from offline storage.");
      //RELOAD THE GRADES ANYWAY
      //NDLR : await is not needed, grades will be refreshed later
      if (connectivityResult != ConnectivityResult.none) {
        getGrades(forceReload: true);
      }

      return await getOfflineGrades();
    } else {
      print("Loading grades inline.");
      var toReturn = await getGradesFromInternet();

      return toReturn;
    }
  }

  Future<List<DateTime>> getDatesNextHomework() async {
    List<DateTime> homeworkDatesListToReturn = List<DateTime>();
    //Autorefresh token
    await testToken();
    String id = await storage.read(key: "userID");
    var url =
        'https://api.ecoledirecte.com/v3/Eleves/$id/cahierdetexte.awp?verbe=get&';
    Map<String, String> headers = {"Content-type": "text/plain"};
    String data = 'data={"token": "$token"}';

    var body = data;
    var response =
        await http.post(url, headers: headers, body: body).catchError((e) {
      throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
    });

    if (response.statusCode == 200) {
      //The list of dates to fetch
      List<homework> local = List<homework>();
      Map<String, dynamic> req = json.decode(utf8.decode(response.bodyBytes));
      if (req['code'] == 200) {
        print("Homework request succeed");

        Map<String, dynamic> data2 = req['data'];
        bool isLimitedTo7Days = await getSetting("7DaysLimit");
        if (isLimitedTo7Days == null) {
          isLimitedTo7Days = false;
        }
        data2.forEach((key, value) {
          if (isLimitedTo7Days == true) {
            if (DateTime.parse(
                        DateFormat("yyyy-MM-dd").format(DateTime.parse(key)))
                    .difference(DateTime.parse(
                        DateFormat("yyyy-MM-dd").format(DateTime.now())))
                    .inDays >
                7) homeworkDatesListToReturn.add(DateTime.parse(key));
          } else {
            homeworkDatesListToReturn.add(DateTime.parse(key));
          }
        });
        return homeworkDatesListToReturn;
      } else {
        throw "Erreur durant la récupération des devoirs";
      }
    } else {
      throw "Erreur durant la récupération des devoirs";
    }
  }

//Get dates of the the next homework (based on the EcoleDirecte API)
  Future<List<homework>> getNextHomework({bool forceReload}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var offlineHomework = await getHomeworkFromDB(
        online: connectivityResult != ConnectivityResult.none);
    

    //If force reload enabled the grades will be loaded online
    if ((connectivityResult == ConnectivityResult.none ||
            forceReload == false ||
            forceReload == null) &&
        offlineHomework != null) {
      print("Loading homework from offline storage.");
      //RELOAD THE HOMEWORK ANYWAY
      //NDLR : await is not needed, homework will be refreshed later
      //getNextHomework(forceReload:true);
      if (connectivityResult != ConnectivityResult.none) {
        getNextHomework(forceReload: true);
      }

      return offlineHomework;
    } else {
      print("Loading homework inline.");
      List<DateTime> localDTList = await getDatesNextHomework();

      //List<homework> test;
      var toReturn = await asyncTask(localDTList);
      return toReturn;
    }
  }

  Future<List<homework>> asyncTask(List<DateTime> datesList) async {
    List<homework> listToReturn = List<homework>();
    await Future.forEach(datesList, (date) async {
      List<homework> list;
      list = await getHomeworkFor(date);

      list.forEach((h) {
        listToReturn.add(h);
      });
    });

    putHomework(listToReturn);
    return listToReturn;
  }

//Get homeworks for a specific date
  Future<List<homework>> getHomeworkFor(DateTime dateHomework) async {
    //Autorefresh token
    initializeDateFormatting();
    if (dateHomework != null) {
      String dateToUse =
          DateFormat("yyyy-MM-dd").format(dateHomework).toString();
      await testToken();
      String id = await storage.read(key: "userID");
      var url =
          'https://api.ecoledirecte.com/v3/Eleves/$id/cahierdetexte/$dateToUse.awp?verbe=get&';
      Map<String, String> headers = {"Con*nt-type": "text/plain"};
      String data = 'data={"token": "$token"}';

      var body = data;
      var response =
          await http.post(url, headers: headers, body: body).catchError((e) {
        throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
      });
      if (response.statusCode == 200) {
        //The list of dates to fetch
        List<homework> homeworkList = List<homework>();
        homeworkList.clear();
        Map<String, dynamic> req = json.decode(utf8.decode(response.bodyBytes));
        if (req['code'] == 200) {
          List data = req['data']['matieres'];

          data.forEach((element) {
            print(data);
            if (element['aFaire'] != null) {
              String encodedContent = "";
              String aFaireEncoded = "";
              bool rendreEnLigne = false;

              bool interrogation = false;
              List<document> documentsAFaire = List<document>();
              List<document> documentsContenuDeCours = List<document>();
              try {
                encodedContent = element['aFaire']['contenu'];
                rendreEnLigne = element['aFaire']['rendreEnLigne'];

                aFaireEncoded = element['contenuDeSeance']['contenu'];
                List docs = element['aFaire']['documents'];
                if (docs != null) {
                  docs.forEach((e) {
                    documentsAFaire.add(new document(
                        e["libelle"], e["id"], e["type"], e["taille"]));
                  });
                }

                List docsContenu = element['contenuDeSeance']['documents'];
                if (docsContenu != null) {
                  docsContenu.forEach((e) {
                    documentsContenuDeCours.add(new document(
                        e["libelle"], e["id"], e["type"], e["taille"]));
                  });
                }
                interrogation = element['interrogation'];
              } catch (e) {
                print("Erreur:" + e.toString() + dateHomework.toString());
              }

              String decodedContent = "";
              String decodedContenuDeSeance = "";
              decodedContent = utf8.decode(base64.decode(encodedContent));

              decodedContenuDeSeance =
                  utf8.decode(base64.decode(aFaireEncoded));
              homeworkList.add(new homework(
                  element['matiere'],
                  element['codeMatiere'],
                  element['id'].toString(),
                  decodedContent,
                  decodedContenuDeSeance,
                  dateHomework,
                  DateTime.parse(element['aFaire']['donneLe']),
                  element['aFaire']['effectue'] == 'true',
                  rendreEnLigne,
                  interrogation,
                  documentsAFaire,
                  documentsContenuDeCours,
                  element['nomProf'],
                  ));
            }
          });
          return homeworkList;
        } else {
          throw "Erreur durant la récupération des devoirs";
        }
      } else {
        throw "Erreur durant la récupération des devoirs";
      }
    } else {
      //print ("Erreur durant la récupération des devoirs : a date was null");
    }
  }

  @override
  Future<bool> testNewGrades() async {
    try {
      //Getting the offline count of grades
      List<grade> listOfflineGrades =
          getAllGrades(await getOfflineGrades(), overrideLimit: true);

      print("Offline length is ${listOfflineGrades.length}");
      //Getting the online count of grades
      List<grade> listOnlineGrades =
          getAllGrades(await getGradesFromInternet(), overrideLimit: true);
      print("Online length is ${listOnlineGrades.length}");
      if (listOfflineGrades.length < listOnlineGrades.length) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future app(String appname, {String args, String action}) {
    switch (appname) {
      case "mail":
        {
          return getMails();
        }
        break;
    }
  }

  ///END OF THE API CLASS
}

Future getMails() async {
  await testToken();
  String id = await storage.read(key: "userID");
  var url =
      'https://api.ecoledirecte.com/v3/eleves/$identityHashCode(object)/messages.awp?verbe=getall&typeRecuperation=all';
  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';
  //encode Map to JSON
  var body = data;
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> req = jsonDecode(response.body);
    if (req['code'] == 200) {
      List<Mail> mailsList = List<Mail>();
      List<Classeur> classeursList = List<Classeur>();
      Map<String, dynamic> data = jsonDecode(req['code']['data']);
      //add the classeurs
      if (req['code']['data']['classeurs'] != null) {
        var classeurs = req['code']['data']['classeurs'];
        classeurs.forEach((element) {
          Classeur classeur;
          classeursList.add(new Classeur(element["libelle"], element["id"]));
        });
      }
    }
    //Return an error
    else {
      throw "Error.";
    }
  } else {
    throw "Error.";
  }
}

Future<Mail> readMail(String mailId) {}
Future<Mail> sendMail() {}
//Refresh colors
refreshDisciplinesListColors(List<discipline> list) async {
  list.forEach((f) async {
    f.color = await getColor(f.codeMatiere);
  });
}

Future<Color> getColor(String disciplineName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//prefs.clear();

  if (prefs.containsKey(disciplineName)) {
    String color = prefs.getString(disciplineName);

    return HexColor(color);
  } else {
    if (Colorstack.isEmpty) {
      createStack();
    }
    await prefs.setString(disciplineName, Colorstack.pop());

    String color = prefs.getString(disciplineName);

    return HexColor(color);
  }
}

//Bool value and Token validity tester
testToken() async {
  if (token == "" || token == null) {
    await refreshToken();
    return false;
  } else {
    String id = await storage.read(key: "userID");
    var url = 'https://api.ecoledirecte.com/v3/$id/login.awp';
    Map<String, String> headers = {"Content-type": "text/plain"};
    String data = 'data={"token": "$token"}';
    //encode Map to JSON
    var body = data;
    var response =
        await http.post(url, headers: headers, body: body).catchError((e) {
      return false;
    });

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
refreshToken() async {
//Get the password in the secure storage
  String password = await storage.read(key: "password");
  String username = await storage.read(key: "username");

  var url = 'https://api.ecoledirecte.com/v3/login.awp';
  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"identifiant": "$username", "motdepasse": "$password"}';
  //encode Map to JSON
  var body = data;
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> req = jsonDecode(response.body);
    if (req['code'] == 200) {
      token = req['token'];
    }
    //Return an error
    else {
      throw "Error.";
    }
  } else {
    throw "Error.";
  }
}

getGradesFromInternet() async {
  List<discipline> disciplinesList = List<discipline>();
  //Check and autorefresh the token
  await testToken();
  String id = await storage.read(key: "userID");
  var url = 'https://api.ecoledirecte.com/v3/Eleves/$id/notes.awp?verbe=get&';
  //Only for testing purposes
  //var url = 'http://demo2235921.mockable.io';
  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';

  var body = data;
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> req = json.decode(utf8.decode(response.bodyBytes));
    if (req['code'] == 200) {
      try {
        putGrades(utf8.decode(response.bodyBytes));
      } catch (e) {
        print(e);
      }
      //Get all the marks
      List data = req['data']['notes'];
      List<grade> gradesList = List<grade>();

      //Get all the disciplines
      List periodes = req['data']['periodes'];
      disciplinesList.clear();
      int i = 0;

      periodes.forEach((periodeElement) {
        Color color = Colors.green;
        //Make a list of grades

        List disciplines = periodeElement["ensembleMatieres"]["disciplines"];
        disciplines.forEach((element) async {
          List profs = element['professeurs'];
          final List<String> profsNoms = List<String>();

          profs.forEach((e) {
            profsNoms.add(e["nom"]);
          });
//Making objects
          if (element['codeSousMatiere'] == "") {
            disciplinesList.add(discipline.fromJson(
                element,
                profsNoms,
                element['codeMatiere'],
                i.toString(),
                Colors.blue,
                periodeElement["ensembleMatieres"]["moyenneGenerale"],
                periodeElement["ensembleMatieres"]["moyenneMax"],
                periodeElement["ensembleMatieres"]["moyenneClasse"]));
          } else {
            disciplinesList[disciplinesList.lastIndexWhere((disciplinesList) =>
                    disciplinesList.codeMatiere == element['codeMatiere'] &&
                    disciplinesList.periode == i.toString())]
                .codeSousMatiere
                .add(element['codeSousMatiere']);
          }
        });
        i++;
      });
      disciplinesList.forEach((f) {
        final List<grade> localGradesList = List<grade>();

        data.forEach((element) {
          if (element["codeMatiere"] == f.codeMatiere &&
              element["codePeriode"] + ".0" ==
                  "A00" + (double.parse(f.periode) / 2 + 1).toString()) {
            localGradesList.add(grade.fromJson(element));
          }
        });

        f.gradesList = localGradesList;
      });

      createStack();
      refreshDisciplinesListColors(disciplinesList);

      return disciplinesList;
    }
  } else {
    throw "Erreur durant la récupération des notes.";
  }
  return null;
}

getOfflineGrades() async {
  Map<String, dynamic> req = await getGradesFromDB();
  List<discipline> disciplinesList = List<discipline>();

  //Get all the marks
  List data = req['data']['notes'];
  List<grade> gradesList = List<grade>();

  //Get all the disciplines
  List periodes = req['data']['periodes'];
  disciplinesList.clear();
  int i = 0;

  periodes.forEach((periodeElement) {
    Color color = Colors.green;
    //Make a list of grades

    List disciplines = periodeElement["ensembleMatieres"]["disciplines"];
    disciplines.forEach((element) async {
      List profs = element['professeurs'];
      final List<String> profsNoms = List<String>();

      profs.forEach((e) {
        profsNoms.add(e["nom"]);
      });
//Making objects
      if (element['codeSousMatiere'] == "") {
        disciplinesList.add(discipline.fromJson(
            element,
            profsNoms,
            element['codeMatiere'],
            i.toString(),
            Colors.blue,
            periodeElement["ensembleMatieres"]["moyenneGenerale"],
            periodeElement["ensembleMatieres"]["moyenneMax"],
            periodeElement["ensembleMatieres"]["moyenneClasse"]));
      } else {
        disciplinesList[disciplinesList.lastIndexWhere((disciplinesList) =>
                disciplinesList.codeMatiere == element['codeMatiere'] &&
                disciplinesList.periode == i.toString())]
            .codeSousMatiere
            .add(element['codeSousMatiere']);
      }
    });
    i++;
  });
  disciplinesList.forEach((f) {
    final List<grade> localGradesList = List<grade>();

    data.forEach((element) {
      if (element["codeMatiere"] == f.codeMatiere &&
          element["codePeriode"] + ".0" ==
              "A00" + (double.parse(f.periode) / 2 + 1).toString()) {
        localGradesList.add(grade.fromJson(element));
      }
    });

    f.gradesList = localGradesList;
  });

  createStack();
  refreshDisciplinesListColors(disciplinesList);

  return disciplinesList;
}
