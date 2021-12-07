// ignore_for_file: avoid_print
// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:ynotes/packages/apis/ecole_directe/ecole_directe.dart';

import 'school_api_models/school_api_models.dart';

const String username = 'aaa';
const String password = 'aaa';

Future<void> main() async {
  List<X> getDifference<X>(List<X> x, List<X> y) {
    final int lx = x.length;
    final int ly = y.length;
    if (lx == ly) {
      return [];
    }
    final List<X> l1 = lx > ly ? x : y;
    final List<X> l2 = lx > ly ? y : x;
    return l1.toSet().difference(l2.toSet()).toList();
  }

  final List<Period> periods = [
    Period(
        id: "0",
        name: "name0",
        startDate: DateTime(2021),
        endDate: DateTime(2022),
        headTeacher: "headTeacher",
        overallAverage: 20,
        classAverage: 16,
        maxAverage: 20,
        minAverage: 8)
  ];
  final List<Period> _periods = [
    Period(
        id: "0",
        name: "name0",
        startDate: DateTime(2021),
        endDate: DateTime(2022),
        headTeacher: "headTeacher",
        overallAverage: 20,
        classAverage: 16,
        maxAverage: 20,
        minAverage: 8),
    Period(
        id: "1",
        name: "name1",
        startDate: DateTime(2021),
        endDate: DateTime(2022),
        headTeacher: "headTeacher",
        overallAverage: 20,
        classAverage: 16,
        maxAverage: 20,
        minAverage: 8)
  ];
  if (_periods.length != periods.length) {
    final List<Period> diff = getDifference(_periods, periods);
    if (diff.isNotEmpty) {
      if (_periods.length > periods.length) {
        periods.addAll(diff);
      } else {
        for (final p in diff) {
          periods.remove(p);
        }
      }
    }
  }
  print(periods);
  periods.sort((a, b) => a.startDate.compareTo(b.startDate));
  _periods.sort((a, b) => a.startDate.compareTo(b.startDate));
  for (int i = 0; i < periods.length; i++) {
    Period p = periods[i];
    final Period _p = _periods[i];
    if (p != _p) {
      print("true");
      p = _p;
    }
  }
  periods.sort((a, b) => a.startDate.compareTo(b.startDate));
  print(periods);

  //
  // WidgetsFlutterBinding.ensureInitialized();
  // final api = EcoleDirecteApi();
  // await api.init();
  // print(api.metadata.name);
  // final res0 = await api.authModule.login(username: username, password: password);
  // print("Error: ${res0.error}");
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
}
