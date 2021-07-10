import 'dart:convert';

import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/data/disciplines_filter.dart';
import 'package:ynotes/core/logic/homework/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

class HomeworkController extends ChangeNotifier {
  List<Homework>? _old = [];
  List _hwCompletion = [100, 0, 0];
  List<Homework> unloadedHW = [];
  homeworkFilter currentFilter = homeworkFilter.ALL;
  API? _api;
  bool isFetching = false;
  int examsCount = 0;
  int tomorrowCount = 0;
  int weekCount = 0;
  int doneThisWeek = 0;

  HomeworkController(API? api) {
    _api = api;
  }

  set api(API? api) {
    _api = api;
  }

  List<Homework>? get getHomework => _old;

  ///Returns [donePercent, doneLength, length]
  List get homeworkCompletion => _hwCompletion;

  List<Homework>? get pinned => _old?.where((element) => ((element.pinned ?? false))).toList();
  filterHW(List<Homework>? homeworkToFilter, showAll) {
    if (showAll == true || currentFilter == homeworkFilter.ALL) {
      return homeworkToFilter;
    }
    List<Homework> toReturn = [];
    (homeworkToFilter ?? []).forEach((f) {
      switch (currentFilter) {
        case homeworkFilter.ALL:
          toReturn.add(f);
          break;
        case homeworkFilter.LITERARY:
          if (appSys.settings.system.chosenParser == 0) {
            List<String> codeMatiere = filters["literary"]["ED"];
            if (codeMatiere.any((test) {
              if (test == f.disciplineCode) {
                return true;
              } else {
                return false;
              }
            })) {
              toReturn.add(f);
            }
          } else {
            List<String> codeMatiere = filters["literary"]["Pronote"];

            if (codeMatiere.any((test) {
              if (f.discipline!.contains(test)) {
                return true;
              } else {
                return false;
              }
            })) {
              toReturn.add(f);
            }
          }

          break;
        case homeworkFilter.SCIENCES:
          if (appSys.settings.system.chosenParser == 0) {
            List<String> codeMatiere = filters["sciences"]["ED"];
            if (codeMatiere.any((test) {
              if (test == f.disciplineCode) {
                return true;
              } else {
                return false;
              }
            })) {
              toReturn.add(f);
            }
          } else {
            List<String> codeMatiere = filters["sciences"]["Pronote"];
            List<String> blackList = filters["sciences"]["blacklist"];
            if (codeMatiere.any((test) {
              if (f.discipline!.contains(test) && !blackList.any((element) => f.discipline!.contains(element))) {
                return true;
              } else {
                return false;
              }
            })) {
              toReturn.add(f);
            }
          }
          break;
        case homeworkFilter.SPECIALTIES:
          break;

        case homeworkFilter.CUSTOM:
          List codeMatiere = jsonDecode(appSys.settings.user.homeworkPage.customDisciplinesList) ?? [];
          appSys.saveSettings();
          if (codeMatiere.any((test) {
            if (test == f.discipline) {
              return true;
            } else {
              return false;
            }
          })) {
            toReturn.add(f);
          }
          break;
      }
    });
    return toReturn;
  }

  void getHomeworkDonePercent() async {
    List<Homework> list = [];
    if (_old != null) {
      list.addAll(_old!);
    }
    //Remove antecedent hw
    list.removeWhere(
        (element) => element.date!.isBefore(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()))));
    //Number of elements in list
    int total = list.length;

    if (total == 0) {
      _hwCompletion = [100, 0, 0];
      notifyListeners();
    } else {
      int done = 0;

      done = list.where((element) => element.done ?? false).toList().length;

      int percent = (done * 100 / total).round();

      _hwCompletion = [percent, done, list.length];
      notifyListeners();
    }
  }

  List<Homework>? homework({bool showAll = false}) => filterHW(_old, showAll)?.where((Homework e) {
        if (e.date != null) {
          return !e.date!.isBefore(CalendarTime(DateTime.now()).startOfDay);
        } else {
          return false;
        }
      }).toList();

  Future<void> loadAll() async {
    try {
      isFetching = true;
      notifyListeners();
      await Future.forEach(unloadedHW, (Homework hw) async {
        await _api!.getHomeworkFor(hw.date, forceReload: true);
        try {
          unloadedHW.remove(hw);
        } catch (e) {}
        await refresh(refreshFromOffline: true);

        notifyListeners();
      });
      prepareExamsCount();
      prepareTomorrowAndWeekCount();

      getHomeworkDonePercent();

      isFetching = false;
      notifyListeners();
    } catch (e) {
      prepareExamsCount();
      prepareTomorrowAndWeekCount();

      getHomeworkDonePercent();

      isFetching = false;
      notifyListeners();
    }
  }

  //Load all events
  void prepareExamsCount() {
    List<Homework> hwList = (getHomework ?? []);
    examsCount = hwList.where((element) => element.isATest!).length;
    notifyListeners();
  }

//Load all events
  Future<void> prepareOld(List<Homework> oldHW) async {
    Future.forEach(oldHW, (Homework element) async {
      //remove duplicates
      if (!element.loaded! &&
          !unloadedHW.any((unloadedelement) =>
              unloadedelement.teacherName == element.teacherName &&
              unloadedelement.entryDate == element.entryDate &&
              unloadedelement.date == element.date &&
              unloadedelement.disciplineCode == element.disciplineCode)) {
        //Add element at the end of the task
        try {
          unloadedHW.add(element);
        } catch (e) {}
      }
    });
    CustomLogger.log("HOMEWORK", unloadedHW.toString());
    await loadAll();
  }

  void prepareTomorrowAndWeekCount() {
    List<Homework> hwList = (getHomework ?? []);
    tomorrowCount = hwList.where((element) => CalendarTime(element.date).isTomorrow).length;
    List<Homework> _weekHw = hwList.where((element) => CalendarTime(element.date).isNextWeek).toList();
    weekCount = _weekHw.length;
    doneThisWeek = _weekHw.where((w) => w.done == true).length;
    notifyListeners();
  }

  Future<void> refresh({bool force = false, refreshFromOffline = false}) async {
    CustomLogger.log("HOMEWORK", "Refreshing homework " + (refreshFromOffline ? "from offline" : "online"));
    isFetching = true;
    notifyListeners();
    if (refreshFromOffline) {
      _old = await HomeworkUtils.getReducedListHomework();
      _old!.sort((a, b) => a.date!.compareTo(b.date!));
      notifyListeners();
    } else {
      _old = await HomeworkUtils.getReducedListHomework(forceReload: force);
      (_old ?? []).sort((a, b) => a.date!.compareTo(b.date!));
      notifyListeners();
    }

    notifyListeners();
    await prepareOld((_old ?? []));
    isFetching = false;
    notifyListeners();
  }

  void ugradePriority(Homework hw) {
    try {
      if (!((hw.loaded) ?? true)) {
        unloadedHW.remove(hw);
        unloadedHW.insert(0, hw);
        notifyListeners();
      }
    } catch (e) {}
  }
}

enum homeworkFilter { CUSTOM, SPECIALTIES, LITERARY, SCIENCES, ALL }
