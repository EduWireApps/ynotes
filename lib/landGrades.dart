import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/collection.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as sta;

final storage = new FlutterSecureStorage();
int CLindex = 0;
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

//Marks class
class grade {
  //E.G : "génétique"
  final String devoir;
  //E.G : "A001"
  final String codePeriode;
  //E.G : "SVT"
  final String codeMatiere;
  //E.G : "ECR"
  final String codeSousMatiere;
  //E.G : "Français"
  final String libelleMatiere;
  //E.G : true (affichage en lettres)
  final bool letters;
  //E.G : "18"
  final String valeur;
  //E.G : "1"
  final String coef;
  //E.G : "10" (affichage en lettres)
  final String noteSur;
  //E.G : "" (affichage en lettres)
  final String moyenneClasse;
  //E.G : "Devoir sur table"
  final String typeDevoir;
  //E.G : 16/02
  final String date;
  //E.G : 16/02
  final String dateSaisie;

  grade(
      {this.devoir,
      this.codePeriode,
      this.codeMatiere,
      this.codeSousMatiere,
      this.libelleMatiere,
      this.letters,
      this.valeur,
      this.coef,
      this.noteSur,
      this.moyenneClasse,
      this.typeDevoir,
      this.date,
      this.dateSaisie});

  factory grade.fromJson(Map<String, dynamic> json) {
    return grade(
        devoir: json['devoir'],
        codePeriode: json['codePeriode'],
        codeMatiere: json['codeMatiere'],
        codeSousMatiere: json['codeSousMatiere'],
        libelleMatiere: json['libelleMatiere'],
        letters: json['enLettre'],
        valeur: json['valeur'],
        coef: json['coef'],
        noteSur: json['noteSur'],
        moyenneClasse: json['moyenneClasse'],
        typeDevoir: json['typeDevoir'],
        date: json['date'],
        dateSaisie: json['dateSaisie']);
  }
}

//Discipline class
class discipline {
  final String moyenneGenerale;
  final String moyenneGeneralClasseMax;
  final String moyenneGeneraleClasse;
  final String codeMatiere;
  final List<String> codeSousMatiere;
  final String nomDiscipline;
  final String moyenne;
  final String moyenneClasse;
  final String moyenneMin;
  final String moyenneMax;
  final List<String> professeurs;
  final String periode;
  List<grade> gradesList;
  Color color;
  discipline(
      {this.gradesList,
      this.moyenneGeneralClasseMax,
      this.moyenneGeneraleClasse,
      this.moyenneGenerale,
      this.moyenneClasse,
      this.moyenneMin,
      this.moyenneMax,
      this.codeMatiere,
      this.codeSousMatiere,
      this.moyenne,
      this.professeurs,
      this.nomDiscipline,
      this.periode,
      this.color});

   set setcolor(Color newcolor) {
    color = newcolor;
  }
   set setGradeList(List<grade> list) {
    gradesList = list;
  }
  factory discipline.fromJson(
      Map<String, dynamic> json,
      List<String> profs,
      String codeMatiere,
      String periode,
      Color color,
      String moyenneG,
      String bmoyenneClasse,
      String moyenneClasse) {
    return discipline(
      codeSousMatiere: [],
      codeMatiere: codeMatiere,
      nomDiscipline: json['discipline'],
      moyenne: json['moyenne'],
      moyenneClasse: json['moyenneClasse'],
      moyenneMin: json['moyenneMin'],
      moyenneMax: json['moyenneMax'],
      professeurs: profs,
      periode: periode,
      color: color,
      moyenneGenerale: moyenneG,
      moyenneGeneralClasseMax: bmoyenneClasse,
      moyenneGeneraleClasse: moyenneClasse,
    );
  }
}


//List of grades
Future<List<discipline>> getNotesAndDisciplines() async {
  List<discipline> disciplinesList = List<discipline>();
  //Check and autorefresh the token
  await testToken();
  String id = await storage.read(key: "userID");
  var url = 'https://api.ecoledirecte.com/v3/Eleves/$id/notes.awp?verbe=get&';
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
      disciplinesList.forEach((f){
        final List<grade> localGradesList= List<grade>();

        data.forEach((element) {

           if(element["codeMatiere"]==f.codeMatiere&&element["codePeriode"]+".0"=="A00"+(double.parse(f.periode)/2 + 1).toString())
          {
            //print(element["codePeriode"]);
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
}

refreshDisciplinesListColors(List<discipline> list) async {
  list.forEach((f) async {
    f.color = await getColor(f.codeMatiere);
  });
}

getColor(String disciplineName) async {
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

//Sort the notes with the name of the period with the pattern "CODEMATIERE, GRADE"
/*
Future<Multimap<String, grade>> sortMarks(int periode) async {
  List<grade> localGradesList = await getNotesAndDisciplines();

  var gradesMap = Multimap<String, grade>();
  localGradesList.forEach((element) {
    gradesMap.add(element.codeMatiere + element.codeSousMatiere, element);
  });
  print(disciplinesList[1].nomDiscipline);
  return gradesMap;
}
*/
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
void refreshToken() async {
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

//Get connection message and store token
Future<String> connectionStatus(username, password) async {
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
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> req = jsonDecode(response.body);
    if (req['code'] == 200) {
      //Put the value of the name in a variable
      String name = req['data']['accounts'][0]['prenom'];
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
      return "Bienvenue ${name[0].toUpperCase()}${name.substring(1).toLowerCase()} !";
    }
    //Return an error
    else {
      String message = req['message'];
      throw "Oups ! Une erreur a eu lieu :\n$message";
    }
  } else {
    throw "Erreur";

    // print(req["code"]);
  }
}
