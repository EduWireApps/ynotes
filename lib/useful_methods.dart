import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/globals.dart';


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
      list.forEach((element) {
        element.gradesList?.forEach((grade) {
          if (!listToReturn.contains(grade)) {
            listToReturn.add(grade);
          }
        });
      });
      if (appSys.api!.gradesList != null &&
          (appSys.api!.gradesList ?? []).length > 0 &&
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

//Redefine the switch statement
Future<String?> readStorage(_key) async {
  String? u = await storage.read(key: _key);
  return u;
}

Future<List<Discipline>> refreshDisciplinesListColors(List<Discipline> list) async {
  List<Discipline> newList = [];
  list.forEach((f) async {
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
      var begin = Offset(1.0, 0.0);
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

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
  bool hasConnection = false;

  //This is what's used to retrieve the instance through the app
  StreamController connectionChangeController = new StreamController.broadcast();

  //This tracks the current connection status
  final Connectivity _connectivity = Connectivity();

  //This is how we'll allow subscribing to connection changes
  ConnectionStatusSingleton._internal();

  //flutter_connectivity
  Stream get connectionChange => connectionChangeController.stream;

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }

  void dispose() {
    connectionChangeController.close();
  }

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  static ConnectionStatusSingleton getInstance() => _singleton;
}
