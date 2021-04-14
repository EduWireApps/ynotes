// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeworkAdapter extends TypeAdapter<Homework> {
  @override
  final int typeId = 0;

  @override
  Homework read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Homework(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
      fields[4] as String?,
      fields[5] as DateTime?,
      fields[6] as DateTime?,
      fields[7] as bool?,
      fields[8] as bool?,
      fields[9] as bool?,
      (fields[10] as List?)?.cast<Document>(),
      (fields[11] as List?)?.cast<Document>(),
      fields[12] as String?,
      fields[13] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Homework obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.discipline)
      ..writeByte(1)
      ..write(obj.disciplineCode)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.rawContent)
      ..writeByte(4)
      ..write(obj.sessionRawContent)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.entryDate)
      ..writeByte(7)
      ..write(obj.done)
      ..writeByte(8)
      ..write(obj.toReturn)
      ..writeByte(9)
      ..write(obj.isATest)
      ..writeByte(10)
      ..write(obj.documents)
      ..writeByte(11)
      ..write(obj.sessionDocuments)
      ..writeByte(12)
      ..write(obj.teacherName)
      ..writeByte(13)
      ..write(obj.loaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeworkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Homework _$HomeworkFromJson(Map<String, dynamic> json) {
  return Homework(
    json['discipline'] as String?,
    json['disciplineCode'] as String?,
    json['id'] as String?,
    json['rawContent'] as String?,
    json['sessionRawContent'] as String?,
    DateTime.parse(json['date'] as String),
    DateTime.parse(json['entryDate'] as String),
    json['done'] as bool?,
    json['toReturn'] as bool?,
    json['isATest'] as bool?,
    (json['documents'] as List)
        .map((e) => Document.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['sessionDocuments'] as List)
        .map((e) => Document.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['teacherName'] as String?,
    json['loaded'] as bool?,
  );
}

Map<String, dynamic> _$HomeworkToJson(Homework instance) => <String, dynamic>{
      'discipline': instance.discipline,
      'disciplineCode': instance.disciplineCode,
      'id': instance.id,
      'rawContent': instance.rawContent,
      'sessionRawContent': instance.sessionRawContent,
      'date': instance.date!.toIso8601String(),
      'entryDate': instance.entryDate!.toIso8601String(),
      'done': instance.done,
      'toReturn': instance.toReturn,
      'isATest': instance.isATest,
      'documents': instance.documents,
      'sessionDocuments': instance.sessionDocuments,
      'teacherName': instance.teacherName,
      'loaded': instance.loaded,
    };
