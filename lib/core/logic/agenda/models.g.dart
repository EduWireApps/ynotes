// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class alarmTypeAdapter extends TypeAdapter<alarmType> {
  @override
  final int typeId = 7;

  @override
  alarmType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return alarmType.none;
      case 1:
        return alarmType.exactly;
      case 2:
        return alarmType.fiveMinutes;
      case 3:
        return alarmType.fifteenMinutes;
      case 4:
        return alarmType.thirtyMinutes;
      case 5:
        return alarmType.oneDay;
      default:
        return alarmType.none;
    }
  }

  @override
  void write(BinaryWriter writer, alarmType obj) {
    switch (obj) {
      case alarmType.none:
        writer.writeByte(0);
        break;
      case alarmType.exactly:
        writer.writeByte(1);
        break;
      case alarmType.fiveMinutes:
        writer.writeByte(2);
        break;
      case alarmType.fifteenMinutes:
        writer.writeByte(3);
        break;
      case alarmType.thirtyMinutes:
        writer.writeByte(4);
        break;
      case alarmType.oneDay:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is alarmTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      fields[3] as alarmType?,
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
      alarm: fields[13] as alarmType?,
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return Lesson(
    room: json['room'] as String?,
    teachers:
        (json['teachers'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    duration: json['duration'] as int?,
    canceled: json['canceled'] as bool?,
    status: json['status'] as String?,
    groups:
        (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList(),
    content: json['content'] as String?,
    discipline: json['discipline'] as String?,
    disciplineCode: json['disciplineCode'] as String?,
    end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    id: json['id'] as String?,
  );
}

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'room': instance.room,
      'teachers': instance.teachers,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'duration': instance.duration,
      'canceled': instance.canceled,
      'status': instance.status,
      'groups': instance.groups,
      'content': instance.content,
      'discipline': instance.discipline,
      'disciplineCode': instance.disciplineCode,
      'id': instance.id,
    };

AgendaReminder _$AgendaReminderFromJson(Map<String, dynamic> json) {
  return AgendaReminder(
    json['lessonID'] as String?,
    json['name'] as String?,
    _$enumDecodeNullable(_$alarmTypeEnumMap, json['alarm']),
    json['id'] as String?,
    description: json['description'] as String?,
    tagColor: json['tagColor'] as int?,
  );
}

Map<String, dynamic> _$AgendaReminderToJson(AgendaReminder instance) =>
    <String, dynamic>{
      'lessonID': instance.lessonID,
      'name': instance.name,
      'description': instance.description,
      'alarm': _$alarmTypeEnumMap[instance.alarm],
      'tagColor': instance.tagColor,
      'id': instance.id,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$alarmTypeEnumMap = {
  alarmType.none: 'none',
  alarmType.exactly: 'exactly',
  alarmType.fiveMinutes: 'fiveMinutes',
  alarmType.fifteenMinutes: 'fifteenMinutes',
  alarmType.thirtyMinutes: 'thirtyMinutes',
  alarmType.oneDay: 'oneDay',
};

AgendaEvent _$AgendaEventFromJson(Map<String, dynamic> json) {
  return AgendaEvent(
    json['start'] == null ? null : DateTime.parse(json['start'] as String),
    json['end'] == null ? null : DateTime.parse(json['end'] as String),
    json['name'] as String?,
    json['location'] as String?,
    (json['left'] as num?)?.toDouble(),
    (json['height'] as num?)?.toDouble(),
    json['canceled'] as bool?,
    json['id'] as String?,
    (json['width'] as num?)?.toDouble(),
    wholeDay: json['wholeDay'] as bool?,
    isLesson: json['isLesson'] as bool?,
    lesson: json['lesson'] == null
        ? null
        : Lesson.fromJson(json['lesson'] as Map<String, dynamic>),
    reminders: (json['reminders'] as List<dynamic>?)
        ?.map((e) => AgendaReminder.fromJson(e as Map<String, dynamic>))
        .toList(),
    description: json['description'] as String?,
    alarm: _$enumDecodeNullable(_$alarmTypeEnumMap, json['alarm']),
    color: json['color'] as int?,
    recurrenceScheme: json['recurrenceScheme'] as String?,
  );
}

Map<String, dynamic> _$AgendaEventToJson(AgendaEvent instance) =>
    <String, dynamic>{
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'name': instance.name,
      'location': instance.location,
      'left': instance.left,
      'height': instance.height,
      'width': instance.width,
      'canceled': instance.canceled,
      'id': instance.id,
      'reminders': instance.reminders,
      'isLesson': instance.isLesson,
      'lesson': instance.lesson,
      'description': instance.description,
      'alarm': _$alarmTypeEnumMap[instance.alarm],
      'wholeDay': instance.wholeDay,
      'color': instance.color,
      'recurrenceScheme': instance.recurrenceScheme,
    };
