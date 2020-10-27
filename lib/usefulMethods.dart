import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';

import 'UI/screens/summaryPage.dart';

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "L'adresse $url n'a pas pu être ouverte";
  }
}

//Parsers list
List parsers = ["EcoleDirecte", "Pronote"];

int chosenParser;

bool isDarkModeEnabled = false;

//Change notifier to deal with themes
class AppStateNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    isDarkModeEnabled = isDarkMode;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: isDarkModeEnabled ? Color(0xff414141) : Color(0xffF3F3F3), statusBarColor: Colors.transparent // navigation bar color
        // status bar color
        ));

    notifyListeners();
  }
}

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

///Color theme switcher, actually 0 for darkmode and 1 for lightmode
int colorTheme = 0;
String actualUser = "";

Future<bool> getSetting(String setting) async {
  final prefs = await SharedPreferences.getInstance();
  bool value = prefs.getBool(setting);
  if (value == null) {
    setSetting(setting, false);
    value = false;
  }
  return value;
}

setSetting(String setting, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(setting, value);
}

Future<int> getIntSetting(String setting) async {
  final prefs = await SharedPreferences.getInstance();
  var value = prefs.getInt(setting);
  if (value == null) {
    value = 0;
    if (setting == "summaryQuickHomework") {
      value = 10;
    }
    if (setting == "lessonReminderDelay") {
      value = 5;
    }
    setIntSetting(setting, value);
  }
  return value;
}

setIntSetting(String setting, int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt(setting, value);
}

///Make the selected color darker
Color darken(Color color, {double forceAmount}) {
  double amount = 0.05;
  var ColorTest = TinyColor(color);
  //Test if the color is not too light
  if (forceAmount == null) {
    if (ColorTest.isLight()) {
      amount = 0.2;
    }
    //Test if the color is something like yellow
    if (ColorTest.getLuminance() > 0.5) {
      amount = 0.2;
    }
    if (ColorTest.getLuminance() < 0.5) {
      amount = 0.18;
    }
  } else {
    amount = forceAmount;
  }
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}



//Connectivity  classs

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = new StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
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
}

List<Grade> allGradesOld;
//Get only grades as a list
List<Grade> getAllGrades(List<Discipline> list, {bool overrideLimit = false}) {
  List<Grade> listToReturn = List();
  list.forEach((element) {
    element.gradesList.forEach((grade) {
      if (!listToReturn.contains(grade)) {
        listToReturn.add(grade);
      }
    });
  });
  if (localApi.gradesList != null && localApi.gradesList.length > 0 && listToReturn.length == localApi.gradesList.length) {
    return localApi.gradesList;
  }
  listToReturn = listToReturn.toSet().toList();
  //print("Refreshing all grades");
  if (chosenParser == 0) {
    listToReturn.sort((a, b) => a.dateSaisie.compareTo(b.dateSaisie));
  } else {
    listToReturn.sort((a, b) {
      //Format dates and compare
      var adate = DateFormat("dd/MM/yyyy").parse(a.date);
      var bdate = DateFormat("dd/MM/yyyy").parse(b.date);

      return adate.compareTo(bdate);
    });
  }

  listToReturn = listToReturn.reversed.toList();
  if (localApi.gradesList == null) {
    localApi.gradesList = List<Grade>();
  }
  localApi.gradesList.clear();
  localApi.gradesList.addAll(listToReturn);

  if (overrideLimit == false && listToReturn != null) {
    listToReturn = listToReturn.sublist(0, (listToReturn.length >= 5) ? 5 : listToReturn.length);
  }

  return listToReturn;
}

//Redefine the switch statement
TValue case2<TOptionType, TValue>(
  TOptionType selectedOption,
  Map<TOptionType, TValue> branches, [
  TValue defaultValue = null,
]) {
  if (!branches.containsKey(selectedOption)) {
    return defaultValue;
  }

  return branches[selectedOption];
}

List<Discipline> specialities = List<Discipline>();
//Refresh colors
Future<List<Discipline>> refreshDisciplinesListColors(List<Discipline> list) async {
  List<Discipline> newList = List<Discipline>();
  list.forEach((f) async {
    f.color = await getColor(f.codeMatiere);
    newList.add(f);
  });
  return newList;
}

//Leave app
exitApp() async {
  try {
    await offline.clearAll();
    //Delete sharedPref
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    //Import secureStorage
    final storage = new FlutterSecureStorage();
    //Delete all
    await storage.deleteAll();
    isDarkModeEnabled = false;
    //delete hive files
    localApi.gradesList = null;
    localApi = null;
    firstStart = true;
  } catch (e) {
    print(e);
  }
}

specialtiesSelectionAvailable() async {
  await getChosenParser();
  return [false];
  if (chosenParser == 0) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String classe = await storage.read(key: "classe") ?? "";

//E.G : It is always something like "Première blabla"
    var split = classe.split(" ");

    if (split[0] == "PremiÃ¨re" || split[0] == "Terminale") {
      return [true, (split[0] == "PremiÃ¨re") ? "Première" : split[0]];
    } else {
      return [false];
    }
  } else {
    return [false];
  }
}

getEventColor(String eventID) {
  return Colors.blue;
}

ReadStorage(_key) async {
  String u = await storage.read(key: _key);

  return u;
}
