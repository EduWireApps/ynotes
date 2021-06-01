//Class of a downloadable document
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Document {
  @HiveField(0)
  final String? documentName;
  @HiveField(1)
  final String? id;
  @HiveField(2)
  final String? type;
  @HiveField(3)
  final int? length;
  Document(this.documentName, this.id, this.type, this.length);
  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}
