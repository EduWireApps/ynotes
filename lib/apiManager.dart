import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/collection.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as sta;
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/parsers/Pronote.dart';
import 'package:ynotes/usefulMethods.dart';
part 'apiManager.g.dart';
//Class of a piece homework

@HiveType(typeId: 0)
class homework extends HiveObject {
  @HiveField(0)
  final String matiere;
  @HiveField(1)
  final String codeMatiere;
  @HiveField(2)
  final String idDevoir;
  @HiveField(3)
  final String contenu;
  @HiveField(4)
  final String contenuDeSeance;
  @HiveField(5)
  final DateTime date;
  @HiveField(6)
  final DateTime datePost;
  @HiveField(7)
  final bool done;
  @HiveField(8)
  final bool rendreEnLigne;
  @HiveField(9)
  final bool interrogation;
  @HiveField(10)
  final List<document> documents;
  @HiveField(11)
  final List<document> documentsContenuDeSeance;
  @HiveField(12)
  final String nomProf;
  homework(this.matiere, this.codeMatiere, this.idDevoir, this.contenu, this.contenuDeSeance, this.date, this.datePost, this.done, this.rendreEnLigne, this.interrogation, this.documents, this.documentsContenuDeSeance, this.nomProf);
}

//Class of a downloadable document
@HiveType(typeId: 1)
class document {
  @HiveField(0)
  final String libelle;
  @HiveField(1)
  final int id;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final int length;
  document(this.libelle, this.id, this.type, this.length);
}

//Marks class
@HiveType(typeId: 2)
class grade {
  //E.G : "génétique"
  @HiveField(0)
  final String devoir;
  //E.G : "A001"
  @HiveField(1)
  final String codePeriode;
  //E.G : "SVT"
  @HiveField(2)
  final String codeMatiere;
  //E.G : "ECR"
  @HiveField(3)
  final String codeSousMatiere;
  //E.G : "Français"
  @HiveField(4)
  final String libelleMatiere;
  //E.G : true (affichage en lettres)
  @HiveField(5)
  final bool letters;
  //E.G : "18"
  @HiveField(6)
  final String valeur;
  //E.G : "1"
  @HiveField(7)
  final String coef;
  //E.G : "10" (affichage en lettres)
  @HiveField(8)
  final String noteSur;
  //E.G : "" (affichage en lettres)
  @HiveField(9)
  final String moyenneClasse;
  //E.G : "Devoir sur table"
  @HiveField(10)
  final String typeDevoir;
  //E.G : 16/02
  @HiveField(11)
  final String date;
  //E.G : 16/02
  @HiveField(12)
  final String dateSaisie;
  @HiveField(13)
  final bool nonSignificatif;

  grade({this.devoir, this.codePeriode, this.codeMatiere, this.codeSousMatiere, this.libelleMatiere, this.letters, this.valeur, this.coef, this.noteSur, this.moyenneClasse, this.typeDevoir, this.date, this.dateSaisie, this.nonSignificatif});

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
        dateSaisie: json['dateSaisie'],
        nonSignificatif: json['nonSignificatif']);
  }
}
@HiveType(typeId: 3)
//Discipline class
class discipline {
  @HiveField(0)
  final String moyenneGenerale;
  @HiveField(1)
  final String moyenneGeneralClasseMax;
  @HiveField(2)
  final String moyenneGeneraleClasse;
  @HiveField(3)
  final String codeMatiere;
  @HiveField(4)
  final List<String> codeSousMatiere;
  @HiveField(5)
  final String nomDiscipline;
  @HiveField(6)
  final String moyenne;
  @HiveField(7)
  final String moyenneClasse;
  @HiveField(8)
  final String moyenneMin;
  @HiveField(9)
  final String moyenneMax;
  @HiveField(10)
  final List<String> professeurs;
  @HiveField(11)
  final String periode;
  @HiveField(12)
  List<grade> gradesList;
  @HiveField(13)
  int color;
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
    color = newcolor.value;
  }

  set setGradeList(List<grade> list) {
    gradesList = list;
  }

  factory discipline.fromJson(Map<String, dynamic> json, List<String> profs, String codeMatiere, String periode, Color color, String moyenneG, String bmoyenneClasse, String moyenneClasse) {
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
      color: color.value,
      moyenneGenerale: moyenneG,
      moyenneGeneralClasseMax: bmoyenneClasse,
      moyenneGeneraleClasse: moyenneClasse,
    );
  }
}

class Mail {
  //E.G: "69627"
  final String id;
  //E.G : "archived"/"sent"/"received"
  final String mtype;
  bool read;
  //E.G : 183 ==> To class mails in folders
  final String idClasseur;
  final Map<String, dynamic> from;
  final List to;
  //E.G : "Coronavirus school prank"
  final String subject;
  final String date;
  final String content;
  final List files;
  Mail(this.id, this.mtype, this.read, this.idClasseur, this.from, this.subject, this.date, {this.content, this.to, this.files});
}

class Classeur {
  //E.G: "Mails Maths"
  final String libelle;
  //E.G : "128"
  final int id;

  Classeur(this.libelle, this.id);
}

class CloudItem {
  //E.G "test.txt"
  final String title;
  //E.G "FILE"
  final String type;
  //E.G "Donald Trump"
  final String author;
  //E.G true
  final bool isMainFolder;
  //E.G true
  final bool isMemberOf;
  //E.G only useful for the ecoledirecte api
  final bool isLoaded;

  final String id;
  final String date;

  CloudItem(this.title, this.type, this.author, this.isMainFolder, this.date, {this.isMemberOf, this.isLoaded, this.id});
}

abstract class API {
//Connect to the API
//Should return a connection status
  Future<String> login(username, password, {url, cas});

//Get marks
  Future<List<discipline>> getGrades({bool forceReload});

//Get the dates of next homework (deprecated)
  Future<List<DateTime>> getDatesNextHomework();

//Get the list of all the next homework (sent by specifics API)
  Future<List<homework>> getNextHomework({bool forceReload});

//Get the list of homework only for a specific day (time travel feature)
  Future<List<homework>> getHomeworkFor(DateTime dateHomework);

  //Test to know if there are new grades
  Future<bool> testNewGrades();
  //Send file to cloud or anywhere
  Future uploadFile(String contexte, String id, String filepath);

  //Apps
  Future app(String appname, {String args, String action, CloudItem folder});

  List<App> listApp;
}

//Return the good API (will be extended to Pronote)
APIManager() {
  //The parser list index corresponding to the user choice

  switch (chosenParser) {
    case 0:
      return APIEcoleDirecte();

    case 1:
      return APIPronote();
  }
}

getChosenParser() async {
  final prefs = await SharedPreferences.getInstance();
  chosenParser = prefs.getInt('chosenParser') ?? null;
}

setChosenParser(int chosen) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('chosenParser', chosen);
}
