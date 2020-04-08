import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/landGrades.dart';
class homework {
  final String matiere;
  final String codeMatiere;
  final String idDevoir;
  final String contenu;
  final DateTime date;
  final DateTime datePost;
  final bool done;

  homework({this.matiere, this.codeMatiere, this.idDevoir, this.done,
      this.contenu, this.date, this.datePost});

  factory homework.fromJson(
      String matiere,
      String codeMatiere,
      String idDevoir,
      String decodedContent,
      DateTime date,
      DateTime datePost,
      bool done) {
    return homework(
        matiere: matiere,
        codeMatiere: codeMatiere,
        idDevoir: idDevoir,
        contenu: decodedContent,
        date: date,
        datePost: datePost,
        done: done
    );
  }
}
//Get dates of the the next homework (based on the EcoleDirecte API)
getNextHomework() async

{
  //Autorefresh token
  await testToken();
  String id = await storage.read(key: "userID");
  var url = 'https://api.ecoledirecte.com/v3/Eleves/$id/cahierdetexte.awp?verbe=get&';
  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';

  var body = data;
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    throw(
        "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
      });
  if (response.statusCode == 200) {
    //The list of dates to fetch
    List<DateTime> homeworkDatesList = List<DateTime>();

    Map<String, dynamic> req = json.decode(utf8.decode(response.bodyBytes));
    if (req['code'] == 200) {
      List data = req['data'];
      data.forEach((element){


      });
    }
    else {
      throw "Erreur durant la récupération des devoirs";
    }
  }
  else {
    throw "Erreur durant la récupération des devoirs";
  }
}
//Get homeworks for a specific date
getHomeworkFor(DateTime dateHomework) async
{
  //Autorefresh token

  String dateToUse = DateFormat("yyyy-MM-dd").format(dateHomework).toString();
  await testToken();
  String id = await storage.read(key: "userID");
  var url = 'https://api.ecoledirecte.com/v3/Eleves/$id/cahierdetexte/$dateToUse.awp?verbe=get&';
  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';

  var body = data;
  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    throw(
        "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
  });
  if (response.statusCode == 200) {
    //The list of dates to fetch
    List<homework> homeworkList = List<homework>();

    Map<String, dynamic> req = json.decode(utf8.decode(response.bodyBytes));
    if (req['code'] == 200) {
      List data = req['data']['matieres'];
      data.forEach((element){
        String encodedContent = element['aFaire']['contenu'];
        String decodedContent = base64.decode(encodedContent.substring(1, encodedContent.length-1)).toString();
        RegExp regEx = RegExp(
         r'<span style="font-family:times new roman,times,serif;">(.*)<\/span>'
        );

        Iterable<RegExpMatch> matches = regEx.allMatches(decodedContent);
        String parsedContent = matches.join("\r");
        homeworkList.add(homework.fromJson(element['matiere'], element['codeMatiere'], element['idDevoir'] , parsedContent, dateHomework , DateTime.parse(element['aFaire']['donneLe']),  element['aFaire']['effectue']=='true'));
      });
    }
    else {
      throw "Erreur durant la récupération des devoirs";
    }
  }
  else {
    throw "Erreur durant la récupération des devoirs";
  }
}