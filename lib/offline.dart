import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'apiManager.dart';
import 'dart:io';
import 'dart:convert';
import 'package:ynotes/usefulMethods.dart';

//To put grades in db
putGrades(List<Discipline> listD) async {
  try {
    final dir = await getDirectory();
    await Hive.init("${dir.path}/offline");

    try {
      Hive.registerAdapter(gradeAdapter());
      Hive.registerAdapter(disciplineAdapter());
    } catch (e) {
      //OVERRIDE THE ADAPTER ALREADY REGISTERED ERROR
    }

    //Format the actual date
    var now = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()).toString();

    var gradesBox = await Hive.openBox('grades');

    print("clearing grades");
    await gradesBox.clear();

    await gradesBox.put(now, listD);
    print("The offline grades save succeeded.");
    await gradesBox.close();
  } catch (e) {
    print("Failed to save grades offline : $e");
    await logFile("Failed to save grades offline" + "\n" + e.toString());
  }
}

//To get grades in db
getGradesFromDB({bool online = true}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  try {
    try {
      Hive.registerAdapter(gradeAdapter());
      Hive.registerAdapter(disciplineAdapter());
    } catch (e) {
      //OVERRIDE THE ADAPTER ALREADY REGISTERED ERROR

    }
    final dir = await getDirectory();
    await Hive.init("${dir.path}/offline");
    var gradesBox = await Hive.openBox('grades');

    DateTime now = DateTime.parse(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()));
    //The date of the offline grades file
    Map<dynamic, dynamic> gradesBoxMap = await gradesBox.toMap();
    //Is economy mode activated
    bool batterySaver = await getSetting("batterySaver");
    String dateOfflineString = gradesBoxMap.keys.toList()[0];

    DateTime dateOffline = DateTime.parse(dateOfflineString);

    var difference = now.difference(dateOffline);
//if offline force show homework
    if (difference.inHours < (batterySaver ? 24 : 6)) {
      Map<dynamic, dynamic> mapToReturn;
      try {
        print("Returned grades from offline");

        List<Discipline> listToReturn = gradesBox.getAt(0).cast<Discipline>();
        return listToReturn;
      } catch (e) {
        print("Failed to get grades offline data");
        await logFile("Failed to get grades offline data" + "\n" + e.toString());

        return null;
      }
    } else {
      if (online == true) {
        print("Offline grades data is too old of ${difference.inHours - (batterySaver ? 8 : 3)} hours.");
        return null;
      } else {
        try {
          //Force the cast
          List<Discipline> listToReturn = gradesBox.getAt(0).cast<Discipline>();

          return listToReturn;
        } catch (e) {
          print("Failed to decode grades offline data $e");

          return null;
        }
      }
    }
    
  } catch (e) {
    print("Getting grades from offline returned null : $e");
    return null;
  }
}

//To put homework in db
putHomework(List<Homework> listHW, {bool add = false}) async {
  try {
    final dir = await getDirectory();
    await Hive.init("${dir.path}/offline");

    try {
      Hive.registerAdapter(documentAdapter());
      Hive.registerAdapter(homeworkAdapter());
    } catch (e) {
      //OVERRIDE THE ADAPTER ALREADY REGISTERED ERROR
    }

    //Format the actual date
    var now = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()).toString();

    var homeworkBox = await Hive.openBox('homework');
    if (add == false) {
      print("clearing homework");
      await homeworkBox.clear();
    }

    if (homeworkBox.keys.contains(now) && add == true) {
      print("here");

      List<Homework> oldHW = homeworkBox.getAt(0).cast<Homework>();

      List<Homework> combinedList = oldHW + listHW;
      combinedList = combinedList.toSet().toList();

      await homeworkBox.put(now, combinedList);
    } else {
      await homeworkBox.put(now, listHW);
    }

    print("The offline homework save succeeded.");
  } catch (e) {
    print("Failed to save homework offline : $e");
    await logFile("Failed to save homework offline" + "\n" + e.toString());
  }
}

