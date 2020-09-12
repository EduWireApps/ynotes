import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as sta;
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/parsers/Pronote.dart';
import 'package:ynotes/usefulMethods.dart';
part 'apiManager.g.dart';
//Class of a piece homework

@HiveType(typeId: 0)
class Homework extends HiveObject {
  @HiveField(0)
  final String matiere;
  @HiveField(1)
  final String codeMatiere;
  @HiveField(2)
  final String idDevoir;
  @HiveField(3)
  final String contenu;
  @HiveField(4)
  String contenuDeSeance;
  @HiveField(5)
  DateTime date;
  @HiveField(6)
  final DateTime datePost;
  @HiveField(7)
  final bool done;
  @HiveField(8)
  final bool rendreEnLigne;
  @HiveField(9)
  final bool interrogation;
  @HiveField(10)
  final List<Document> documents;
  @HiveField(11)
  final List<Document> documentsContenuDeSeance;
  @HiveField(12)
  final String nomProf;
  Homework(this.matiere, this.codeMatiere, this.idDevoir, this.contenu, this.contenuDeSeance, this.date, this.datePost, this.done, this.rendreEnLigne, this.interrogation, this.documents, this.documentsContenuDeSeance, this.nomProf);
}

//Class of a downloadable document
@HiveType(typeId: 1)
class Document {
  @HiveField(0)
  final String libelle;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final int length;
  Document(this.libelle, this.id, this.type, this.length);
}

//Marks class
@HiveType(typeId: 2)
class Grade {
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
  @HiveField(14)
  //E.G : Trimestre 1
  final String nomPeriode;
  Grade({this.devoir, this.codePeriode, this.codeMatiere, this.codeSousMatiere, this.libelleMatiere, this.letters, this.valeur, this.coef, this.noteSur, this.moyenneClasse, this.typeDevoir, this.date, this.dateSaisie, this.nonSignificatif, this.nomPeriode});

  factory Grade.fromEcoleDirecteJson(Map<String, dynamic> json, String nomPeriode) {
    return Grade(
        devoir: json['devoir'],
        codePeriode: json['codePeriode'],
        nomPeriode: nomPeriode,
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
class Discipline {
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
  List<Grade> gradesList;
  @HiveField(13)
  int color;
  Discipline({this.gradesList, this.moyenneGeneralClasseMax, this.moyenneGeneraleClasse, this.moyenneGenerale, this.moyenneClasse, this.moyenneMin, this.moyenneMax, this.codeMatiere, this.codeSousMatiere, this.moyenne, this.professeurs, this.nomDiscipline, this.periode, this.color});

  set setcolor(Color newcolor) {
    color = newcolor.value;
  }

  set setGradeList(List<Grade> list) {
    gradesList = list;
  }
//Map<String, dynamic> json, List<String> profs, String codeMatiere, String periode, Color color, String moyenneG, String bmoyenneClasse, String moyenneClasse
//disciplinesList.add(Discipline.fromJson(element, teachersNames, element['codeMatiere'], periodeElement["idPeriode"], Colors.blue, periodeElement["ensembleMatieres"]["moyenneGenerale"], periodeElement["ensembleMatieres"]["moyenneMax"], periodeElement["ensembleMatieres"]["moyenneClasse"]));

  factory Discipline.fromEcoleDirecteJson({@required Map<String, dynamic> json, @required List<String> profs, @required String periode, @required String moyenneG, @required String bmoyenneClasse, @required String moyenneClasse, @required Color color}) {
    return Discipline(
      codeSousMatiere: [],
      codeMatiere: json['codeMatiere'],
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
  final List<Document> files;
  Mail(this.id, this.mtype, this.read, this.idClasseur, this.from, this.subject, this.date, {this.content, this.to, this.files});
}

@HiveType(typeId: 4)
class Lesson {
  //E.G : Salle 215
  @HiveField(0)
  final String room;
  //E.G : Monsieur machin
  @HiveField(1)
  final List<String> teachers;
  //E.G : 9h30
  @HiveField(2)
  final DateTime start;
  //E.G : 10h30
  @HiveField(3)
  final DateTime end;
  //E.G : 45
  @HiveField(4)
  final int duration;
  @HiveField(5)
  final bool canceled;
  //E.G : cours déplacé
  @HiveField(6)
  final String status;
  //E.G : groupe C
  @HiveField(7)
  final List<String> groups;
  //Description
  @HiveField(8)
  final String content;
  @HiveField(9)
  final String matiere;
  @HiveField(10)
  final String codeMatiere;
  @HiveField(11)
  final String id;

  Lesson({
    this.room,
    this.teachers,
    this.start,
    this.duration,
    this.canceled,
    this.status,
    this.groups,
    this.content,
    this.matiere,
    this.codeMatiere,
    this.end,
    this.id,
  });
}

class Classeur {
  //E.G: "Mails Maths"
  final String libelle;
  //E.G : "128"
  final int id;

  Classeur(this.libelle, this.id);
}

@HiveType(typeId: 5)
class PollInfo {
  //E.G : M. Delaruelle
  @HiveField(0)
  final String auteur;
  @HiveField(1)
  final DateTime datedebut;
  @HiveField(2)
  final List<String> questions;
  @HiveField(3)
  bool read;
  @HiveField(4)
  final String title;
  @HiveField(5)
  final String id;
  @HiveField(6)
  final List<Document> documents;

  PollInfo(this.auteur, this.datedebut, this.questions, this.read, this.title, this.id, this.documents);
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

class Period {
  final String name;
  final String id;

  Period(this.name, this.id);
}

abstract class API {
  bool loggedIn = false;

  ///Connect to the API
  ///Should return a connection status
  Future<String> login(username, password, {url, cas});

  ///Get years periods
  Future<List<Period>> getPeriods();

  ///Get marks
  Future<List<Discipline>> getGrades({bool forceReload});

  ///Get the dates of next homework (deprecated)
  Future<List<DateTime>> getDatesNextHomework();

  ///Get the list of all the next homework (sent by specifics API)
  Future<List<Homework>> getNextHomework({bool forceReload});

  ///Get the list of homework only for a specific day (time travel feature)
  Future<List<Homework>> getHomeworkFor(DateTime dateHomework);

  //Get a list of lessons for the agenda part
  Future getNextLessons(DateTime from, {bool forceReload});

  ///Test to know if there are new grades
  Future<bool> testNewGrades();

  ///Send file to cloud or anywhere
  Future uploadFile(String context, String id, String filepath);

  ///Download a file from his name
  Future<Request> downloadRequest(Document document);

  ///Apps
  Future app(String appname, {String args, String action, CloudItem folder});

  List<App> listApp;
  List<Grade> gradesList;
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
