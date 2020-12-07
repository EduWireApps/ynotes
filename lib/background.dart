import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ynotes/apis/Pronote.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/notifications.dart';
import 'package:ynotes/usefulMethods.dart';

//The main class for everything done in background
class BackgroundService {
  static Future<void> showNotificationNewGrade() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('2004', 'yNotes', 'Nouvelle note', importance: Importance.Max, priority: Priority.High, ticker: 'ticker', visibility: NotificationVisibility.Public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Vous avez une toute nouvelle note !', 'Cliquez pour la consulter.', platformChannelSpecifics, payload: 'grade');
  }

  static Future<void> showNotificationNewMail() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('2005', 'yNotes', 'Nouveau mail', importance: Importance.Max, priority: Priority.High, ticker: 'ticker', visibility: NotificationVisibility.Public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Vous avez reçu un mail.', 'Cliquez pour le consulter.', platformChannelSpecifics, payload: 'mail');
  }

  static Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      print(payload);
    }
  }

/*
  //Currently Pronote only feature
  static Future<void> refreshOnGoingNotif() async {
    API api = APIPronote();
    //Login creds
    String u = await ReadStorage("username");
    String p = await ReadStorage("password");
    String url = await ReadStorage("pronoteurl");
    String cas = await ReadStorage("pronotecas");
    await api.login(u, p, url: url, cas: cas);
    var date = DateTime.now();
    List<Lesson> lessons = await api.getNextLessons(date);
    await Future.forEach(lessons, (lesson) async {
      await LocalNotification.scheduleReminders(lesson, onGoing: true);
    });
  }
*/
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
