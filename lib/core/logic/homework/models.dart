import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

part 'models.g.dart';

///Class of a piece of homework

@HiveType(typeId: 0)
class Homework extends HiveObject {
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
  @HiveField(12)
  String? teacherName;
  //Useful for Ecole Directe users
  @HiveField(13)
  bool? loaded;
  @HiveField(14)
  bool editable;

  @HiveField(15)
  bool? pinned;
  @HiveField(16)
  List<Document> files = [];
  @HiveField(17)
  List<Document> sessionFiles = [];
  Homework({
    this.discipline,
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
    this.loaded,
    this.editable = false,
    this.pinned,
  });
}
