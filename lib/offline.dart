import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:ynotes/parsers/Pronote/PronoteAPI.dart';
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
  //Return polls
  List<PollInfo> pollsData;
  Box _offlineBox;
  Box _homeworkDoneBox;
  Box _pinnedHomeworkBox;
  init() async {
    final dir = await FolderAppUtil.getDirectory();
    Hive.init("${dir.path}/offline");
    //Register adapters once
    try {
      Hive.registerAdapter(GradeAdapter());
      Hive.registerAdapter(DisciplineAdapter());
      Hive.registerAdapter(DocumentAdapter());
      Hive.registerAdapter(HomeworkAdapter());
      Hive.registerAdapter(LessonAdapter());
      Hive.registerAdapter(PollInfoAdapter());
    } catch (e) {
      print("Error " + e.toString());
    }
    _offlineBox = await Hive.openBox("offlineData");
    _homeworkDoneBox = await Hive.openBox('doneHomework');
    _pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
  }

  //Refresh lists when needed
  refreshData() async {
    print("Refreshing offline");
    try {
      if (!_offlineBox.isOpen) {
        _offlineBox = await Hive.openBox("offlineData");
      }
      //Get data and cast it
      var offlineLessons = await _offlineBox.get("lessons");
      var offlineDisciplines = await _offlineBox.get("disciplines");
      var offlinehomeworkData = await _offlineBox.get("homework");
      var offlinePollsData = await _offlineBox.get("polls");

      if (offlineLessons != null) {
        this.lessonsData = Map<dynamic, dynamic>.from(offlineLessons);
      }
      if (offlineDisciplines != null) {
        this.disciplinesData = offlineDisciplines.cast<Discipline>();
      }
      if (offlinehomeworkData != null) {
        this.homeworkData = offlinehomeworkData.cast<Homework>();
      }
      if (offlinePollsData != null) {
        this.pollsData = offlinePollsData.cast<PollInfo>();
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
      disciplinesData.clear();
      homeworkData.clear();
      lessonsData.clear();
      pollsData.clear();
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

        List<Homework> combinedList = List();
        combinedList.addAll(oldHW);
        newData.forEach((newdataelement) {
          if (!combinedList.any((clistelement) => clistelement.idDevoir == newdataelement.idDevoir)) {
            combinedList.add(newdataelement);
          }
        });
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
        print("Update offline lessons (week : $week, length : ${newData.length})");
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

  updatePolls(List<PollInfo> newData) async {
    print("Update offline polls (length : ${newData.length})");
    try {
      if (!_offlineBox.isOpen) {
        _offlineBox = await Hive.openBox("offlineData");
      }
      await _offlineBox.delete("polls");
      await _offlineBox.put("polls", newData);
      await refreshData();
    } catch (e) {
      print("Error while updating polls " + e.toString());
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
      print("Error during the getPinnedHomeworkProcess $e");

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

  periods() async {
    try {
      List<Period> listPeriods = List();
      List<Discipline> disciplines = await this.disciplines();
      List<Grade> grades = getAllGrades(disciplines, overrideLimit: true);

      grades.forEach((grade) {
        if (!listPeriods.any((period) => period.name == grade.nomPeriode && period.id == grade.codePeriode)) {
          if (grade.nomPeriode != null && grade.nomPeriode != "") {
            listPeriods.add(Period(grade.nomPeriode, grade.codePeriode));
          } else {}
        }
      });
      try {
        listPeriods.sort((a, b) => a.name.compareTo(b.name));
      } catch (e) {
        print(e);
      }

      return listPeriods;
    } catch (e) {
      throw ("Error while collecting offline periods " + e.toString());
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
      print("Error while returning homework " + e.toString());
      return null;
    }
  }

  Future<List<Lesson>> lessons(int week) async {
    try {
      if (lessonsData != null && lessonsData[week] != null) {
        return lessonsData[week].cast<Lesson>();
      } else {
        await refreshData();
        return lessonsData[week].cast<Lesson>();
      }
    } catch (e) {
      print("Error while returning lessons " + e.toString());
      return null;
    }
  }

  Future<List<PollInfo>> polls() async {
    try {
      if (pollsData != null) {
        return pollsData;
      } else {
        await refreshData();
        return pollsData.cast<PollInfo>();
      }
    } catch (e) {
      print("Error while returning polls " + e.toString());
      return null;
    }
  }

  Future<bool> getHWCompletion(String id) async {
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
