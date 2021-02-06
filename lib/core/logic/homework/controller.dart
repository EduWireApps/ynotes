import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

HomeworkController hwcontroller;

class HomeworkController extends ChangeNotifier {
  final api;
  List<Homework> _old = List();
  List<Homework> unloadedHW = List<Homework>();
  API _api;
  bool isFetching = false;

  List<Homework> get getHomework => _old;

  Future<void> refresh({bool force = false, refreshFromOffline = false}) async {
    isFetching = true;
    notifyListeners();
    //ED
    if (refreshFromOffline) {
      _old = await _api.getNextHomework();
      _old.sort((a, b) => a.date.compareTo(b.date));
      notifyListeners();
    } else {
      _old = await _api.getNextHomework(forceReload: force);
      _old.sort((a, b) => a.date.compareTo(b.date));
      notifyListeners();
    }
    await prepareOld(_old);
    isFetching = false;
    notifyListeners();
  }

  //Load all events
  void loadAll() async {
    try {
      isFetching = true;
      notifyListeners();
      await Future.forEach(unloadedHW, (Homework hw) async {
        await _api.getHomeworkFor(hw.date);
        try {
          unloadedHW.remove(hw);
        } catch (e) {}
        await refresh(refreshFromOffline: true);

        notifyListeners();
      });
      isFetching = false;
      notifyListeners();
    } catch (e) {
      isFetching = false;
      notifyListeners();
    }
  }

  void prepareOld(List<Homework> oldHW) async {
    oldHW.forEach((element) {
      //remove duplicates
      if (!element.loaded &&
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

  HomeworkController(this.api) {
    _api = api;
    refresh();
  }
}
