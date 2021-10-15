import 'dart:async';

import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/useful_methods.dart';

//The main class for everything done in background
class BackgroundService {
//Background task when when app is closed
  static Future<void> backgroundFetchHeadlessTask(String a, {bool headless = false}) async {
    //await LocalNotification.showDebugNotification();
    try {
      //Ensure that grades notification are enabled and battery saver disabled
      bool gradesFetchEnabled =
          ((appSys.settings.user.global.notificationNewGrade && !appSys.settings.user.global.batterySaver));

      //Ensure that mails notification are enabled, battery saver disabled and parser is EcoleDirecte
      bool mailsFetchEnabled = (appSys.settings.user.global.notificationNewMail &&
          !appSys.settings.user.global.batterySaver &&
          appSys.settings.system.chosenParser == 0);

      CustomLogger.log("BACKGROUND", "Starting the headless closed bakground task");

      //If some fetch is allowed
      if (gradesFetchEnabled || mailsFetchEnabled) {
        await AppNotification.showLoadingNotification(a.hashCode);
        if (headless) {
          CustomLogger.log("BACKGROUND", "headless");
          appSys = ApplicationSystem();
          CustomLogger.saveLog(object: "BACKGROUND", text: "Headless task triggered.");
          await appSys.initApp();
        } else {
          //We have to refresh offline
          await appSys.initOffline();
          appSys.refreshControllersAPI();
        }
        CustomLogger.saveLog(object: "BACKGROUND", text: "Initiated appSys.");
        await writeLastFetchStatus(appSys);
      }
      if (gradesFetchEnabled) {
        CustomLogger.saveLog(object: "BACKGROUND", text: "New grade test triggered.");
        var res = (await testNewGrades());
        if (res[0]) {
          await Future.forEach(res[1], (Grade grade) async {
            await AppNotification.showNewGradeNotification(grade);
          });
        } else {
          CustomLogger.saveLog(object: "BACKGROUND", text: "Grades: nothing updated.");
        }
      } else {
        CustomLogger.log("BACKGROUND", "New grade notification disabled");
      }
      if (mailsFetchEnabled) {
        CustomLogger.saveLog(object: "BACKGROUND", text: "New mail test triggered.");

        Mail? mail = await testNewMails();
        if (mail != null) {
          String content =
              (await (appSys.api as APIEcoleDirecte).readMail(mail.id ?? "", mail.read ?? false, true)) ?? "";
          await AppNotification.showNewMailNotification(mail, content);
        } else {
          CustomLogger.log("BACKGROUND", "Nothing updated");
        }
      } else {
        CustomLogger.log("BACKGROUND", "New mail notification disabled");
      }
      if (appSys.settings.user.agendaPage.agendaOnGoingNotification) {
        CustomLogger.log("BACKGROUND", "Setting On going notification");
        await AppNotification.setOnGoingNotification(dontShowActual: true);
      } else {
        CustomLogger.log("BACKGROUND", "On going notification disabled");
      }
      CustomLogger.saveLog(object: "BACKGROUND", text: "Background fetch occured.");
      await AppNotification.cancelNotification(a.hashCode);
    } catch (e) {
      await AppNotification.cancelNotification(a.hashCode);
      CustomLogger.saveLog(object: "ERROR", text: "An error occured during the background fetch : " + e.toString());
    }
  }

  ///Allows fetch only if time delay since last fetch is greater or equal to 5 minutes
  static bool readLastFetchStatus(ApplicationSystem _appSys) {
    try {
      if (_appSys.settings.system.lastFetchDate != null) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(_appSys.settings.system.lastFetchDate!);

        if (DateTime.now().difference(date).inMinutes >= 5) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      CustomLogger.log("BACKGROUND", "An error occured while readinf fetch status");
      CustomLogger.error(e);
      return false;
    }
  }

  ///Returns true if there are new grades
  static testNewGrades() async {
    try {
      //Get the old number of mails
      int oldGradesLength = appSys.settings.system.lastGradeCount;
      //Getting the offline count of grades
      //instanciate an offline controller read only

      CustomLogger.log("BACKGROUND", "Old grades length is $oldGradesLength");
      //Getting the online count of grades

      List<Grade>? listOnlineGrades = [];
      //Login creds
      listOnlineGrades =
          getAllGrades(await appSys.api?.getGrades(forceReload: true), overrideLimit: true, sortByWritingDate: true);

      CustomLogger.log("BACKGROUND", "Online grade length is ${listOnlineGrades!.length}");
      if (oldGradesLength != 0 && oldGradesLength < listOnlineGrades.length) {
        int diff = (listOnlineGrades.length - (listOnlineGrades.length - oldGradesLength).clamp(0, 5));
        List<Grade> newGrades = listOnlineGrades.sublist(diff);
        return [true, newGrades];
      } else {
        return [false];
      }
    } catch (e) {
      CustomLogger.saveLog(object: "ERROR", text: "An error occured during the new grades test : " + e.toString());
      return [false];
    }
  }

  ///Returns true if there are new mails
  static testNewMails() async {
    try {
      //Get the old number of mails

      var oldMailLength = appSys.settings.system.lastMailCount;

      CustomLogger.log("BACKGROUND", "Old length is $oldMailLength");
      //Get new mails
      List<Mail>? mails = await (appSys.api as APIEcoleDirecte?)?.getMails(forceReload: true);
      //filter mails by type
      (mails ?? []).retainWhere((element) => element.mtype == "received");
      (mails ?? []).sort((a, b) {
        DateTime datea = DateTime.parse(a.date!);
        DateTime dateb = DateTime.parse(b.date!);
        return datea.compareTo(dateb);
      });
      var newMailLength = mails?.length ?? 0;

      CustomLogger.saveLog(object: "BACKGROUND", text: "Mails checking triggered.");
      CustomLogger.log("BACKGROUND", "New length is $newMailLength");
      if (oldMailLength != 0) {
        if (oldMailLength < (newMailLength)) {
          //Manually set the new mail number
          appSys.settings.system.lastMailCount = newMailLength;
          appSys.saveSettings();

          return (mails ?? []).last;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      CustomLogger.log("BACKGROUND", "An error occured while checking new offline mails");
      CustomLogger.error(e);
      return null;
    }
  }

  //write last fetch in milliseconds since epoch
  static writeLastFetchStatus(ApplicationSystem _appSys) async {
    int date = DateTime.now().millisecondsSinceEpoch;
    appSys.settings.system.lastFetchDate = date;
    appSys.saveSettings();
    CustomLogger.log("BACKGROUND", "Written last fetch status " + date.toString());
  }
}
