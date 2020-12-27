import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:ynotes/UI/screens/settings/sub_pages/logsPage.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';
import 'package:ynotes/apis/Pronote.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/notifications.dart';
import 'package:ynotes/usefulMethods.dart';

//The main class for everything done in background
class BackgroundService {
  static Future<void> showNotificationNewGrade() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('2004', 'yNotes', 'Nouvelle note',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        visibility: NotificationVisibility.Public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Vous avez une toute nouvelle note !', 'Cliquez pour la consulter.', platformChannelSpecifics,
        payload: 'grade');
  }

  static Future<void> showNotificationNewMail() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('2005', 'yNotes', 'Nouveau mail',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        visibility: NotificationVisibility.Public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, 'Vous avez reçu un mail.', 'Cliquez pour le consulter.', platformChannelSpecifics, payload: 'mail');
  }

  static Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      print(payload);
    }
  }

  static refreshHomework() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    await getChosenParser();
    API api = APIManager();
    //Login creds
    String u = await ReadStorage("username");
    String p = await ReadStorage("password");
    String url = await ReadStorage("pronoteurl");
    String cas = await ReadStorage("pronotecas");
    if (connectivityResult != ConnectivityResult.none) {
      try {
        await api.login(u, p, url: url, cas: cas);
        await api.getNextHomework(forceReload: true);
      } catch (e) {
        print("Error while fetching homework in background " + e.toString());
      }
    }
  }
}

//Background task when when app is closed
void backgroundFetchHeadlessTask(String a) async {
  print("Starting the headless closed bakground task");
  await LocalNotification.showDebugNotification();
  try {
//Ensure that grades notification are enabled and battery saver disabled
    if (await getSetting("notificationNewGrade") && !await getSetting("batterySaver")) {
      logFile("New grade test triggered");
      if (await mainTestNewGrades()) {
        await LocalNotification.showNewGradeNotification();
      } else {
        print("Nothing updated");
      }
    } else {
      print("New grade notification disabled");
    }
    if (await getSetting("notificationNewMail") && !await getSetting("batterySaver")) {
      Mail mail = await mainTestNewMails();
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

void callbackDispatcher() async {
  Workmanager.executeTask((task, inputData) async {
    print("Called background fetch."); //simpleTask will be emitted here.
    await backgroundFetchHeadlessTask("");
    return Future.value(true);
  });
}
