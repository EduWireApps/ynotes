import 'package:connectivity/connectivity.dart';
import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/apis/Pronote/converters/disciplines.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';

import 'package:ynotes/globals.dart';
import 'package:ynotes/usefulMethods.dart';

class PronoteMethod {
  Map locks = Map();
  final PronoteClient client;
  final SchoolAccount account;

  PronoteMethod(this.client, this.account);

  Future<List<SchoolAccount>> accounts() {}

  Future<List<Lesson>> lessons(DateTime dateToUse, int week) {
    
  }

  
  Future<List<Discipline>> grades() async {
    List<PronotePeriod> periods = await client.periods();
    List<Discipline> listDisciplines = List<Discipline>();
    await Future.forEach(periods, (period) async {
      var jsonData = {
        'donnees': {
          'Periode': {'N': period.id, 'L': period.name}
        },
      };
      listDisciplines.addAll(
        await request("DernieresNotes", PronoteDisciplineConverter.disciplines, data: jsonData, onglet: 198),
      );
      listDisciplines.forEach((element) {
        element.period = period.name;
      });
      listDisciplines = await refreshDisciplinesListColors(listDisciplines);
    });

    appSys.offline.disciplines.updateDisciplines(listDisciplines);
    appSys.updateSetting(
        appSys.settings["system"], "lastGradeCount", getAllGrades(listDisciplines, overrideLimit: true).length);
  }

  nextHomework() async {}

  Future<List<Homework>> homeworkFor(DateTime date) async {}

  Future<List<CloudItem>> cloudFolders() async {}

  request(String functionName, Function converter, {var data, var customURL, int onglet}) async {
    if (onglet != null) data['_Signature_'] = {'onglet': onglet};

    //If it is a parent account
    if (this.account.isParentAccount) data['_Signature_']["membre"] = {'N': this.account.studentID, 'G': 4};

    return await converter(this.client, await this.client.communication.post(functionName, data: data));
  }

  //Test if another concurrent task is not running
  testLock(String key) {
    if (locks.containsKey(key)) {
      return locks[key];
    } else {
      locks[key] = false;
      return false;
    }
  }

  onlineFetchWithLock(dynamic onlineFetch, lockName) async {
    int req = 0;
    //Time out of 20 seconds. Wait until the task is unlocked
    while (locks[lockName] && req < 10) {
      req++;
      await Future.delayed(const Duration(seconds: 2), () => "1");
    }
    if (!locks[lockName]) {
      try {
        //Lock current function
        locks[lockName] = true;
        var toReturn = await onlineFetch();
        //Unlock it
        locks[lockName] = false;
      } catch (e) {
        locks[lockName] = false;
        if (!testLock("recursive_" + lockName)) {
          locks["recursive_" + lockName] = true;
          await refreshClient();
        }
      }
    }
  }

  refreshClient() async {
    await appSys.loginController.login();
    //reset all recursives
    if (appSys.loginController.actualState == loginStatus.loggedIn) {
      //reset every locks
      locks.keys.forEach((element) {
        locks[element] = false;
      });
    }
  }

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
        data = await onlineFetchWithLock(onlineFetch, lockName);
      }
      return data;
    }
  }
}
