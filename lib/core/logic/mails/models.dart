import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
part 'models.g.dart';

class Mail {
  //E.G: "69627"
  final String id;
  //E.G : "archived"/"sent"/"received"
  final String mtype;
  bool read;
  //E.G : 183 ==> To class mails in folders
  final String idClasseur;
  final Map<String, dynamic> from;
  final to;
  //E.G : "Coronavirus school prank"
  final String subject;
  final String date;
  final String content;
  final List<Document> files;
  Mail(this.id, this.mtype, this.read, this.idClasseur, this.from, this.subject, this.date,
      {this.content, this.to, this.files});
}

class Classeur {
  //E.G: "Mails Maths"
  final String libelle;
  //E.G : "128"
  final int id;

  Classeur(this.libelle, this.id);
}

@HiveType(typeId: 9)
class Recipient {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String surname;
  @HiveField(2)
  final String id;
  @HiveField(3)
  final String discipline;
  @HiveField(4)
  final bool isTeacher;
  Recipient(this.name, this.surname, this.id, this.isTeacher, this.discipline);
}
