import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

part 'models.g.dart';

///Class of a piece of homework

@HiveType(typeId: 0)
@JsonSerializable()
@Collection()
class Homework extends HiveObject {
  @Id()
  int? dbId;
  @HiveField(0)
  String? discipline;
  @HiveField(1)
  String? disciplineCode;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? rawContent;
  @HiveField(4)
  String? sessionRawContent;
  @HiveField(5)
  DateTime? date;
  @HiveField(6)
  DateTime? entryDate;
  @HiveField(7)
  bool? done;
  @HiveField(8)
  bool? toReturn;
  @HiveField(9)
  bool? isATest;
  @HiveField(10)
  @Ignore()
  List<Document>? documents;
  @HiveField(11)
  @Ignore()
  List<Document>? sessionDocuments;
  @HiveField(12)
  String? teacherName;
  //Useful for Ecole Directe users
  @HiveField(13)
  bool? loaded;
  IsarLinks<Document> files = IsarLinks<Document>();
  IsarLinks<Document> sessionFiles = IsarLinks<Document>();
  Homework(
      {this.discipline,
      this.disciplineCode,
      this.id,
      this.rawContent,
      this.sessionRawContent,
      this.date,
      this.entryDate,
      this.done,
      this.toReturn,
      this.isATest,
      this.documents,
      this.sessionDocuments,
      this.teacherName,
      this.loaded});
}
