// ignore_for_file: avoid_print
// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:ynotes/core/api.dart';

const String username = 'aaa';
const String password = 'aaa';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final api = EcoleDirecteApi();
  await api.init();
  print(api.metadata.name);
  final res0 = await api.authModule.login(username: username, password: password);
  print("Error: ${res0.error}");
  // print(api.authModule.account);

  // final res1 = await api.schoolLifeModule.fetch(online: true);
  // print("Error: ${res1.error}");
  // print(api.schoolLifeModule.tickets);
  // for (var s in api.schoolLifeModule.sanctions) {
  //   print("${s.reason} ${s.date}");
  // }

  // final res2 = await api.gradesModule.fetch(online: false);
  // print("Error: ${res2.error}");
  // for (var g in api.gradesModule.subjects
  //     .firstWhere((e) => e.id == "PHILO")
  //     .grades(api.gradesModule.grades, api.gradesModule.periods.firstWhere((e) => e.id == "A001"))) {
  //   print("${g.name} ${g.value}");
  // }
  // print(api.gradesModule.currentPeriod?.name);
  // print(api.gradesModule
  //     .calculateAverageFromGrades(api.gradesModule.currentPeriod?.grades(api.gradesModule.grades) ?? []));
  // print(api.gradesModule.calculateAverageFromGrades(api.gradesModule.periods[0].grades(api.gradesModule.grades)));
  // print(api.gradesModule.calculateAverageFromPeriod(api.gradesModule.periods[0]));
  // final res3 = await api.emailsModule.fetch(online: true);
  // print("Error: ${res3.error}");
  // print(api.emailsModule.emailsReceived.length);
  // print(api.emailsModule.emailsReceived.first.subject);
  // print(api.emailsModule.emailsReceived.first.content);
  // final res4 = await api.emailsModule.read(api.emailsModule.emailsReceived.first);
  // print("Error: ${res4.error}");
  // print(api.emailsModule.emailsReceived.first.subject);
  // print(api.emailsModule.emailsReceived.first.content);
  // print(api.emailsModule.recipients.firstWhere((e) => e.lastName == "CUEILLE").fullName);
  // print(api.emailsModule.emailsSent.length);
  // final Email emailToSend = Email.toSend(
  //     subject: "TEST 6",
  //     content: "body test",
  //     to: [api.emailsModule.recipients.firstWhere((e) => e.lastName == "CUEILLE")]);
  // final res5 = await api.emailsModule.send(emailToSend);
  // print("Error: ${res5.error}");
  // print(res5.data);
  // print(api.emailsModule.emailsSent.length);
  // print(api.emailsModule.emailsSent.last.subject);
  // print(api.homeworkModule.homework.length);
  api.documentsModule.addListener(() {
    print("${api.documentsModule.progress}%");
  });
  final res6 = await api.homeworkModule.fetch();
  print("Error: ${res6.error}");
  // print(api.homeworkModule.homework.length);
  // for (var h in api.homeworkModule.homework) {
  //   if (h.documents.isNotEmpty) {
  //     print("${h.subjectId} ${h.date}");
  //     print(h.documents.first.name);
  //     print("");
  //   }
  // }
  // final h = api.homeworkModule.homework.where((e) => e.documents(api.documentsModule.documents).isNotEmpty).toList();
  // final res8 = await api.documentsModule.download(h.first.documents(api.documentsModule.documents).first);
  // print("Error: ${res8.error}");
  // for (final d in api.documentsModule.documents) {
  //   print("${d.name}, ${d.isInBox}");
  // }
  // final res7 = await api.homeworkModule.fetch(online: true, date: api.homeworkModule.homework.first.date);
  // print("Error: ${res7.error}");
  // for (var h in api.homeworkModule.homework) {
  //   print("${h.subjectId} ${h.content}");
  // }
}
