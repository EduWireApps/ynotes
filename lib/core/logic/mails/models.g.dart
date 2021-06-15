// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MailAdapter extends TypeAdapter<Mail> {
  @override
  final int typeId = 11;

  @override
  Mail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mail(
      id: fields[0] as String?,
      mtype: fields[1] as String?,
      read: fields[2] as bool?,
      idClasseur: fields[3] as String?,
      from: (fields[4] as Map?)?.cast<dynamic, dynamic>(),
      subject: fields[6] as String?,
      date: fields[7] as String?,
      content: fields[8] as String?,
      to: (fields[5] as List?)
          ?.map((dynamic e) => (e as Map?)?.cast<dynamic, dynamic>())
          .toList(),
    )..files = (fields[9] as List).cast<Document>();
  }

  @override
  void write(BinaryWriter writer, Mail obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mtype)
      ..writeByte(2)
      ..write(obj.read)
      ..writeByte(3)
      ..write(obj.idClasseur)
      ..writeByte(4)
      ..write(obj.from)
      ..writeByte(5)
      ..write(obj.to)
      ..writeByte(6)
      ..write(obj.subject)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.files);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[4] as bool?,
      fields[3] as String?,
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
