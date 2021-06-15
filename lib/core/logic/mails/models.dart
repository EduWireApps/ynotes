import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

part 'models.g.dart';

class Classeur {
  //E.G: "Mails Maths"
  final String? libelle;
  //E.G : "128"
  final int? id;

  Classeur(this.libelle, this.id);
}

@HiveType(typeId: 11)
class Mail extends HiveObject{
  //E.G: "69627"
  @HiveField(0)
  String? id;
  //E.G : "archived"/"sent"/"received"
  @HiveField(1)
  String? mtype;
  @HiveField(2)
  bool? read;
  //E.G : 183 ==> To class mails in folders
  @HiveField(3)
  String? idClasseur;

  @HiveField(4)
  Map? from;

  @HiveField(5)
  List<Map?>? to;
  //E.G : "Coronavirus school prank"
  @HiveField(6)
  String? subject;
  @HiveField(7)
  String? date;
  @HiveField(8)
  String? content;
  @HiveField(9)
  List<Document> files = [];
  Mail({this.id, this.mtype, this.read, this.idClasseur, this.from, this.subject, this.date, this.content, this.to});
}

@HiveType(typeId: 9)
class Recipient {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? surname;
  @HiveField(2)
  final String? id;
  @HiveField(3)
  final String? discipline;
  @HiveField(4)
  final bool? isTeacher;
  Recipient(this.name, this.surname, this.id, this.isTeacher, this.discipline);
}
