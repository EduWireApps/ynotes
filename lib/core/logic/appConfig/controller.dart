import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/settingsUtils.dart';
import 'package:ynotes/ui/themes/themesList.dart';

///Top level application sytem class
class ApplicationSystem extends ChangeNotifier {
  Map settings;

  ///A boolean representing the use of the application
  bool isFirstUse;

  ///The color theme used in the application
  ThemeData theme;

  String themeName;

  ///The chosen API
  API api;

  ///The chosen API
  Offline offline;

  ///All the app controllers

  LoginController loginController;
  GradesController gradesController;
  HomeworkController homeworkController;

  ///The most important function
  ///It will intialize Offline, APIs and background fetch
  initApp() {
    _initSettings();
    //Set theme to default
    updateTheme(settings["user"]["theme"]);
    //Set background fetch
    _initBackgroundFetch();
    //Set offline
    _initOffline();
    //Set api
    this.api = APIManager(this.offline);
    //Set controllers
    _initControllers();
  }

  updateTheme(String themeName) {
    theme = appThemes[themeName];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: theme.backgroundColor, statusBarColor: Colors.transparent // navigation bar color
        // status bar color
        ));
    notifyListeners();
  }

  _initSettings() {
    this.settings = SettingsUtil.getSettings();
  }

  _initBackgroundFetch() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await BackgroundFetch.configure(
          BackgroundFetchConfig(
              minimumFetchInterval: 15,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.ANY), (taskId) async {
        await BackgroundService.backgroundFetchHeadlessTask(taskId);
        BackgroundFetch.finish(taskId);
      });
    }
  }

  _initOffline() {
    //Initiate an unlocked offline controller
    offline = Offline(false);
  }

  _initControllers() {
    loginController = LoginController();
    gradesController = GradesController(this.api);
    homeworkController = HomeworkController(this.api);
  }
}
