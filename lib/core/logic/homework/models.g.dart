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
      discipline: fields[0] as String?,
      disciplineCode: fields[1] as String?,
      id: fields[2] as String?,
      rawContent: fields[3] as String?,
      sessionRawContent: fields[4] as String?,
      date: fields[5] as DateTime?,
      entryDate: fields[6] as DateTime?,
      done: fields[7] as bool?,
      toReturn: fields[8] as bool?,
      isATest: fields[9] as bool?,
      documents: (fields[10] as List?)?.cast<Document>(),
      sessionDocuments: (fields[11] as List?)?.cast<Document>(),
      teacherName: fields[12] as String?,
      loaded: fields[13] as bool?,
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
