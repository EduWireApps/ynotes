import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/agenda/controller.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/mails/controller.dart';
import 'package:ynotes/core/logic/school_life/controller.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/settings/model.dart';
import 'package:ynotes/core/utils/settings/settings_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/ui/themes.dart';
import 'package:ynotes_packages/theme.dart';

///Top level application sytem class
class ApplicationSystem extends ChangeNotifier {
  late FormSettings settings;

  AppAccount? account;
  SchoolAccount? _currentSchoolAccount;

  ///A boolean representing the use of the application
  bool? isFirstUse;

  ///The color theme used in the application
  ThemeData? themeData;

  String? themeName;

  ///The chosen API
  API? _api;

  late Offline offline;
  late HiveBoxProvider hiveBoxProvider;

  ///App logger
  late Logger logger;

  late LoginController loginController;
  late GradesController gradesController;

  late HomeworkController homeworkController;
  late AgendaController agendaController;
  late SchoolLifeController schoolLifeController;
  late MailsController mailsController;

  ///All the app controllers

  API? get api => _api;
  set api(API? newAPI) {
    _api = newAPI;
    refreshControllersAPI();
  }

  SchoolAccount? get currentSchoolAccount => _currentSchoolAccount;
  set currentSchoolAccount(SchoolAccount? newValue) {
    _currentSchoolAccount = newValue;
    if (account != null && account!.managableAccounts != null && newValue != null) {
      settings.system.accountIndex = account!.managableAccounts!.indexOf(newValue);
    }
    notifyListeners();
  }

  buildControllers() {
    loginController = LoginController();
    gradesController = GradesController(api);
    homeworkController = HomeworkController(api);
    agendaController = AgendaController(api);
    schoolLifeController = SchoolLifeController(api);
    mailsController = MailsController(api);
  }

  //Leave app
  exitApp() async {
    try {
      await offline.clearAll();
      //Delete sharedPref
      SharedPreferences preferences = await (SharedPreferences.getInstance());
      await preferences.clear();
      //delte local setings and init them

      _initSettings();
      //Import secureStorage
      //Delete all
      await KVS.deleteAll();
      updateTheme("clair");
    } catch (e) {
      CustomLogger.log("APPSYS", "Error occured when exiting the app");
      CustomLogger.error(e);
    }
  }

  ///The most important function
  ///It will intialize Offline, APIs and background fetch
  initApp() async {
    logger = Logger();
    //set settings
    await _initSettings();
    //Set theme to default
    updateTheme(settings.user.global.theme);
    //Set offline
    await initOffline();
    buildControllers();
    //Set api
    api = apiManager(offline);
    if (api != null) {
      account = await api!.account();
      if (account != null && account!.managableAccounts != null) {
        currentSchoolAccount = account!.managableAccounts![settings.system.accountIndex];
      }
    }
    //Set background fetch
    await _initBackgroundFetch();
    //Set controllers
  }

  saveSettings() {
    SettingsUtils.setSetting(settings);
    notifyListeners();
  }

  initOffline() async {
    hiveBoxProvider = HiveBoxProvider();
    //Initiate an unlocked offline controller
    offline = Offline();
    await offline.init();
  }

  ///On API refresh to provide a new API
  refreshControllersAPI() {
    gradesController.api = api;
    homeworkController.api = api;
    agendaController.api = api;
    schoolLifeController.api = api;
    mailsController.api = api;
  }

// This "Headless Task" is run when app is terminated.
  updateTheme(String themeName) {
    CustomLogger.log("APPSYS", "Updating theme to $themeName");
    themeData = appThemes[themeName];
    this.themeName = themeName;
    if (themeName == "clair") {
      theme.updateCurrentTheme(1);
    }
    if (themeName == "sombre") {
      theme.updateCurrentTheme(2);
    }
    settings.user.global.theme = themeName;
    SystemChrome.setSystemUIOverlayStyle(
        ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    notifyListeners();
  }

  _initBackgroundFetch() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      CustomLogger.log("APPSYS", "Configuring background fetch");
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
      CustomLogger.log("APPSYS", "Background fetch configured: $i");
    }
  }

  _initSettings() async {
    settings = await SettingsUtils.getSettings();
    //Set theme to default
    updateTheme(settings.user.global.theme);
    notifyListeners();
  }
}
