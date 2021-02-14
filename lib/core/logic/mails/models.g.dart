// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipientAdapter extends TypeAdapter<Recipient> {
  @override
  final int typeId = 9;

  @override
  Recipient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipient(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[4] as bool,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Recipient obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.surname)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.discipline)
      ..writeByte(4)
      ..write(obj.isTeacher);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
