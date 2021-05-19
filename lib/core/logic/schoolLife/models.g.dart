// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolLifeTicketAdapter extends TypeAdapter<SchoolLifeTicket> {
  @override
  final int typeId = 10;

  @override
  SchoolLifeTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolLifeTicket(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
      fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolLifeTicket obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.libelle)
      ..writeByte(1)
      ..write(obj.displayDate)
      ..writeByte(2)
      ..write(obj.motif)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.isJustified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolLifeTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
