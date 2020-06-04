import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/UI/tabBuilder.dart';

//The main class for everything done in background
class BackgroundServices {
  static Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '2004', 'yNotes', 'Nouvelle note',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        visibility: NotificationVisibility.Public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Vous avez une toute nouvelle note !',
        'Cliquez pour la consulter.',
        platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      
    }
  }
}
