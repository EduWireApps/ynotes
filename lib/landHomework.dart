import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/landGrades.dart';
import 'package:ynotes/usefulMethods.dart';

class homework {
  final String matiere;
  final String codeMatiere;
  final String idDevoir;
  final String contenu;
  final String contenuDeSeance;
  final DateTime date;
  final DateTime datePost;
  final bool done;
  final bool rendreEnLigne;
  final bool interrogation;
  final List<document> documents;
  final List<document> documentsContenuDeSeance;
  homework(
      this.matiere,
      this.codeMatiere,
      this.idDevoir,
      this.contenu,
       this.contenuDeSeance,
      this.date,
      this.datePost,
      this.done,
      this.rendreEnLigne,
      this.interrogation,
      this.documents,
     
      this.documentsContenuDeSeance);
}

class document {
  final String libelle;
  final int id;
  final String type;
  final int length;
  document(this.libelle, this.id, this.type, this.length);
}

Future<List<DateTime>> getDatesNextHomeWork() async {
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
      data2.forEach((key, value) {
        if(isLimitedTo7Days==true)
        {
 if(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.parse(key))).difference(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()))).inDays>7)
        homeworkDatesListToReturn.add(DateTime.parse(key));
        }
        else {
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
Future<List<homework>> getNextHomework() async {
  List<DateTime> localDTList = await getDatesNextHomeWork();

  List<homework> test;
  var toReturn = await asyncTask(localDTList);
  return toReturn;
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

  return listToReturn;
}

//Get homeworks for a specific date
Future<List<homework>> getHomeworkFor(DateTime dateHomework) async {
  //Autorefresh token
  initializeDateFormatting();
  String dateToUse = DateFormat("yyyy-MM-dd").format(dateHomework).toString();
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
                print(decodedContenuDeSeance);
          homeworkList.add(new homework(
              element['matiere'],
              element['codeMatiere'],
              element['idDevoir'],
              decodedContent,
              decodedContenuDeSeance,
              dateHomework,
              DateTime.parse(element['aFaire']['donneLe']),
              element['aFaire']['effectue'] == 'true',
              rendreEnLigne,
              interrogation,
              documentsAFaire,
              documentsContenuDeCours
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
}
