import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/EcoleDirecte/converters/disciplines.dart';
import 'package:ynotes/core/apis/EcoleDirecte/converters/mail.dart';
import 'package:ynotes/core/apis/EcoleDirecte/convertersExporter.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/models.dart';

class EcoleDirecteConverter {
  //MAIL
  static Mail mail(Map<String, dynamic> mailData) => EcoleDirecteMailConverter.mail(mailData);

  static List<Recipient> recipients(var recipientsData) => EcoleDirecteMailConverter.recipients(recipientsData);

  //DISCIPLINES

  static List<Discipline> disciplines(Map<String, dynamic> disciplinesData) =>
      EcoleDirecteDisciplineConverter.disciplines(disciplinesData);

  static List<Period> periods(Map<String, dynamic> periodsData) => EcoleDirecteAccountConverter.periods(periodsData);

  //HW
  static List<DateTime> homeworkDates(Map<String, dynamic> hwDatesData) =>
      EcoleDirecteHomeworkConverter.homeworkDates(hwDatesData);

  static List<Homework> unloadedHomework(Map<String, dynamic> uhwData) =>
      EcoleDirecteHomeworkConverter.unloadedHomework(uhwData);
  static List<Homework> homework(Map<String, dynamic> hwData) => EcoleDirecteHomeworkConverter.homework(hwData);
  static Future<List<Lesson>> lessons(Map<String, dynamic> lessonData) =>
      EcoleDirecteLessonConverter.lessons(lessonData);

  //APPS

  static List<CloudItem> cloudFolders(var cloudFoldersData) =>
      EcoleDirecteCloudConverter.cloudFolders(cloudFoldersData);

  static List<SchoolLifeTicket> schoolLife(Map<String, dynamic> schoolLifeData) =>
      EcoleDirecteSchoolLifeConverter.schoolLife(schoolLifeData);

  //UTILS
  static List<Document> documents(var filesData) => EcoleDirecteDocumentConverter.documents(filesData);
}
