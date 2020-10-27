import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:ynotes/UI/utils/hiveExportImportUtils.dart';
import 'package:ynotes/parsers/Pronote/PronoteAPI.dart';
import 'package:ynotes/usefulMethods.dart';
import 'UI/screens/spacePageWidgets/agendaGrid.dart';
import 'classes.dart';
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
  //Return agenda reminder
  List<AgendaReminder> remindersData;
  Box offlineBox;
  Box homeworkDoneBox;
  Box pinnedHomeworkBox;
  init() async {
    //Register adapters once
    try {
      Hive.registerAdapter(GradeAdapter());
      Hive.registerAdapter(DisciplineAdapter());
      Hive.registerAdapter(DocumentAdapter());
      Hive.registerAdapter(HomeworkAdapter());
      Hive.registerAdapter(LessonAdapter());
      Hive.registerAdapter(PollInfoAdapter());
      Hive.registerAdapter(AgendaReminderAdapter());
      Hive.registerAdapter(alarmTypeAdapter());
    } catch (e) {
      print("Error " + e.toString());
    }
    final dir = await FolderAppUtil.getDirectory();
    Hive.init("${dir.path}/offline");
    offlineBox = await Hive.openBox("offlineData");
    homeworkDoneBox = await Hive.openBox('doneHomework');
    pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
  }

  //Refresh lists when needed
  refreshData() async {
    print("Refreshing offline");
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      //Get data and cast it
      var offlineLessonsData = await offlineBox.get("lessons");
      var offlineDisciplinesData = await offlineBox.get("disciplines");
      var offlinehomeworkData = await offlineBox.get("homework");
      var offlinePollsData = await offlineBox.get("polls");
      var offlineRemindersData = await offlineBox.get("reminders");

      if (offlineLessonsData != null) {
        this.lessonsData = Map<dynamic, dynamic>.from(offlineLessonsData);
      }
      if (offlineDisciplinesData != null) {
        this.disciplinesData = offlineDisciplinesData.cast<Discipline>();
      }
      if (offlinehomeworkData != null) {
        this.homeworkData = offlinehomeworkData.cast<Homework>();
      }
      if (offlinePollsData != null) {
        this.pollsData = offlinePollsData.cast<PollInfo>();
      }
      if (offlineRemindersData != null) {
        this.remindersData = offlineRemindersData.cast<AgendaReminder>();
      }
    } catch (e) {
      print("Error while refreshing " + e.toString());
    }
  }

  //Clear all databases
  clearAll() async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      if (!homeworkDoneBox.isOpen) {
        homeworkDoneBox = await Hive.openBox("doneHomework");
      }
      if (!pinnedHomeworkBox.isOpen) {
        pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
      }
      try {
        await offlineBox.clear();
      } catch (e) {}
      try {
        await homeworkDoneBox.clear();
      } catch (e) {}
      try {
        await pinnedHomeworkBox.clear();
      } catch (e) {}
      try {
        disciplinesData.clear();
      } catch (e) {}
      try {
        remindersData.clear();
      } catch (e) {}
      try {
        homeworkData.clear();
      } catch (e) {}
      try {
        lessonsData.clear();
      } catch (e) {}
      try {
        pollsData.clear();
      } catch (e) {}
    } catch (e) {
      print("Failed to clear all db " + e.toString());
    }
  }

  updateDisciplines(List<Discipline> newData) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      print("Updating disciplines");
      await offlineBox.delete("disciplines");
      await offlineBox.put("disciplines", newData);
      await refreshData();
    } catch (e) {
      print("Error while updating disciplines " + e);
    }
  }

  updateHomework(List<Homework> newData, {bool add = false}) async {
    print("Update offline homework");
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      if (add == true && newData != null) {
        List<Homework> oldHW = offlineBox.get("homework").cast<Homework>();

        List<Homework> combinedList = List();
        combinedList.addAll(oldHW);
        newData.forEach((newdataelement) {
          if (!combinedList.any((clistelement) => clistelement.id == newdataelement.id)) {
            combinedList.add(newdataelement);
          }
        });
        combinedList = combinedList.toSet().toList();

        await offlineBox.put("homework", combinedList);
      } else {
        await offlineBox.put("homework", newData);
      }
      await refreshData();
    } catch (e) {
      print("Error while updating homework " + e.toString());
    }
  }

  updateLessons(List<Lesson> newData, int week) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      if (newData != null) {
        print("Update offline lessons (week : $week, length : ${newData.length})");
        Map<dynamic, dynamic> timeTable = Map();
        var offline = await offlineBox.get("lessons");
        if (offline != null) {
          timeTable = Map<dynamic, dynamic>.from(await offlineBox.get("lessons"));
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
        await offlineBox.put("lessons", timeTable);
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
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      await offlineBox.delete("polls");
      await offlineBox.put("polls", newData);
      await refreshData();
    } catch (e) {
      print("Error while updating polls " + e.toString());
    }
  }

  updateReminder(AgendaReminder newData) async {
    print("Update reminders");
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      var old = await offlineBox.get("reminders");
      List<AgendaReminder> offline = List();
      if (old != null) {
        offline = old.cast<AgendaReminder>();
      }
      if (offline != null) {
        offline.removeWhere((a) => a.id == newData.id);
      }
      offline.add(newData);
      print(offline);
      await offlineBox.put("reminders", offline);
      await refreshData();
    } catch (e) {
      print("Error while updating reminder " + e.toString());
    }
  }

  setPinnedHomeworkDate(String date, bool value) async {
    try {
      pinnedHomeworkBox.put(date, value);
    } catch (e) {
      print("Error during the setPinnedHomeworkDateProcess $e");
    }
  }

  getPinnedHomeworkDates() async {
    try {
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
      bool toReturn = pinnedHomeworkBox.get(date);

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
        List<Lesson> lessons = List();
        lessons.addAll(lessonsData[week].cast<Lesson>());
        return lessons;
      } else {
        await refreshData();
        if (lessonsData[week] != null) {
          List<Lesson> lessons = List();
          lessons.addAll(lessonsData[week].cast<Lesson>());
          return lessons;
        } else {
          return null;
        }
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

  Future<List<AgendaReminder>> reminders(String idLesson) async {
    try {
      if (remindersData != null) {
        return remindersData.where((element) => element.lessonID == idLesson).toList();
      } else {
        await refreshData();
        var toCollect = remindersData;
        if (toCollect != null) {
          toCollect = toCollect.where((element) => element.lessonID == idLesson).toList();
        }
        return toCollect;
      }
    } catch (e) {
      print("Error while returning agenda reminders " + e.toString());
      return null;
    }
  }

  Future<bool> getHWCompletion(String id) async {
    try {
      final dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offline");

      bool toReturn = homeworkDoneBox.get(id.toString());

      //If to return is null return false
      return (toReturn != null) ? toReturn : false;
    } catch (e) {
      print("Error during the getHomeworkDoneProcess $e");

      return false;
    }
  }

  setHWCompletion(String id, bool state) async {
    try {
      final dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offline");

      homeworkDoneBox.put(id.toString(), state);
    } catch (e) {
      print("Error during the setHomeworkDoneProcess $e");
    }
  }
}
