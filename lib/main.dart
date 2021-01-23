import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wiredash/wiredash.dart';
import 'package:workmanager/workmanager.dart' as wm;
import 'package:ynotes/UI/screens/carousel/carousel.dart';
import 'package:ynotes/UI/screens/drawer/drawerBuilder.dart';
import 'package:ynotes/UI/screens/loading/loadingPage.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/models.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/usefulMethods.dart';

import 'UI/screens/school_api_choice/schoolAPIChoicePage.dart';
import 'utils/themeUtils.dart';

var uuid = Uuid();

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

//login manager
TransparentLogin tlogin;
Offline offline;
API localApi;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

///The app main class
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initBackgroundTask();

  //Load api
  await reloadChosenApi();
  offline = Offline(false);
  localApi = APIManager(offline);
  tlogin = TransparentLogin();

  //Init offline data
  await offline.init();

  //Cancel the old task manager (will be removed after migration)
  wm.Workmanager.cancelAll();

  //Set system notification bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkModeEnabled ? Color(0xff414141) : Color(0xffF3F3F3),
      statusBarColor: Colors.transparent));
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  //Load connection status
  connectionStatus.initialize();
  runZoned<Future<Null>>(() async {
    runApp(
      ChangeNotifierProvider<AppStateNotifier>(
        child: HomeApp(),
        create: (BuildContext context) {
          return AppStateNotifier();
        },
      ),
    );
  });
}

//Init background fetch
Future<void> initBackgroundTask() async {
  // Configure BackgroundFetch.
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

class HomeApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<AppStateNotifier>(context);
    return Wiredash(
      projectId: "ynotes-giw0qs2",
      secret: "y9zengsvskpriizwniqxr6vxa1ka1n6u",
      navigatorKey: _navigatorKey,
      options: WiredashOptionsData(
        /// You can set your own locale to override device default (`window.locale` by default)
        locale: const Locale.fromSubtags(languageCode: 'fr'),
      ),
      child: MaterialApp(
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'), // English (could be useless ?)
          const Locale('fr'), //French
          // ... other locales the app supports
        ],
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        navigatorKey: _navigatorKey,
        darkTheme: darkTheme,
        home: loader(),
        themeMode: themeNotifier.getTheme(),
      ),
    );
  }
}

class loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(

//Main container
        body: LoadingPage());
  }
}

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(

//Main container
        body: SchoolAPIChoice());
  }
}

class carousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SlidingCarousel(),
    ));
  }
}

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: DrawerBuilder(),
        ));
  }
}