//To get homework in db
getHomeworkFromDB({bool online = true}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  try {
    try {
      Hive.registerAdapter(documentAdapter());
      Hive.registerAdapter(homeworkAdapter());
    } catch (e) {
      //OVERRIDE THE ADAPTER ALREADY REGISTERED ERROR

    }

    final dir = await getDirectory();
    Hive.init("${dir.path}/offline");
    var homeworkBox = await Hive.openBox('homework');
    //Is economy mode activated
    bool batterySaver = await getSetting("batterySaver");
    DateTime now = DateTime.parse(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()));

//The date of the offline grades file
    Map<dynamic, dynamic> homeworkBoxMap = homeworkBox.toMap();

    String dateOfflineString = homeworkBoxMap.keys.toList()[0];

    DateTime dateOffline = DateTime.parse(dateOfflineString);
    var difference = now.difference(dateOffline);
//If time difference is bigger, return null and the user have to fetch from Internet
    if (difference.inHours < (batterySaver ? 24 : 6)) {
      try {
        print("Returned homework from offline");
        List<Homework> listToReturn = homeworkBox.getAt(0).cast<Homework>();

        return listToReturn;
      } catch (e) {
        print("Failed to get homework offline data $e");
        await logFile("Failed to get homework offline" + "\n" + e.toString());

        return null;
      }
    } else {
      if (online == true) {
        print("Offline homework data is too old of ${difference.inHours - (batterySaver ? 8 : 3)} hours.");
        return null;
      } else {
        try {
          //Force the cast
          List<Homework> listToReturn = homeworkBox.getAt(0).cast<Homework>();

          return listToReturn;
        } catch (e) {
          print("Failed to decode homework offline data $e");

          return null;
        }
      }
    }
  } catch (e) {
    print("Getting homework from offline returned null : $e");

    return null;
  }
}

//Set the homework completion (done or not)
setHomeworkCompletion(String id, bool done) async {
  try {
    final dir = await getDirectory();
    Hive.init("${dir.path}/offline");
    var homeworkDoneBox = await Hive.openBox('doneHomework');
    homeworkDoneBox.put(id.toString(), done);
  } catch (e) {
    print("Error during the setHomeworkDoneProcess $e");
  }
}

//Get the homework completion (done or not)
Future<bool> getHomeworkCompletion(String id) async {
  try {
    final dir = await getDirectory();
    Hive.init("${dir.path}/offline");
    var homeworkDoneBox = await Hive.openBox('doneHomework');

    bool toReturn = homeworkDoneBox.get(id.toString());

    //If to return is null return false
    return (toReturn != null) ? toReturn : false;
  } catch (e) {
    print("Error during the getHomeworkDoneProcess $e");

    return null;
  }
}

//Set a new pinned homework or delete it (by calling it a new time)
setPinnedHomeworkDate(String date, bool value) async {
  try {
    final dir = await getDirectory();
    Hive.init("${dir.path}/offline");
    var pinnedHomeworkBox = await Hive.openBox('pinnedHomework');

    pinnedHomeworkBox.put(date, value);
  } catch (e) {
    print("Error during the setPinnedHomeworkDateProcess $e");
  }
}

getPinnedHomeworkDates() async {
  try {
    final dir = await getDirectory();
    Hive.init("${dir.path}/offline");
    var pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
    Map notParsedList = pinnedHomeworkBox.toMap();
    List<DateTime> parsedList = List<DateTime>();
    notParsedList.removeWhere((key, value) => value == false);
    notParsedList.keys.forEach((element) {
      parsedList.add(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.parse(element))));
    });
    return parsedList;
  } catch (e) {
    print("Error during the getPinnedHomeworkDateProcess $e");
  }
}

Future<bool> getPinnedHomeworkSingleDate(String date) async {
  try {
    final dir = await getDirectory();
    Hive.init("${dir.path}/offline");
    var pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
    bool toReturn = pinnedHomeworkBox.get(date);

    //If to return is null return false
    return (toReturn != null) ? toReturn : false;
  } catch (e) {
    print("Error during the getHomeworkDoneProcess $e");

    return null;
  }
}
