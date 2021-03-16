// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DisciplineAdapter extends TypeAdapter<Discipline> {
  @override
  final int typeId = 3;

  @override
  Discipline read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Discipline(
      gradesList: (fields[12] as List)?.cast<Grade>(),
      maxClassGeneralAverage: fields[1] as String,
      classGeneralAverage: fields[2] as String,
      generalAverage: fields[0] as String,
      classAverage: fields[7] as String,
      minClassAverage: fields[8] as String,
      maxClassAverage: fields[9] as String,
      disciplineCode: fields[3] as String,
      subdisciplineCode: (fields[4] as List)?.cast<String>(),
      average: fields[6] as String,
      teachers: (fields[10] as List)?.cast<String>(),
      disciplineName: fields[5] as String,
      period: fields[11] as String,
      color: fields[13] as int,
      disciplineRank: fields[14] as int,
      classNumber: fields[15] as String,
      generalRank: fields[16] as String,
      weight: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Discipline obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.generalAverage)
      ..writeByte(1)
      ..write(obj.maxClassGeneralAverage)
      ..writeByte(2)
      ..write(obj.classGeneralAverage)
      ..writeByte(3)
      ..write(obj.disciplineCode)
      ..writeByte(4)
      ..write(obj.subdisciplineCode)
      ..writeByte(5)
      ..write(obj.disciplineName)
      ..writeByte(6)
      ..write(obj.average)
      ..writeByte(7)
      ..write(obj.classAverage)
      ..writeByte(8)
      ..write(obj.minClassAverage)
      ..writeByte(9)
      ..write(obj.maxClassAverage)
      ..writeByte(10)
      ..write(obj.teachers)
      ..writeByte(11)
      ..write(obj.period)
      ..writeByte(12)
      ..write(obj.gradesList)
      ..writeByte(13)
      ..write(obj.color)
      ..writeByte(14)
      ..write(obj.disciplineRank)
      ..writeByte(15)
      ..write(obj.classNumber)
      ..writeByte(16)
      ..write(obj.generalRank)
      ..writeByte(17)
      ..write(obj.weight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisciplineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GradeAdapter extends TypeAdapter<Grade> {
  @override
  final int typeId = 2;

  @override
  Grade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grade(
      max: fields[17] as String,
      min: fields[18] as String,
      testName: fields[0] as String,
      periodCode: fields[1] as String,
      disciplineCode: fields[2] as String,
      subdisciplineCode: fields[3] as String,
      disciplineName: fields[4] as String,
      letters: fields[5] as bool,
      value: fields[6] as String,
      weight: fields[7] as String,
      scale: fields[8] as String,
      classAverage: fields[9] as String,
      testType: fields[10] as String,
      date: fields[16] as DateTime,
      entryDate: fields[15] as DateTime,
      notSignificant: fields[13] as bool,
      periodName: fields[14] as String,
      simulated: fields[19] as bool,
      countAsZero: fields[20] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Grade obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.testName)
      ..writeByte(1)
      ..write(obj.periodCode)
      ..writeByte(2)
      ..write(obj.disciplineCode)
      ..writeByte(3)
      ..write(obj.subdisciplineCode)
      ..writeByte(4)
      ..write(obj.disciplineName)
      ..writeByte(5)
      ..write(obj.letters)
      ..writeByte(6)
      ..write(obj.value)
      ..writeByte(7)
      ..write(obj.weight)
      ..writeByte(8)
      ..write(obj.scale)
      ..writeByte(9)
      ..write(obj.classAverage)
      ..writeByte(10)
      ..write(obj.testType)
      ..writeByte(16)
      ..write(obj.date)
      ..writeByte(15)
      ..write(obj.entryDate)
      ..writeByte(13)
      ..write(obj.notSignificant)
      ..writeByte(14)
      ..write(obj.periodName)
      ..writeByte(17)
      ..write(obj.max)
      ..writeByte(18)
      ..write(obj.min)
      ..writeByte(19)
      ..write(obj.simulated)
      ..writeByte(20)
      ..write(obj.countAsZero);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
