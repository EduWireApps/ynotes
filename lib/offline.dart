import 'dart:async';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/utils/fileUtils.dart';

import 'package:ynotes/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/usefulMethods.dart';
import 'apis/utils.dart';
import 'classes.dart';

///An offline class to deal with the `hivedb` package
///used to store offline data and stored values such as agenda events
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
  //Return agenda event
  Map<dynamic, dynamic> agendaEventsData;
  //Return recipients
  List<Recipient> recipientsData;
//Boxes containing offline data
  Box offlineBox;
  Box homeworkDoneBox;
  Box pinnedHomeworkBox;

  //Called when instanciated
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
      Hive.registerAdapter(AgendaEventAdapter());
      Hive.registerAdapter(RecipientAdapter());
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
      var offlineAgendaEventsData = await offlineBox.get("agendaEvents");
      var offlineRecipientsData = await offlineBox.get("recipients");
      //ensure that fetched data isn't null and if not, add it to the final value
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
      if (offlineAgendaEventsData != null) {
        this.agendaEventsData = Map<dynamic, dynamic>.from(offlineAgendaEventsData);
      }
      if (offlineRecipientsData != null) {
        this.recipientsData = offlineRecipientsData.cast<Recipient>();
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
      try {
        agendaEventsData.clear();
      } catch (e) {}
    } catch (e) {
      print("Failed to clear all db " + e.toString());
    }
  }

  ///Update existing disciplines (clear old data) with passed data
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

  ///Update existing offline homework with passed data
  ///if `add` boolean is set to true passed data is combined with old data
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

  ///Update existing offline lessons with passed data, `week` is used to
  ///shorten fetching delays, it should ALWAYS be from a same starting point
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
        timeTable.update(week, (value) => newData, ifAbsent: () => newData);
        await offlineBox.put("lessons", timeTable);
        await refreshData();
      }

      return true;
    } catch (e) {
      print("Error while updating offline lessons " + e.toString());
    }
  }

  ///Remove an agenda event with a given `id` and at a given `week`
  removeAgendaEvent(String id, var fetchID) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }

      Map<dynamic, dynamic> timeTable = Map();
      var offline = await offlineBox.get("agendaEvents");
      List<AgendaEvent> events = List();
      if (offline != null) {
        timeTable = Map<dynamic, dynamic>.from(await offlineBox.get("agendaEvents"));
      }
      if (timeTable == null) {
        timeTable = Map();
      } else {
        if (timeTable[fetchID] != null) {
          events.addAll(timeTable[fetchID].cast<AgendaEvent>());
          events.removeWhere((element) => element.id == id);
          print("Removed offline agenda event (fetchID : $fetchID, id: $id)");
        }
      }
      //Update the timetable
      timeTable.update(fetchID, (value) => events, ifAbsent: () => events);
      print(timeTable);
      await offlineBox.put("agendaEvents", timeTable);
      await refreshData();
    } catch (e) {
      print("Error while removing offline agenda events " + e.toString());
    }
  }

  ///Update existing agenda events with passed data
  addAgendaEvent(AgendaEvent newData, var id) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      if (newData != null) {
        print(newData);
        Map<dynamic, dynamic> timeTable = Map();
        var offline = await offlineBox.get("agendaEvents");
        List<AgendaEvent> events = List();
        if (offline != null) {
          timeTable = Map<dynamic, dynamic>.from(await offlineBox.get("agendaEvents"));
        }
        if (timeTable == null) {
          timeTable = Map();
        } else {
          if (timeTable[id] != null) {
            events.addAll(timeTable[id].cast<AgendaEvent>());
            events.removeWhere((element) => element.id == newData.id);
          }
        }
        events.add(newData);
        //Update the timetable
        timeTable.update(id, (value) => events, ifAbsent: () => events);
        print(events);
        print(timeTable);
        await offlineBox.put("agendaEvents", timeTable);
        await refreshData();
      }
      print("Update offline agenda events (id : $id)");
    } catch (e) {
      print("Error while updating offline agenda events " + e.toString());
    }
  }

  ///Update existing polls (clear old data) with passed data
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

  updateRecipients(List<Recipient> newData) async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      var old = await offlineBox.get("recipients");
      newData.forEach((recipient) {
        old.removeWhere((a) => a.id == recipient.id);
      });

      await offlineBox.put("recipients", newData);
      await refreshData();
    } catch (e) {
      print("Error while updating recipients " + e.toString());
    }
  }

  ///Update existing reminders (clear old data) with passed data
  void updateReminder(AgendaReminder newData) async {
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

  ///Remove a reminder with its `id`
  void removeReminder(String id) async {
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
        offline.removeWhere((a) => a.id == id);
      }
      await offlineBox.put("reminders", offline);
      await refreshData();
    } catch (e) {
      print("Error while removing reminder " + e.toString());
    }
  }

  ///Set a homework date as pinned (or not)
  void setPinnedHomeworkDate(String date, bool value) async {
    try {
      pinnedHomeworkBox.put(date, value);
    } catch (e) {
      print("Error during the setPinnedHomeworkDateProcess $e");
    }
  }

  ///Get pinned homework dates
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

  ///Get homework pinned status for a given `date`
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

  ///Get periods from DB (a little bit messy but totally functional)
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

  Future<List<AgendaEvent>> agendaEvents(int week, {var selector}) async {
    try {
      if (selector == null) {
        if (agendaEventsData != null && agendaEventsData[week] != null) {
          List<AgendaEvent> agendaEvents = List();
          agendaEvents.addAll(agendaEventsData[week].cast<AgendaEvent>());
          return agendaEvents;
        } else {
          await refreshData();
          if (agendaEventsData != null && agendaEventsData[week] != null) {
            List<AgendaEvent> agendaEvents = List();
            agendaEvents.addAll(agendaEventsData[week].cast<AgendaEvent>());
            return agendaEvents;
          } else {
            return null;
          }
        }
      } else {
        if (agendaEventsData != null) {
          var values = agendaEventsData.keys;
          var selectedValues = values.where(await selector);
          if (selectedValues != null) {
            List<AgendaEvent> agendaEvents = List();

            selectedValues.forEach((element) {
              agendaEvents.addAll(agendaEventsData[element].cast<AgendaEvent>());
              print(agendaEvents);
            });
            return agendaEvents;
          } else {
            return null;
          }
        } else {
          await refreshData();
          if (agendaEventsData != null) {
            var values = agendaEventsData.keys;
            var selectedValues = values.where(await selector);
            if (selectedValues != null) {
              List<AgendaEvent> agendaEvents = List();

              selectedValues.forEach((element) {
                agendaEvents.addAll(agendaEventsData[element].cast<AgendaEvent>());
              });
              return agendaEvents;
            }
          } else {
            return null;
          }
        }
      }
    } catch (e) {
      print("Error while returning agenda events for week $week " + e.toString());
      return null;
    }
  }

  Future<List<Recipient>> recipients() async {
    try {
      if (recipientsData != null) {
        return recipientsData;
      } else {
        await refreshData();
        return recipientsData.cast<Recipient>();
      }
    } catch (e) {
      print("Error while returning recipients " + e.toString());
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
