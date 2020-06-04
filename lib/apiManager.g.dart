// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiManager.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class homeworkAdapter extends TypeAdapter<homework> {
  @override
  final typeId = 0;

  @override
  homework read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return homework(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as DateTime,
      fields[6] as DateTime,
      fields[7] as bool,
      fields[8] as bool,
      fields[9] as bool,
      (fields[10] as List)?.cast<document>(),
      (fields[11] as List)?.cast<document>(),
    );
  }

  @override
  void write(BinaryWriter writer, homework obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.matiere)
      ..writeByte(1)
      ..write(obj.codeMatiere)
      ..writeByte(2)
      ..write(obj.idDevoir)
      ..writeByte(3)
      ..write(obj.contenu)
      ..writeByte(4)
      ..write(obj.contenuDeSeance)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.datePost)
      ..writeByte(7)
      ..write(obj.done)
      ..writeByte(8)
      ..write(obj.rendreEnLigne)
      ..writeByte(9)
      ..write(obj.interrogation)
      ..writeByte(10)
      ..write(obj.documents)
      ..writeByte(11)
      ..write(obj.documentsContenuDeSeance);
  }
}

class documentAdapter extends TypeAdapter<document> {
  @override
  final typeId = 1;

  @override
  document read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return document(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, document obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.libelle)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.length);
  }
}
