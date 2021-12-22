import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/app/app.dart';

TValue? case2<TOptionType, TValue>(
  TOptionType selectedOption,
  Map<TOptionType, TValue> branches, [
  TValue? defaultValue,
]) {
  if (!branches.containsKey(selectedOption)) {
    return defaultValue;
  }

  return branches[selectedOption];
}

List<Grade>? getAllGrades(List<Discipline>? list, {bool overrideLimit = false, bool sortByWritingDate = true}) {
  if (appSys.api != null) {
    List<Grade> listToReturn = [];
    if (list != null) {
      for (var element in list) {
        element.gradesList?.forEach((grade) {
          if (!listToReturn.contains(grade)) {
            listToReturn.add(grade);
          }
        });
      }
      if (appSys.api!.gradesList != null &&
          (appSys.api!.gradesList ?? []).isNotEmpty &&
          listToReturn == appSys.api!.gradesList) {
        return appSys.api!.gradesList;
      }

      listToReturn = listToReturn.toSet().toList();

      //sort grades
      if (sortByWritingDate) {
        listToReturn
            .sort((a, b) => (a.entryDate != null && b.entryDate != null) ? (a.entryDate!.compareTo(b.entryDate!)) : 1);
      }

      //remove duplicates
      listToReturn = listToReturn.toSet().toList();
      listToReturn = listToReturn.reversed.toList();
      if (appSys.api!.gradesList == null) {
        appSys.api!.gradesList = [];
      }
      appSys.api!.gradesList?.clear();
      appSys.api!.gradesList?.addAll(listToReturn);

      if (overrideLimit == false) {
        listToReturn = listToReturn.sublist(0, ((listToReturn.length >= 5) ? 5 : listToReturn.length));
      }
      return listToReturn;
    } else {
      return [];
    }
  } else {
    return [];
  }
}

//Get only grades as a list
launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "L'adresse $url n'a pas pu être ouverte";
  }
}

Future<List<Discipline>> refreshDisciplinesListColors(List<Discipline> list) async {
  List<Discipline> newList = [];
  Future.forEach(list, (Discipline f) async {
    f.color = await getColor(f.disciplineCode);
    newList.add(f);
  });
  return newList;
}

//Refresh colors
Route router(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: Material(child: child),
      );
    },
  );
}
