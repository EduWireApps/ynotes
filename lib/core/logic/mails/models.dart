import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/isar/data/adapters.dart';

part 'models.g.dart';

class Classeur {
  //E.G: "Mails Maths"
  final String? libelle;
  //E.G : "128"
  final int? id;

  Classeur(this.libelle, this.id);
}

@Collection()
class Mail {
  @Id()
  int? dbId;
  //E.G: "69627"
  String? id;
  //E.G : "archived"/"sent"/"received"
  String? mtype;
  bool? read;
  //E.G : 183 ==> To class mails in folders
  String? idClasseur;

  @MapConverter()
  Map? from;

  @ListMapConverter()
  List<Map?>? to;
  //E.G : "Coronavirus school prank"
  String? subject;
  String? date;
  String? content;

  @Backlink(to: 'teacher')
  IsarLinks<Document> files = IsarLinks<Document>();
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
