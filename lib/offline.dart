import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'apiManager.dart';
import 'dart:io';
import 'dart:convert';
import 'package:ynotes/usefulMethods.dart';

//To put grades in db
putGrades(String string) async {
  final dir = await getDirectory();
  await Hive.init("${dir.path}/offline");
  //Format the actual date
  var now = DateFormat("yyyy-MM-dd H:mm").format(DateTime.now()).toString();

  var gradesBox = await Hive.openBox('grades');
  await gradesBox.clear();
  await gradesBox.put(now, string);
}

//To get grades in db
getGradesFromDB() async {
  try {
    final dir = await getDirectory();
    await Hive.init("${dir.path}/offline");
    var gradesBox = await Hive.openBox('grades');

    DateTime now = DateTime.now();
    //The date of the offline grades file
    Map<dynamic, dynamic> gradesBoxMap = await gradesBox.toMap();
    String dateOfflineString = gradesBoxMap.keys.toList()[0];
    //print(dateOfflineString);
    DateTime dateOffline = DateTime.parse(dateOfflineString);
    //print(dateOffline.toString());
    var difference = now.difference(dateOffline);

    if (difference.inHours < 3) {
      Map<dynamic, dynamic> mapToReturn;
      try {
        String jsonString = gradesBoxMap.values.toList()[0];
        return json.decode(jsonString);
      } catch (e) {
        print("Failed to decode grades offline data");
        return null;
      }
    } else {
      print(
          "Offline grades data is too old of ${difference.inHours - 3} hours.");
      return null;
    }
  } catch (e) {
    print("Getting grades from offline returned null : $e");
    return null;
  }
}

//To put homework in db
putHomework(List<homework> listHW) async {
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

    var gradesBox = await Hive.openBox('homework');
    await gradesBox.clear();
    await gradesBox.put(now, listHW);
    print("The offline homework save succeeded.");
  } catch (e) {
    print("Failed to save homework offline : $e");
  }
}

//To get homework in db
getHomeworkFromDB({bool online = true}) async {
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

    DateTime now =
        DateTime.parse(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()));

//The date of the offline grades file
    Map<dynamic, dynamic> homeworkBoxMap = homeworkBox.toMap();

    String dateOfflineString = homeworkBoxMap.keys.toList()[0];

    DateTime dateOffline = DateTime.parse(dateOfflineString);
    var difference = now.difference(dateOffline);
//If time difference is bigger, return null and the user have to fetch from Internet
    if (difference.inHours < 3) {
      try {
        print("Returned homework from offline");
        List<homework> listToReturn = homeworkBox.getAt(0).cast<homework>();
        return listToReturn;
      } catch (e) {
        print("Failed to decode homework offline data $e");
        return null;
      }
    } else {
      if (online == true) {
        print(
            "Offline homework data is too old of ${difference.inHours - 3} hours.");
        return null;
      } else {
        try {
          //Force the cast
          List<homework> listToReturn = homeworkBox.getAt(0).cast<homework>();
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
    
   bool toReturn =  homeworkDoneBox.get(id.toString());


   //If to return is null return false
  return (toReturn!=null)?toReturn:false;

  } catch (e) {
    print("Error during the getHomeworkDoneProcess $e");

    return null;
  }
}

