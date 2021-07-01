import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'models.g.dart';

@HiveType(typeId: 4)
class Lesson {
  //E.G : Salle 215
  @HiveField(0)
  final String? room;
  //E.G : Monsieur machin
  @HiveField(1)
  final List<String?>? teachers;
  //E.G : 9h30
  @HiveField(2)
  final DateTime? start;
  //E.G : 10h30
  @HiveField(3)
  final DateTime? end;

  ///E.G : 45 (minutes)
  @HiveField(4)
  final int? duration;
  @HiveField(5)
  final bool? canceled;
  //E.G : cours déplacé
  @HiveField(6)
  final String? status;
  //E.G : groupe C
  @HiveField(7)
  final List<String>? groups;
  //Description
  @HiveField(8)
  final String? content;
  @HiveField(9)
  final String? discipline;
  @HiveField(10)
  final String? disciplineCode;
  @HiveField(11)
  final String? id;

  Lesson({
    this.room,
    this.teachers,
    this.start,
    this.duration,
    this.canceled,
    this.status,
    this.groups,
    this.content,
    this.discipline,
    this.disciplineCode,
    this.end,
    this.id,
  });
}

@HiveType(typeId: 6)
//Associated with a lesson
class AgendaReminder {
  @HiveField(0)
  String? lessonID;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  AlarmType? alarm;
  @HiveField(4)
  int? tagColor;
  @HiveField(5)
  String? id;
  Color get realTagColor {
    return Color(tagColor!);
  }

  AgendaReminder(this.lessonID, this.name, this.alarm, this.id, {this.description, this.tagColor});
}

///Delay before the event for the alarm to be triggered
///`exactly` will trigger the alarm at the exact event start, `oneDay` will trigger the alarm
///at 7:00 pm the day before
@HiveType(typeId: 7)
enum AlarmType {
  @HiveField(0)
  none,
  @HiveField(1)
  exactly,
  @HiveField(2)
  fiveMinutes,
  @HiveField(3)
  fifteenMinutes,
  @HiveField(4)
  thirtyMinutes,
  @HiveField(5)
  oneDay,
}

///The agenda event, ALL events (lessons, custom events) should be converted in this class
@HiveType(typeId: 8)
class AgendaEvent {
  @HiveField(0)
  DateTime? start;
  @HiveField(1)
  DateTime? end;
  @HiveField(2)
  final String? name;
  //Place or room
  @HiveField(3)
  final String? location;
  @HiveField(4)
  double? left;
  @HiveField(5)
  final double? height;
  @HiveField(6)
  double? width;
  @HiveField(7)
  final bool? canceled;
  @HiveField(8)
  final String? id;
  @HiveField(9)
  final List<AgendaReminder>? reminders;
  @HiveField(10)
  final bool? isLesson;
  @HiveField(11)
  final Lesson? lesson;
  @HiveField(12)
  final String? description;
  @HiveField(13)
  final AlarmType? alarm;
  @HiveField(14)
  final bool? wholeDay;
  @HiveField(15)
  int? color;
  @HiveField(16)
  String? recurrenceScheme;

  bool collidesWith(AgendaEvent other) {
    return end!.isAfter(other.start!) && start!.isBefore(other.end!);
  }

  static eventsFromLessons(List<Lesson> data) {
    List<AgendaEvent> events = [];
    for (Lesson lesson in data) {
      bool wholeDay = false;
      if (lesson.start!.hour == 0 && lesson.end!.hour == 0) {
        wholeDay = true;
      }
      events.add(AgendaEvent(
          lesson.start, lesson.end, lesson.discipline, lesson.room, null, null, lesson.canceled, lesson.id, null,
          isLesson: true, lesson: lesson, wholeDay: wholeDay));
    }
    return events;
  }

  Color get realColor {
    return Color(color!);
  }

  AgendaEvent(
      this.start, this.end, this.name, this.location, this.left, this.height, this.canceled, this.id, this.width,
      {this.wholeDay = true,
      this.isLesson = false,
      this.lesson,
      this.reminders,
      this.description,
      this.alarm,
      this.color,
      this.recurrenceScheme});
}
