// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final int typeId = 4;

  @override
  Lesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lesson(
      room: fields[0] as String?,
      teachers: (fields[1] as List?)?.cast<String?>(),
      start: fields[2] as DateTime?,
      duration: fields[4] as int?,
      canceled: fields[5] as bool?,
      status: fields[6] as String?,
      groups: (fields[7] as List?)?.cast<String>(),
      content: fields[8] as String?,
      discipline: fields[9] as String?,
      disciplineCode: fields[10] as String?,
      end: fields[3] as DateTime?,
      id: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.room)
      ..writeByte(1)
      ..write(obj.teachers)
      ..writeByte(2)
      ..write(obj.start)
      ..writeByte(3)
      ..write(obj.end)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.canceled)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.groups)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.discipline)
      ..writeByte(10)
      ..write(obj.disciplineCode)
      ..writeByte(11)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgendaReminderAdapter extends TypeAdapter<AgendaReminder> {
  @override
  final int typeId = 6;

  @override
  AgendaReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgendaReminder(
      fields[0] as String?,
      fields[1] as String?,
      fields[3] as AlarmType?,
      fields[5] as String?,
      description: fields[2] as String?,
      tagColor: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AgendaReminder obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.lessonID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.alarm)
      ..writeByte(4)
      ..write(obj.tagColor)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgendaReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgendaEventAdapter extends TypeAdapter<AgendaEvent> {
  @override
  final int typeId = 8;

  @override
  AgendaEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgendaEvent(
      fields[0] as DateTime?,
      fields[1] as DateTime?,
      fields[2] as String?,
      fields[3] as String?,
      fields[4] as double?,
      fields[5] as double?,
      fields[7] as bool?,
      fields[8] as String?,
      fields[6] as double?,
      wholeDay: fields[14] as bool?,
      isLesson: fields[10] as bool?,
      lesson: fields[11] as Lesson?,
      reminders: (fields[9] as List?)?.cast<AgendaReminder>(),
      description: fields[12] as String?,
      alarm: fields[13] as AlarmType?,
      color: fields[15] as int?,
      recurrenceScheme: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AgendaEvent obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.left)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.width)
      ..writeByte(7)
      ..write(obj.canceled)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.reminders)
      ..writeByte(10)
      ..write(obj.isLesson)
      ..writeByte(11)
      ..write(obj.lesson)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.alarm)
      ..writeByte(14)
      ..write(obj.wholeDay)
      ..writeByte(15)
      ..write(obj.color)
      ..writeByte(16)
      ..write(obj.recurrenceScheme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgendaEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlarmTypeAdapter extends TypeAdapter<AlarmType> {
  @override
  final int typeId = 7;

  @override
  AlarmType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AlarmType.none;
      case 1:
        return AlarmType.exactly;
      case 2:
        return AlarmType.fiveMinutes;
      case 3:
        return AlarmType.fifteenMinutes;
      case 4:
        return AlarmType.thirtyMinutes;
      case 5:
        return AlarmType.oneDay;
      default:
        return AlarmType.none;
    }
  }

  @override
  void write(BinaryWriter writer, AlarmType obj) {
    switch (obj) {
      case AlarmType.none:
        writer.writeByte(0);
        break;
      case AlarmType.exactly:
        writer.writeByte(1);
        break;
      case AlarmType.fiveMinutes:
        writer.writeByte(2);
        break;
      case AlarmType.fifteenMinutes:
        writer.writeByte(3);
        break;
      case AlarmType.thirtyMinutes:
        writer.writeByte(4);
        break;
      case AlarmType.oneDay:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
