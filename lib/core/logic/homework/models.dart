import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
part 'models.g.dart';

///Class of a piece of homework
@JsonSerializable()
@HiveType(typeId: 0)
class Homework extends HiveObject {
  @HiveField(0)
  final String? discipline;
  @HiveField(1)
  final String? disciplineCode;
  @HiveField(2)
  final String? id;
  @HiveField(3)
  final String? rawContent;
  @HiveField(4)
  String? sessionRawContent;
  @HiveField(5)
  DateTime? date;
  @HiveField(6)
  final DateTime? entryDate;
  @HiveField(7)
  final bool? done;
  @HiveField(8)
  final bool? toReturn;
  @HiveField(9)
  final bool? isATest;
  @HiveField(10)
  final List<Document>? documents;
  @HiveField(11)
  final List<Document>? sessionDocuments;
  @HiveField(12)
  final String? teacherName;
  //Useful for Ecole Directe users
  @HiveField(13)
  final bool? loaded;
  Homework(
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
      this.documents,
      this.sessionDocuments,
      this.teacherName,
      this.loaded);
  factory Homework.fromJson(Map<String, dynamic> json) =>
      _$HomeworkFromJson(json);
  Map<String, dynamic> toJson() => _$HomeworkToJson(this);
}
