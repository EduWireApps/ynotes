import 'dart:convert';

import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/consts/disciplinesFilter.dart';
import 'package:ynotes/core/logic/homework/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/globals.dart';

class HomeworkController extends ChangeNotifier {
  final api;
  List<Homework>? _old = [];
  List _hwCompletion = [100, 0, 0];
  List<Homework> unloadedHW = [];
  homeworkFilter currentFilter = homeworkFilter.ALL;
  API? _api;
  bool isFetching = false;
  int examsCount = 0;
  int tomorrowCount = 0;
  int weekCount = 0;

  HomeworkController(this.api) {
    _api = api;
  }
  List<Homework>? get getHomework => _old;

  ///Returns [donePercent, doneLength, length]
  List get homeworkCompletion => _hwCompletion;
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
          if (appSys.settings!["system"]["chosenParser"] == 0) {
            List<String> codeMatiere = FILTERS["literary"]["ED"];
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
            List<String> codeMatiere = FILTERS["literary"]["Pronote"];

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
          if (appSys.settings!["system"]["chosenParser"] == 0) {
            List<String> codeMatiere = FILTERS["sciences"]["ED"];
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
            List<String> codeMatiere = FILTERS["sciences"]["Pronote"];
            List<String> blackList = FILTERS["sciences"]["blacklist"];
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
          List codeMatiere =
              jsonDecode(appSys.settings?["user"]["homeworkPage"]["customDisciplinesList"] ?? "[]") ?? [];
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
    if (list != null) {
      list.removeWhere(
          (element) => element.date!.isBefore(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()))));
    }
    if (list != null) {
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
    } else {
      _hwCompletion = [100, 0, 0];
      notifyListeners();
    }
  }

  List<Homework>? homework({bool showAll = false}) => filterHW(_old, showAll);

  Future<void> loadAll() async {
    try {
      isFetching = true;
      notifyListeners();
      await Future.forEach(unloadedHW, (Homework hw) async {
        await _api!.getHomeworkFor(hw.date);
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
    if (hwList != null) {
      examsCount = hwList.where((element) => element.isATest!).length;
      notifyListeners();
    } else {
      examsCount = 0;
      notifyListeners();
    }
  }

//Load all events
  Future<void> prepareOld(List<Homework> oldHW) async {
    Future.forEach(oldHW, (Homework element) async {
      await element.files.load();
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
    print(unloadedHW);
    await loadAll();
  }

  void prepareTomorrowAndWeekCount() {
    List<Homework> hwList = (getHomework ?? []);
    if (hwList != null) {
      tomorrowCount = hwList.where((element) => CalendarTime(element.date).isTomorrow).length;
      weekCount = hwList.where((element) => CalendarTime(element.date).isLastWeek).length;

      notifyListeners();
    } else {
      tomorrowCount = 0;
      weekCount = 0;
      notifyListeners();
    }
  }

  Future<void> refresh({bool force = false, refreshFromOffline = false}) async {
    print("Refreshing homework " + (refreshFromOffline ? "from offline" : "online"));
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
