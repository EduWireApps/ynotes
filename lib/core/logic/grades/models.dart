import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'models.g.dart';

@HiveType(typeId: 3)
//Discipline class
class Discipline {
  @HiveField(0)
  final String generalAverage;
  @HiveField(1)
  final String maxClassGeneralAverage;
  @HiveField(2)
  final String classGeneralAverage;
  @HiveField(3)
  final String disciplineCode;
  @HiveField(4)
  final List<String> subdisciplineCode;
  @HiveField(5)
  final String disciplineName;
  @HiveField(6)
  final String average;
  @HiveField(7)
  final String classAverage;
  @HiveField(8)
  final String minClassAverage;
  @HiveField(9)
  final String maxClassAverage;
  @HiveField(10)
  final List<String> teachers;
  @HiveField(11)
  final String period;
  @HiveField(12)
  List<Grade> gradesList;
  @HiveField(13)
  int color;
  @HiveField(14)
  final int disciplineRank;
  @HiveField(15)
  final String classNumber;
  @HiveField(16)
  final String generalRank;
  @HiveField(17)
  final String weight;
  Discipline({
    this.gradesList,
    this.maxClassGeneralAverage,
    this.classGeneralAverage,
    this.generalAverage,
    this.classAverage,
    this.minClassAverage,
    this.maxClassAverage,
    this.disciplineCode,
    this.subdisciplineCode,
    this.average,
    this.teachers,
    this.disciplineName,
    this.period,
    this.color,
    this.disciplineRank,
    this.classNumber,
    this.generalRank,
    this.weight,
  });

  set setcolor(Color newcolor) {
    color = newcolor.value;
  }

  set setGradeList(List<Grade> list) {
    gradesList = list;
  }
//Map<String, dynamic> json, List<String> profs, String codeMatiere, String periode, Color color, String moyenneG, String bmoyenneClasse, String moyenneClasse
//disciplinesList.add(Discipline.fromJson(element, teachersNames, element['codeMatiere'], periodeElement["idPeriode"], Colors.blue, periodeElement["ensembleMatieres"]["moyenneGenerale"], periodeElement["ensembleMatieres"]["moyenneMax"], periodeElement["ensembleMatieres"]["moyenneClasse"]));

  factory Discipline.fromEcoleDirecteJson(
      {@required Map<String, dynamic> json,
      @required List<String> profs,
      @required String periode,
      @required String moyenneG,
      @required String bmoyenneClasse,
      @required String moyenneClasse,
      @required Color color,
      bool showrank = false,
      String effectifClasse = "0",
      String rangGeneral = "0"}) {
    return Discipline(
        subdisciplineCode: [],
        disciplineCode: json['codeMatiere'],
        disciplineName: json['discipline'],
        average: json['moyenne'],
        classAverage: json['moyenneClasse'],
        minClassAverage: json['moyenneMin'],
        maxClassAverage: json['moyenneMax'],
        teachers: profs,
        period: periode,
        color: color.value,
        generalAverage: moyenneG,
        maxClassGeneralAverage: bmoyenneClasse,
        classGeneralAverage: moyenneClasse,
        disciplineRank: showrank ? json["rang"] : null,
        classNumber: effectifClasse,
        generalRank: rangGeneral,
        weight: json["coef"].toString());
  }
  //overrides == operator to avoid issues in selectors
  @override
  bool operator ==(Object other) =>
      other is Discipline &&
      other.disciplineCode == disciplineCode &&
      other.period == period &&
      other.subdisciplineCode == subdisciplineCode;
}

//Marks class
@HiveType(typeId: 2)
class Grade {
  //E.G : "génétique"
  @HiveField(0)
  final String testName;
  //E.G : "A001"
  @HiveField(1)
  final String periodCode;
  //E.G : "SVT"
  @HiveField(2)
  final String disciplineCode;
  //E.G : "ECR"
  @HiveField(3)
  final String subdisciplineCode;
  //E.G : "Français"
  @HiveField(4)
  final String disciplineName;
  //E.G : true (affichage en lettres)
  @HiveField(5)
  final bool letters;
  //E.G : "18"
  @HiveField(6)
  final String value;
  //E.G : "1"
  @HiveField(7)
  final String weight;
  //E.G : "10" (affichage en lettres)
  @HiveField(8)
  final String scale;
  //E.G : "" (affichage en lettres)
  @HiveField(9)
  final String classAverage;
  //E.G : "Devoir sur table"
  @HiveField(10)
  final String testType;
  //E.G : 16/02
  @HiveField(16)
  final DateTime date;
  //E.G : 16/02
  @HiveField(15)
  final DateTime entryDate;
  @HiveField(13)
  final bool notSignificant;
  @HiveField(14)
  //E.G : Trimestre 1
  final String periodName;

  @HiveField(17)
  final String max;
  @HiveField(18)
  final String min;

  @HiveField(19)
  final bool simulated;
  Grade(
      {this.max,
      this.min,
      this.testName,
      this.periodCode,
      this.disciplineCode,
      this.subdisciplineCode,
      this.disciplineName,
      this.letters,
      this.value,
      this.weight,
      this.scale,
      this.classAverage,
      this.testType,
      this.date,
      this.entryDate,
      this.notSignificant,
      this.periodName,
      this.simulated = false});

  factory Grade.fromEcoleDirecteJson(Map<String, dynamic> json, String nomPeriode) {
    return Grade(
        min: json["minClasse"],
        max: json["maxClasse"],
        testName: json['devoir'],
        periodCode: json['codePeriode'],
        periodName: nomPeriode,
        disciplineCode: json['codeMatiere'],
        subdisciplineCode: json['codeSousMatiere'],
        disciplineName: json['libelleMatiere'],
        letters: json['enLettre'],
        value: json['valeur'],
        weight: json['coef'],
        scale: json['noteSur'],
        classAverage: json['moyenneClasse'],
        testType: json['typeDevoir'],
        date: DateTime.parse(json['date']),
        entryDate: DateTime.parse(json['dateSaisie']),
        notSignificant: json['nonSignificatif'],
        simulated: false);
  }
}

class Period {
  final String name;
  final String id;

  Period(this.name, this.id);
}
