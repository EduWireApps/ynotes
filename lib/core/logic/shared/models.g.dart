// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 1;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      documentName: fields[0] as String?,
      id: fields[1] as String?,
      type: fields[2] as String?,
      length: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.documentName)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.length);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      documentName: json['documentName'] as String?,
      id: json['id'] as String?,
      type: json['type'] as String?,
      length: json['length'] as int?,
    )..dbId = json['dbId'] as int?;

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'dbId': instance.dbId,
      'documentName': instance.documentName,
      'id': instance.id,
      'type': instance.type,
      'length': instance.length,
    };
