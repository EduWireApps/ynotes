// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PollInfoAdapter extends TypeAdapter<PollInfo> {
  @override
  final int typeId = 5;

  @override
  PollInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PollInfo(
      fields[0] as String,
      fields[1] as DateTime,
      (fields[2] as List)?.cast<String>(),
      fields[3] as bool,
      fields[4] as String,
      fields[5] as String,
      (fields[6] as List)?.cast<Document>(),
      (fields[7] as Map)?.cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PollInfo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.auteur)
      ..writeByte(1)
      ..write(obj.datedebut)
      ..writeByte(2)
      ..write(obj.questions)
      ..writeByte(3)
      ..write(obj.read)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.documents)
      ..writeByte(7)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
