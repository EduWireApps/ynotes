// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssessmentAdapter extends TypeAdapter<Assessment> {
  @override
  final int typeId = 21;

  @override
  Assessment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assessment(
      assessmentDate: fields[0] as DateTime,
      competences: (fields[1] as List).cast<Competence>(),
    );
  }

  @override
  void write(BinaryWriter writer, Assessment obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.assessmentDate)
      ..writeByte(1)
      ..write(obj.competences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompetenceAdapter extends TypeAdapter<Competence> {
  @override
  final int typeId = 20;

  @override
  Competence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Competence(
      levelLabel: fields[0] as String,
      level: fields[1] as CompetenceLevel,
      item: fields[2] as CompetenceItem,
      domain: fields[3] as CompetenceDomain?,
      pillar: fields[4] as CompetencePillar?,
    );
  }

  @override
  void write(BinaryWriter writer, Competence obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.levelLabel)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.item)
      ..writeByte(3)
      ..write(obj.domain)
      ..writeByte(4)
      ..write(obj.pillar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompetenceDomainAdapter extends TypeAdapter<CompetenceDomain> {
  @override
  final int typeId = 19;

  @override
  CompetenceDomain read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompetenceDomain(
      name: fields[0] as String?,
      id: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CompetenceDomain obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetenceDomainAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompetenceItemAdapter extends TypeAdapter<CompetenceItem> {
  @override
  final int typeId = 18;

  @override
  CompetenceItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompetenceItem(
      name: fields[0] as String?,
      id: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CompetenceItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetenceItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompetenceLevelAdapter extends TypeAdapter<CompetenceLevel> {
  @override
  final int typeId = 17;

  @override
  CompetenceLevel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompetenceLevel(
      name: fields[0] as String,
      defaultColor: fields[1] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, CompetenceLevel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.defaultColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetenceLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompetencePillarAdapter extends TypeAdapter<CompetencePillar> {
  @override
  final int typeId = 16;

  @override
  CompetencePillar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompetencePillar(
      name: fields[0] as String?,
      id: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CompetencePillar obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetencePillarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompetencesDisciplineAdapter extends TypeAdapter<CompetencesDiscipline> {
  @override
  final int typeId = 15;

  @override
  CompetencesDiscipline read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompetencesDiscipline(
      disciplineName: fields[0] as String,
      disciplineCode: fields[1] as String?,
      subdisciplineCodes: (fields[2] as List?)?.cast<String?>(),
      subdisciplineNames: (fields[4] as List?)?.cast<String?>(),
      periodCode: fields[5] as String,
      periodName: fields[6] as String,
      teachers: (fields[7] as List?)?.cast<String?>(),
      color: fields[8] as Color?,
      assessmentsList: (fields[9] as List?)?.cast<Assessment>(),
    );
  }

  @override
  void write(BinaryWriter writer, CompetencesDiscipline obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.disciplineName)
      ..writeByte(1)
      ..write(obj.disciplineCode)
      ..writeByte(2)
      ..write(obj.subdisciplineCodes)
      ..writeByte(4)
      ..write(obj.subdisciplineNames)
      ..writeByte(5)
      ..write(obj.periodCode)
      ..writeByte(6)
      ..write(obj.periodName)
      ..writeByte(7)
      ..write(obj.teachers)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(9)
      ..write(obj.assessmentsList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetencesDisciplineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
