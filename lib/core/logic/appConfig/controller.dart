import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/agenda/controller.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/mails/controller.dart';
import 'package:ynotes/core/logic/schoolLife/controller.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/offline/isar/data/homework.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/core/utils/settingsUtils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/isar.g.dart';
import 'package:ynotes/ui/themes/themesList.dart';

///Top level application sytem class
class ApplicationSystem extends ChangeNotifier {
  Map? settings;

  AppAccount? account;
  SchoolAccount? _currentSchoolAccount;

  ///A boolean representing the use of the application
  bool? isFirstUse;

  ///The color theme used in the application
  ThemeData? theme;

  String? themeName;

  ///The chosen API
  API? api;

  ///The chosen API
  late Offline offline;
  late final Isar isar;

  ///App logger
  late Logger logger;

  late LoginController loginController;
  late GradesController gradesController;

  late HomeworkController homeworkController;
  late AgendaController agendaController;
  late SchoolLifeController schoolLifeController;
  late MailsController mailsController;

  ///All the app controllers

  SchoolAccount? get currentSchoolAccount => _currentSchoolAccount;
  set currentSchoolAccount(SchoolAccount? newValue) {
    _currentSchoolAccount = newValue;
    if (account != null && account!.managableAccounts != null && newValue != null) {
      this.updateSetting(this.settings!["system"], "accountIndex", this.account!.managableAccounts!.indexOf(newValue));
    }
    notifyListeners();
  }

  exitApp() async {
    try {
      await this.offline.clearAll();
      //Delete sharedPref
      SharedPreferences preferences = await (SharedPreferences.getInstance());
      await preferences.clear();
      //delte local setings and init them
      this.settings!.clear();
      this._initSettings();
      //Import secureStorage
      final storage = new FlutterSecureStorage();
      //Delete all
      await storage.deleteAll();
      this.updateTheme("clair");
      await this.isar.writeTxn((isar) async {
        await isar.homeworks.where().deleteAll();
        await isar.mails.where().deleteAll();
      });
    } catch (e) {
      print(e);
    }
  }

  ///The most important function
  ///It will intialize Offline, APIs and background fetch
  initApp() async {
    await initIsar();

    logger = Logger();
    //set settings
    await _initSettings();
    //Set theme to default
    updateTheme(settings!["user"]["global"]["theme"]);
    //Set offline
    await _initOffline();
    //Set api
    this.api = apiManager(this.offline);

    if (api != null) {
      account = await api!.account();
      if (account != null && account!.managableAccounts != null)
        currentSchoolAccount = account!.managableAccounts![settings!["system"]["accountIndex"] ?? 0];
    }
    //Set background fetch
    await _initBackgroundFetch();
    //Set controllers
    loginController = LoginController();
    gradesController = GradesController(this.api);
    homeworkController = HomeworkController(this.api);
    agendaController = AgendaController(this.api);
    schoolLifeController = SchoolLifeController(this.api);
    mailsController= MailsController(this.api);
  }

  initControllers() async {
    await this.gradesController.refresh(force: true);
    await this.homeworkController.refresh(force: true);
  }

  initIsar() async {
    var dir = await FolderAppUtil.getDirectory();
    isar = await openIsar(directory: "${dir.path}/offline");
    await OfflineHomework(isar).migrateOldDoneHomeworkStatus(this);
  }

//Leave app
  updateSetting(Map path, String key, var value) {
    path[key] = value;
    SettingsUtils.setSetting(settings);
    notifyListeners();
  }

  updateTheme(String themeName) {
    print("Updating theme to " + themeName);
    theme = appThemes[themeName];
    this.themeName = themeName;
    updateSetting(this.settings!["user"]["global"], "theme", themeName);
    SystemChrome.setSystemUIOverlayStyle(
        ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    notifyListeners();
  }

// This "Headless Task" is run when app is terminated.
  _initBackgroundFetch() async {
    if (Platform.isAndroid || Platform.isIOS) {
      print("Background fetch configuration...");
      int i = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY),
        (String taskId) async {
          await BackgroundService.backgroundFetchHeadlessTask(taskId);
          BackgroundFetch.finish(taskId);
        },
        (String taskId) async {
          await AppNotification.cancelNotification(taskId.hashCode);
          BackgroundFetch.finish(taskId);
        },
      );
      print(i);
      print("Configured background fetch");
    }
  }

  _initOffline() async {
    //Initiate an unlocked offline controller
    offline = Offline(false);
    await offline.init();
  }

  _initSettings() async {
    settings = await SettingsUtils.getSettings();
    //Set theme to default
    updateTheme(settings!["user"]["global"]["theme"]);
    notifyListeners();
  }
}

class Test {
  Map? settings;
  Test() {
    settings = SettingsUtils.getAppSettings();
  }
}
