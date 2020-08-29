import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:ynotes/parsers/PronoteAPI.dart';
import 'package:ynotes/usefulMethods.dart';
import 'apiManager.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';

class Offline {
  //Return disciplines + grades
  List<Discipline> disciplinesData;
  //Return homework
  List<Homework> homeworkData;
  //Return lessons
  Map<dynamic, dynamic> lessonsData;
  Box _offlineBox;
  Box _homeworkDoneBox;
  Box _pinnedHomeworkBox;
  init() async {
    final dir = await FolderAppUtil.getDirectory();
    Hive.init("${dir.path}/offline");
    //Register adapters once
    Hive.registerAdapter(GradeAdapter());
    Hive.registerAdapter(DisciplineAdapter());
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(HomeworkAdapter());
    Hive.registerAdapter(LessonAdapter());
    _offlineBox = await Hive.openBox("offlineData");
    _homeworkDoneBox = await Hive.openBox('doneHomework');
    _pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
  }

  //Refresh lists when needed
  refreshData() async {
    try {
      if (!_offlineBox.isOpen) {
        _offlineBox = await Hive.openBox("offlineData");
      }
      //Get data and cast it
      var offlineLessons = await _offlineBox.get("lessons");
      var offlineDisciplines = await _offlineBox.get("disciplines");
      var offlinehomeworkData = await _offlineBox.get("homework");
      if (offlineLessons != null) {
        lessonsData = Map<dynamic, dynamic>.from(offlineLessons);
      }
      if (offlineDisciplines != null) {
        disciplinesData = offlineDisciplines.cast<Discipline>();
      }
      if (offlinehomeworkData != null) {
        homeworkData = offlinehomeworkData.cast<Homework>();
      }
    } catch (e) {
      print("Error while refreshing " + e.toString());
    }
  }

  //Clear all databases
  clearAll() async {
    try {
      if (!_offlineBox.isOpen) {
        _offlineBox = await Hive.openBox("offlineData");
      }
      if (!_homeworkDoneBox.isOpen) {
        _homeworkDoneBox = await Hive.openBox("doneHomework");
      }
      if (!_pinnedHomeworkBox.isOpen) {
        _pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
      }
      await _offlineBox.clear();
      await _homeworkDoneBox.clear();
      await _pinnedHomeworkBox.clear();
      disciplinesData = null;
      lessonsData = null;
      disciplinesData = null;
    } catch (e) {
      print("Failed to clear all db " + e.toString());
    }
  }

  updateDisciplines(List<Discipline> newData) async {
    try {
      if (!_offlineBox.isOpen) {
        _offlineBox = await Hive.openBox("offlineData");
      }
      print("Updating disciplines");
      await _offlineBox.delete("disciplines");
      await _offlineBox.put("disciplines", newData);
      await refreshData();
    } catch (e) {
      print("Error while updating disciplines " + e);
    }
  }

  updateHomework(List<Homework> newData, {bool add = false}) async {
    print("Update offline homework");
    try {
      if (!_offlineBox.isOpen) {
        _offlineBox = await Hive.openBox("offlineData");
      }
      if (add == true && newData != null) {
        List<Homework> oldHW = _offlineBox.get("homework").cast<Homework>();

        List<Homework> combinedList = oldHW + newData;
        combinedList = combinedList.toSet().toList();

        await _offlineBox.put("homework", combinedList);
      } else {
        await _offlineBox.put("homework", newData);
      }
      await refreshData();
    } catch (e) {
      print("Error while updating homework " + e.toString());
    }
  }

  updateLessons(List<Lesson> newData, int week) async {
    try {
      if (!_offlineBox.isOpen) {
        _offlineBox = await Hive.openBox("offlineData");
      }
      if (newData != null) {
        print("Update offline lessons (week : $week)");
        Map<dynamic, dynamic> timeTable = Map();
        var offline = await _offlineBox.get("lessons");
        if (offline != null) {
          timeTable = Map<dynamic, dynamic>.from(await _offlineBox.get("lessons"));
        }

        if (timeTable == null) {
          timeTable = Map();
        }

        int todayWeek = await get_week(DateTime.now());

        bool lighteningOverride = await getSetting("lighteningOverride");

        //Remove old lessons in order to lighten the db
        //Can be overriden in settings
        if (!lighteningOverride) {
          timeTable.removeWhere((key, value) {
            return ((key < todayWeek - 2) || key > todayWeek + 3);
          });

          print("Size reducing succeeded");
        }
        //Update the timetable
        timeTable.update(week, (value) => newData, ifAbsent: () {});
        await _offlineBox.put("lessons", timeTable);
        await refreshData();
      }

      return true;
    } catch (e) {
      print("Error while updating offline lessons " + e.toString());
    }
  }

  setPinnedHomeworkDate(String date, bool value) async {
    try {
      _pinnedHomeworkBox.put(date, value);
    } catch (e) {
      print("Error during the setPinnedHomeworkDateProcess $e");
    }
  }

  getPinnedHomeworkDates() async {
    try {
      Map notParsedList = _pinnedHomeworkBox.toMap();
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
      bool toReturn = _pinnedHomeworkBox.get(date);

      //If to return is null return false
      return (toReturn != null) ? toReturn : false;
    } catch (e) {
      print("Error during the getHomeworkDoneProcess $e");

      return null;
    }
  }

  //Used to get disciplines, from db or locally
  Future<List<Discipline>> disciplines() async {
    try {
      if (disciplinesData != null) {
        return disciplinesData;
      } else {
        await refreshData();
        return disciplinesData;
      }
    } catch (e) {
      print("Error while returning disciplines" + e.toString());
      return null;
    }
  }

  Future<List<Homework>> homework() async {
    try {
      if (homeworkData != null) {
        return homeworkData;
      } else {
        await refreshData();

        return homeworkData;
      }
    } catch (e) {
      print("Error while returning homework" + e.toString());
      return null;
    }
  }

  Future<List<Lesson>> lessons(int week) async {
    try {
      if (lessonsData != null) {
        return lessonsData[week].cast<Lesson>();
      } else {
        await refreshData();
        return lessonsData[week].cast<Lesson>();
      }
    } catch (e) {
      print("Error while returning lessons" + e.toString());
      return null;
    }
  }

  getHWCompletion(String id) async {
    try {
      final dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offline");

      bool toReturn = _homeworkDoneBox.get(id.toString());

      //If to return is null return false
      return (toReturn != null) ? toReturn : false;
    } catch (e) {
      print("Error during the getHomeworkDoneProcess $e");

      return null;
    }
  }

  setHWCompletion(String id, bool state) async {
    try {
      final dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offline");

      _homeworkDoneBox.put(id.toString(), state);
    } catch (e) {
      print("Error during the setHomeworkDoneProcess $e");
    }
  }
}
/*
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
        print(
            "Offline grades data is too old of ${difference.inHours - (batterySaver ? 8 : 3)} hours.");
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
        print(
            "Offline homework data is too old of ${difference.inHours - (batterySaver ? 8 : 3)} hours.");
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
*/
