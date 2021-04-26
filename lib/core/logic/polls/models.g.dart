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
      author: fields[0] as String?,
      start: fields[1] as DateTime?,
      questions: (fields[8] as List?)?.cast<PollQuestion>(),
      read: fields[3] as bool?,
      title: fields[4] as String?,
      id: fields[5] as String?,
      documents: (fields[6] as List?)?.cast<Document>(),
      data: (fields[7] as Map?)?.cast<dynamic, dynamic>(),
      isPoll: fields[10] as bool?,
      isInformation: fields[11] as bool?,
      anonymous: fields[12] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, PollInfo obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(8)
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
      ..write(obj.data)
      ..writeByte(10)
      ..write(obj.isPoll)
      ..writeByte(11)
      ..write(obj.isInformation)
      ..writeByte(12)
      ..write(obj.anonymous);
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
