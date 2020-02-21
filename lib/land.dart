import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/collection.dart';

final storage = new FlutterSecureStorage();

//Create a secure storage
void CreateStorage(String key, String data) async {
  await storage.write(key: key, value: data);
}

ReadStorage(_key) async {
  String u = await storage.read(key: "username");
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

  grade({
    this.devoir,
    this.codePeriode,
    this.codeMatiere,
    this.codeSousMatiere,
    this.letters,
    this.valeur,
    this.coef,
    this.noteSur,
    this.moyenneClasse,
  });

  factory grade.fromJson(Map<String, dynamic> json) {
    return grade(
      devoir: json['devoir'],
      codePeriode: json['codePeriode'],
      codeMatiere: json['codeMatiere'],
      codeSousMatiere: json['codeSousMatiere'],
      letters: json['enLettre'],
      valeur: json['valeur'],
      coef: json['coef'],
      noteSur: json['noteSur'],
      moyenneClasse: json['moyenneClasse'],
    );
  }
}
//Discipline class
class discipline {
  final String codeMatiere;
  final List<String> codeSousMatiere;
  final String nomDiscipline;
  final List<String> professeurs;
  final String periode;
  discipline(
      {this.codeMatiere,
      this.codeSousMatiere,
      this.professeurs,
      this.nomDiscipline,
      this.periode});
  factory discipline.fromJson(Map<String, dynamic> json, List<String> profs, String codeMatiere, String periode) {
    return discipline(

      codeSousMatiere: [],
      codeMatiere: codeMatiere,
      nomDiscipline: json['discipline'],
      professeurs: profs,
      periode: periode,

    );
  }
}

List<discipline> disciplinesList = List<discipline>();
//List of grades
Future<List<grade>> getNotesAndDisciplines() async {
  //Check and autorefresh the token
  await testToken();
  String id = await storage.read(key: "userID");
  var url = 'https://api.ecoledirecte.com/v3/Eleves/$id/notes.awp?verbe=get&';
  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';

  var body = data;
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    print(
        "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> req = json.decode(utf8.decode(response.bodyBytes));
    if (req['code'] == 200) {
      //Get all the marks
      List data = req['data']['notes'];
      List<grade> gradesList = List<grade>();



      //Get all the disciplines
      List periodes =
          req['data']['periodes'];
      disciplinesList.clear();
      int i=0;

      periodes.forEach((periodeElement) {

        //Make a list of grades
        List disciplines = periodeElement["ensembleMatieres"]["disciplines"];
        disciplines.forEach((element)
        {
          List profs = element['professeurs'];
          final List<String> profsNoms = List<String>();

          profs.forEach((e) {
            profsNoms.add(e["nom"]);
          });
          if (element['codeSousMatiere']=="")
          {
            disciplinesList.add(discipline.fromJson(element, profsNoms, element['codeMatiere'], i.toString()));

          }
          else {

            disciplinesList[disciplinesList.indexWhere((disciplinesList)=>disciplinesList.codeMatiere==element['codeMatiere']&&disciplinesList.periode==i.toString())].codeSousMatiere.add(element['codeSousMatiere']);
          }

        });
        i++;

      });
      data.forEach((element) {
        //Make a list of grades
          gradesList.add(grade.fromJson(element));
      });

      return gradesList;

    }
  } else {
    throw "Erreur durant la récupération des notes.";
  }
}

//Sort the notes with the name of the period with the pattern "CODEMATIERE, GRADE"
Future<Multimap<String, grade>> sortMarks(int periode) async {

  List<grade> localGradesList = await getNotesAndDisciplines();

  var gradesMap = Multimap<String, grade>();
  localGradesList.forEach((element) {

      gradesMap.add(element.codeMatiere + element.codeSousMatiere, element);


  });
  print(disciplinesList[1].nomDiscipline);
  return gradesMap;
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

