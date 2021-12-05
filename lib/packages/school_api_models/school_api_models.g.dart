// GENERATED CODE - DO NOT MODIFY BY HAND

part of models;

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolLifeSanctionAdapter extends TypeAdapter<SchoolLifeSanction> {
  @override
  final int typeId = 1;

  @override
  SchoolLifeSanction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolLifeSanction(
      type: fields[0] as String,
      registrationDate: fields[1] as String,
      reason: fields[2] as String,
      by: fields[3] as String,
      date: fields[4] as DateTime,
      sanction: fields[5] as String,
      work: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolLifeSanction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.registrationDate)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.by)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.sanction)
      ..writeByte(6)
      ..write(obj.work);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolLifeSanctionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchoolLifeTicketAdapter extends TypeAdapter<SchoolLifeTicket> {
  @override
  final int typeId = 0;

  @override
  SchoolLifeTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolLifeTicket(
      duration: fields[0] as String,
      displayDate: fields[1] as String,
      reason: fields[2] as String,
      type: fields[3] as String,
      isJustified: fields[4] as bool,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolLifeTicket obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.duration)
      ..writeByte(1)
      ..write(obj.displayDate)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.isJustified)
      ..writeByte(5)
      ..write(obj.date);
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
      name: fields[0] as String,
      subject: fields[1] as Subject,
      type: fields[2] as String,
      coefficient: fields[3] as double,
      outOf: fields[4] as double,
      value: fields[5] as double,
      significant: fields[6] as bool,
      date: fields[7] as DateTime,
      entryDate: fields[8] as DateTime,
      classAverage: fields[9] as double,
      maxAverage: fields[10] as double,
      minAverage: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Grade obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.coefficient)
      ..writeByte(4)
      ..write(obj.outOf)
      ..writeByte(5)
      ..write(obj.value)
      ..writeByte(6)
      ..write(obj.significant)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.entryDate)
      ..writeByte(9)
      ..write(obj.classAverage)
      ..writeByte(10)
      ..write(obj.maxAverage)
      ..writeByte(11)
      ..write(obj.minAverage);
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

class SubjectsFilterAdapter extends TypeAdapter<SubjectsFilter> {
  @override
  final int typeId = 5;

  @override
  SubjectsFilter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectsFilter(
      name: fields[0] as String,
      color: fields[1] as YTColor,
      subjects: (fields[2] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectsFilter obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.subjects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectsFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PeriodAdapter extends TypeAdapter<Period> {
  @override
  final int typeId = 3;

  @override
  Period read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Period(
      id: fields[0] as String,
      name: fields[1] as String,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime,
      headTeacher: fields[4] as String,
      overallAverage: fields[5] as double,
      classAverage: fields[6] as double,
      maxAverage: fields[7] as double,
      minAverage: fields[8] as double,
      subjects: (fields[9] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, Period obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.headTeacher)
      ..writeByte(5)
      ..write(obj.overallAverage)
      ..writeByte(6)
      ..write(obj.classAverage)
      ..writeByte(7)
      ..write(obj.maxAverage)
      ..writeByte(8)
      ..write(obj.minAverage)
      ..writeByte(9)
      ..write(obj.subjects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 4;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      id: fields[0] as String,
      name: fields[1] as String,
      classAverage: fields[2] as double,
      maxAverage: fields[3] as double,
      minAverage: fields[4] as double,
      coefficient: fields[5] as double,
      teachers: fields[6] as String,
      grades: (fields[7] as HiveList).castHiveList(),
      periods: (fields[8] as HiveList).castHiveList(),
      api: fields[9] as SchoolApi,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.classAverage)
      ..writeByte(3)
      ..write(obj.maxAverage)
      ..writeByte(4)
      ..write(obj.minAverage)
      ..writeByte(5)
      ..write(obj.coefficient)
      ..writeByte(6)
      ..write(obj.teachers)
      ..writeByte(7)
      ..write(obj.grades)
      ..writeByte(8)
      ..write(obj.periods)
      ..writeByte(9)
      ..write(obj.api);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
