
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

///Class of a piece of homework
@Collection()
class Homework2 {
  @Id()
  int? dbId;
  
  String? discipline;
  
  String? disciplineCode;
  
  String? id;
  
  String? rawContent;
  
  String? sessionRawContent;
  
  DateTime? date;
  
  DateTime? entryDate;
  
  bool? done;
  
  bool? toReturn;
  
  bool? isATest;

  
  String? teacherName;
  //Useful for Ecole Directe users
  
  bool? loaded;
  Homework2(
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
      this.teacherName,
      this.loaded});
}
