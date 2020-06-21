import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:alice/alice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/collection.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as sta;
import 'package:ynotes/parsers/EcoleDirecteCloud.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/offline.dart';
import 'package:ynotes/apiManager.dart';
import 'package:dio/dio.dart' as dio;

sta.Stack<String> Colorstack = sta.Stack();
void createStack() {
  CoolcolorList.forEach((color) {
    Colorstack.push(color);
  });
}

Alice alice = Alice();
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
        String classe = req['data']['accounts'][0]['profile']["classe"]
                ["libelle"]
            .toString();
        //Store the token
        token = req['token'];
        //Create secure storage for credentials
        CreateStorage("password", password);
        CreateStorage("username", username);
        //IMPORTANT ! store the user ID
        CreateStorage("userID", userID);
        CreateStorage("classe", classe);
        CreateStorage("userFullName", actualUser);
        //Ensure that the user will not see the carousel anymore
        prefs.setBool('firstUse', false);
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
        List<DateTime> pinnedDates = await getPinnedHomeworkDates();
        //Combine lists
        List<DateTime> combinedList = homeworkDatesListToReturn + pinnedDates;
        combinedList = combinedList.toSet().toList();
        combinedList.sort();
        return combinedList;
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

    await putHomework(listToReturn);
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
  Future app(String appname,
      {String args, String action, CloudItem folder}) async {
    switch (appname) {
      case "mail":
        {
          print("Returning mails");
          return await getMails();
        }
        break;
      case "cloud":
        {
          print("Returning cloud");
          return await getCloud(args, action, folder);
        }
        break;
    }
  }

  @override
  Future uploadFile(String contexte, String id, String filepath) async {
    switch (contexte) {
      case ("CDT"):
        {
          //Ensure that token is refreshed
          await testToken();
          /*  print(id);
          var dio2 = dio.Dio();
      
          var data = {
            "data": '{"token":"$token","idContexte":$id}'
          
            //"file": await dio.MultipartFile.fromFile(filepath)
          };
         
          dio.Response response = await dio2.post("https://en9xoeu6tjzo.x.pipedream.net/",  data: dio.FormData.fromMap(data), options: dio.Options(contentType: 'multipart/form-data', headers: {"User-Agent":"PostmanRuntime/7.25.0"}));
      
         print(response.data);
        */
          var uri = Uri.parse(
              'https://api.ecoledirecte.com/v3/televersement.awp?verbe=post&mode=CDT');
          var request = http.MultipartRequest('POST', uri)
            ..headers["user-agent"] = "PostmanRuntime/7.25.0"
            ..headers["accept"] = "*/*"
            ..fields['asap'] =
                '\nContent-Disposition: form-data; name="data"\n\n{"token":"$token","idContexte":$id}';

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

/* CLOUD SUB API 
Read this : called with two arguments. The first one is "args" and is used to add the path: 

      The second one has to be "CD", "PUSH", "RM" 
      E.G : "CD" navigate to the path and return the files and folder existing in it : ESPACES DE TRAVAILS and PERSONNAL CLOUDS are considered as folders
      E.G : "PUSH" add a file to the path if it doesn't exist
      E.G : "RM" remove a file to the path 
              
*/
Future getCloud(String args, String action, CloudItem item) async {
  if (action == "CD") {
    switch (args) {
      //Default repository. Every folder have to be followed by / => "/CLOUD/FOLDER/"
      //This action returns every cloud as folders

      case ("/"):
        {
          //Refresh the token
          await testToken();
          String id = await storage.read(key: "userID");
          //Get the espaces de travail
          var url =
              "https://api.ecoledirecte.com/v3/E/$id/espacestravail.awp?verbe=get&";
          String data = 'data={"token": "$token"}';
          Map<String, String> headers = {"Content-type": "text/plain"};
          var body = data;
          var response = await http
              .post(url, headers: headers, body: body)
              .catchError((e) {
            throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
          });
          try {
            if (response.statusCode == 200) {
              List<CloudItem> toReturn = List();
              Map<String, dynamic> req =
                  jsonDecode(utf8.decode(response.bodyBytes));
              if (req["code"] == 200) {
                lastCloudRequest = utf8.decode(response.bodyBytes);
                String date = "";
                List listData = req["data"];
                listData.forEach((element) {
                  String date = element["creeLe"];
                  try {
                    var split = date.split(" ");
                    date = split[0];
                  } catch (e) {}

                
                  toReturn.add(CloudItem(element["titre"], "FOLDER",
                      element["creePar"], true, date,
                      isMemberOf: element["estMembre"],
                      id: element["id"].toString(),
                      isLoaded: false,
                     ));
                });
                return toReturn;
              } else {
                print(
                    "The servor didn't returned the cloud folder. ${response.body}");
              }
            } else {
              print(
                  "The servor didn't returned the cloud folder. ${response.body}");
            }
          } catch (e) {
            print("Error during an action on the main folders: $e");
          }
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

Future getMails() async {
  await testToken();
  String id = await storage.read(key: "userID");
  var url =
      'https://api.ecoledirecte.com/v3/eleves/$id/messages.awp?verbe=getall&typeRecuperation=all';
  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';
  //encode Map to JSON
  var body = data;
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");
  });
  print("Starting the mails collection");
  try {
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
            print(element["libelle"]);
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

            // mailsList.add(Mail(message["id"], message["mtype"], message["read"], message["idClasseur"], jsonDecode(message["from"]), message["subject"], message["date"]));
          });
          messagesList.forEach((element) {
            Map<String, dynamic> mail = element;
            mailsList.add(
              Mail(
                  mail["id"].toString(),
                  mail["mtype"],
                  mail["read"],
                  mail["idClasseur"].toString(),
                  mail["from"],
                  mail["subject"],
                  mail["date"],
                  to: (mail["to"] != null) ? mail["to"] : null,
                  files: (mail["files"] != null) ? mail["files"] : null),
            );
          });
          //This is the root class of message or message type ("sent", "archived", "received")
          //List messagesRootClass = req['data']['messages'];
          /*print(messagesRootClass.length);
        messagesRootClass.forEach((rootClass){
         
       
        });
*/
        }
        print("Returned mails");
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
  } catch (e) {
    print("error during the mail collection $e");
  }
}

Future readMail(String mailId, bool read) async {
  await testToken();
  String id = await storage.read(key: "userID");
  var url =
      'https://api.ecoledirecte.com/v3/eleves/$id/messages/${mailId}.awp?verbe=get';
  if (read == false) {
    url = url + "&mode=destinataire";
  }
  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';
  //encode Map to JSON
  var body = data;
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
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
        throw "Error.";
      }
    } else {
      print(response.statusCode);
      throw "Error.";
    }
  } catch (e) {
    print("error during the mail collection $e");
  }
}

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
    throw "Erreur durant la récupération des notes. ${url}";
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
