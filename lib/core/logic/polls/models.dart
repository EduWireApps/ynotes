
import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
part 'models.g.dart';
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
  //Brut data
  @HiveField(7)
  final Map data;

  PollInfo(this.auteur, this.datedebut, this.questions, this.read, this.title, this.id, this.documents, this.data);
}
