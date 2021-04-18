import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/apis/Pronote/convertersExporter.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/usefulMethods.dart';

class PronoteMethod {
  Map locks = Map();
  PronoteClient client;
  final SchoolAccount account;
  final Offline _offlineController;

  PronoteMethod(this.client, this.account, this._offlineController);

  Future<List<SchoolAccount>?> accounts() async {}

  Future<List<CloudItem>?> cloudFolders() async {}

  fetchAnyData(dynamic onlineFetch, dynamic offlineFetch, String lockName,
      {bool forceFetch = false, isOfflineLocked = false}) async {
    //Test connection status
    var connectivityResult = await (Connectivity().checkConnectivity());
    //Offline
    if (connectivityResult == ConnectivityResult.none && !isOfflineLocked) {
      return await offlineFetch();
    } else if (forceFetch && !isOfflineLocked) {
      try {
        return await onlineFetchWithLock(onlineFetch, lockName);
      } catch (e) {
        return await offlineFetch();
      }
    } else {
      //Offline data;
      var data;
      if (!isOfflineLocked) {
        data = await offlineFetch();
      }
      if (data == null) {
        print("Online fetch because offline is null");
        data = await onlineFetchWithLock(onlineFetch, lockName);
      }
      return data;
    }
  }

  Future<List<Discipline>> grades() async {
    List<PronotePeriod> periods = this.client.periods();
    List<Discipline> listDisciplines = [];
    await Future.forEach(periods, (PronotePeriod period) async {
      if (period != null) {
        var jsonData = {
          'donnees': {
            'Periode': {'N': period.id, 'L': period.name}
          },
        };
        var temp = await request("DernieresNotes", PronoteDisciplineConverter.disciplines, data: jsonData, onglet: 198);
        temp.forEach((element) {
          element.period = period.name;
        });
        listDisciplines.addAll(temp);
        listDisciplines = await refreshDisciplinesListColors(listDisciplines);
      }
    });
    print("Completed disciplines request");
    if (!_offlineController.locked) {
      await _offlineController.disciplines.updateDisciplines(listDisciplines);
    }
    appSys.updateSetting(appSys.settings!["system"], "lastGradeCount",
        (getAllGrades(listDisciplines, overrideLimit: true) ?? []).length);
    return listDisciplines;
  }

  Future<List<Homework>?> homeworkFor(DateTime date) async {}

  Future<List<Lesson>?> lessons(DateTime dateToUse, int week) async {}

  nextHomework() async {
    DateTime now = DateTime.now();
    List<Homework> listHW = [];
    final f = new DateFormat('dd/MM/yyyy');
    var dateTo = f.parse(this.client.funcOptions['donneesSec']['donnees']['General']['DerniereDate']['V']);
    var jsonData = {
      'donnees': {
        'domaine': {'_T': 8, 'V': "[${await get_week(now)}..${await get_week(dateTo)}]"}
      },
    };
    List<Homework> hws =
        await request("PageCahierDeTexte", PronoteHomeworkConverter.homework, data: jsonData, onglet: 88);
    hws.removeWhere((element) => element.date == null && element.date!.isBefore(now));

    listHW.addAll(hws);
    List<DateTime> pinnedDates = await _offlineController.pinnedHomework.getPinnedHomeworkDates();
    //Add pinned content
    await Future.wait(pinnedDates.map((element) async {
      jsonData = {
        'donnees': {
          'domaine': {'_T': 8, 'V': "[${await get_week(now)}..${await get_week(element)}]"}
        },
      };
      List<Homework> pinnedHomework =
          await request("PageCahierDeTexte", PronoteHomeworkConverter.homework, data: jsonData, onglet: 88);
      pinnedHomework.removeWhere((pinnedHWElement) =>
          pinnedHWElement == null && pinnedHWElement.date == null && element.day != pinnedHWElement.date!.day);
      pinnedHomework.forEach((pinned) {
        if (!listHW.any((hw) => hw.id == pinned.id)) {
          listHW.add(pinned);
        }
      });
    }));
    //delete duplicates
    listHW = listHW.toSet().toList();
    if (!_offlineController.locked) {
      await _offlineController.homework.updateHomework(listHW);
    }

    return listHW;
  }

  //Test if another concurrent task is not running
  onlineFetchWithLock(dynamic onlineFetch, lockName) async {
    int req = 0;
    //Time out of 20 seconds. Wait until the task is unlocked
    while (testLock(lockName) && req < 10) {
      req++;
      await Future.delayed(const Duration(seconds: 2), () => "1");
    }
    if (!locks[lockName]) {
      try {
        //Lock current function
        locks[lockName] = true;
        print("Fetching task with name " + lockName);
        var toReturn = await onlineFetch();
        //Unlock it
        locks[lockName] = false;
        return toReturn;
      } catch (e) {
        print(e);
        locks[lockName] = false;
        if (!testLock("recursive_" + lockName)) {
          print("Refreshing client");
          locks["recursive_" + lockName] = true;
          await refreshClient();
          this.onlineFetchWithLock(onlineFetch, lockName);
        }
      }
    } else {
      return null;
    }
  }

  refreshClient() async {
    if (appSys.loginController.actualState != loginStatus.loggedIn) {
      await appSys.loginController.login();
      //reset all recursives
      if (appSys.loginController.actualState == loginStatus.loggedIn) {
        //reset every locks
        locks.keys.forEach((element) {
          locks[element] = false;
        });
      }
    }
  }

  request(String functionName, Function converter, {var data, var customURL, int? onglet}) async {
    data = Map<dynamic, dynamic>.from(data);
    if (onglet != null) data['_Signature_'] = {'onglet': onglet};
    //If it is a parent account
    if (this.account.isParentAccount) data['_Signature_']["membre"] = {'N': this.account.studentID, 'G': 4};

    return await converter(this.client, await this.client.communication!.post(functionName, data: data));
  }

  testLock(String key) {
    if (locks.containsKey(key)) {
      return locks[key];
    } else {
      locks[key] = false;
      return false;
    }
  }
}
