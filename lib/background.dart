import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:ynotes/UI/screens/school_api_choice/schoolAPIChoicePage.dart';
import 'package:ynotes/UI/screens/settings/sub_pages/logsPage.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';
import 'package:ynotes/apis/EcoleDirecte/ecoleDirecteMethods.dart';
import 'package:ynotes/apis/Pronote.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/notifications.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/shared_preferences.dart';
import 'package:ynotes/usefulMethods.dart';

//The main class for everything done in background
class BackgroundService {
//Background task when when app is closed
  static Future<void> backgroundFetchHeadlessTask(String a) async {
    print("Starting the headless closed bakground task");
    //await LocalNotification.showDebugNotification();
    try {
//Ensure that grades notification are enabled and battery saver disabled
      if (await getSetting("notificationNewGrade") && !await getSetting("batterySaver")) {
        logFile("New grade test triggered");
        if (await testNewGrades()) {
          await LocalNotification.showNewGradeNotification();
        } else {
          print("Nothing updated");
        }
      } else {
        print("New grade notification disabled");
      }
      if (await getSetting("notificationNewMail") && !await getSetting("batterySaver")) {
        logFile("New mail test triggered");

        Mail mail = await testNewMails();
        if (mail != null) {
          String content = await readMail(mail.id, mail.read);
          await LocalNotification.showNewMailNotification(mail, content);
        } else {
          print("Nothing updated");
        }
      } else {
        print("New mail notification disabled");
      }
      if (await getSetting("agendaOnGoingNotification")) {
        print("Setting On going notification");
        await LocalNotification.setOnGoingNotification(dontShowActual: true);
      } else {
        print("On going notification disabled");
      }
      await logFile("Background fetch occured.");
    } catch (e) {
      await logFile("An error occured during the background fetch : " + e.toString());
    }
    //BackgroundFetch.finish("");
  }

  static testNewGrades() async {
    try {
      //Get the old number of mails
      var oldGradesLength = await getIntSetting("gradesNumber");
      //Getting the offline count of grades
      //instanciate an offline controller read only
      Offline _offline = Offline(true);
      await _offline.init();
      await getChosenParser();
      API backgroundFetchApi = APIManager(_offline);

      print("Old grades length is ${oldGradesLength}");
      //Getting the online count of grades

      List<Grade> listOnlineGrades = List<Grade>();
      //Login creds
      String u = await ReadStorage("username");
      String p = await ReadStorage("password");
      String url = await ReadStorage("pronoteurl");
      String cas = await ReadStorage("pronotecas");
      await backgroundFetchApi.login(u, p, url: url, cas: cas);
      listOnlineGrades = getAllGrades(await backgroundFetchApi.getGrades(forceReload: true), overrideLimit: true);

      print("Online grade length is ${listOnlineGrades.length}");
      if (oldGradesLength != null && oldGradesLength != 0 && oldGradesLength < listOnlineGrades.length) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("gradesNumber", listOnlineGrades.length);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      await logFile("An error occured during the new grades test : " + e.toString());
      return false;
    }
  }

  static testNewMails() async {
    try {
      //Get the old number of mails
      var oldMailLength = await getIntSetting("mailNumber");
      print("Old length is $oldMailLength");
      //Get new mails
      List<Mail> mails = await getMails();
      mails.retainWhere((element) => element.mtype == "received");

      mails.sort((a, b) {
        DateTime datea = DateTime.parse(a.date);
        DateTime dateb = DateTime.parse(b.date);
        return datea.compareTo(dateb);
      });
      var newMailLength = await getIntSetting("mailNumber");

      await logFile("Mails checking triggered");
      print("New length is ${newMailLength}");
      if (oldMailLength != 0) {
        if (oldMailLength < (newMailLength != null ? newMailLength : 0)) {
          return mails.last;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Erreur dans la verification de nouveaux mails hors ligne " + e.toString());
      return null;
    }
  }

  static Future<void> callbackDispatcher() async {
    Workmanager.executeTask((task, inputData) async {
      print("Called background fetch."); //simpleTask will be emitted here.
      await backgroundFetchHeadlessTask("");
      return Future.value(true);
    });
  }
}
