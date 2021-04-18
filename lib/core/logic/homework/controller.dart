import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/homework/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/globals.dart';

class HomeworkController extends ChangeNotifier {
  final api;
  List<Homework>? _old = [];
  List _hwCompletion = [100, 0, 0];
  List<Homework> unloadedHW = [];
  API? _api;
  bool isFetching = false;
  int examsCount = 0;

  ///Returns [donePercent, doneLength, length]
  List get homeworkCompletion => _hwCompletion;
  List<Homework>? get getHomework => _old;

  Future<void> refresh({bool force = false, refreshFromOffline = false}) async {
    print("Refreshing homework " + (refreshFromOffline ? "from offline" : "online"));
    isFetching = true;
    notifyListeners();
    //ED
    if (refreshFromOffline) {
      _old = await HomeworkUtils.getReducedListHomework();
      _old!.sort((a, b) => a.date!.compareTo(b.date!));
      notifyListeners();
    } else {
      _old = await HomeworkUtils.getReducedListHomework(forceReload: force);
      _old!.sort((a, b) => a.date!.compareTo(b.date!));
      notifyListeners();
    }

    await prepareOld(_old!);
    isFetching = false;
    notifyListeners();
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

        await Future.forEach(list, (dynamic element) async {
          bool isDone = await appSys.offline.doneHomework.getHWCompletion(element.id);
          if (isDone) {
            done++;
          }
        });
        int percent = (done * 100 / total).round();

        _hwCompletion = [percent, done, list.length];
        notifyListeners();
      }
    } else {
      _hwCompletion = [100, 0, 0];
      notifyListeners();
    }
  }

  //Load all events
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
      getHomeworkDonePercent();

      isFetching = false;
      notifyListeners();
    } catch (e) {
      prepareExamsCount();
      getHomeworkDonePercent();

      isFetching = false;
      notifyListeners();
    }
  }

  Future<void> prepareOld(List<Homework> oldHW) async {
    oldHW.forEach((element) {
      //remove duplicates
      if (!element.loaded! &&
          !unloadedHW.any((unloadedelement) =>
              unloadedelement.rawContent == element.rawContent &&
              unloadedelement.disciplineCode == element.disciplineCode)) {
        //Add element at the end of the task
        try {
          unloadedHW.add(element);
        } catch (e) {}
      }
    });
    await loadAll();
  }

  void prepareExamsCount() {
    List<Homework> hwList = getHomework!;
    if (hwList != null) {
      examsCount = hwList.where((element) => element.isATest!).length;
      notifyListeners();
    } else {
      examsCount = 0;
      notifyListeners();
    }
  }

  HomeworkController(this.api) {
    _api = api;
  }
}
