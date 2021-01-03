import 'dart:async';
import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wiredash/wiredash.dart';
import 'package:workmanager/workmanager.dart';
import 'package:ynotes/UI/screens/carousel/carousel.dart';
import 'package:ynotes/UI/screens/drawer/drawerBuilder.dart';
import 'package:ynotes/UI/screens/loading/loadingPage.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/models.dart';
import 'package:ynotes/offline/offline.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';
import 'package:ynotes/apis/EcoleDirecte/ecoleDirecteMethods.dart';
import 'package:ynotes/apis/Pronote.dart';
import 'package:ynotes/usefulMethods.dart';

import 'UI/screens/settings/sub_pages/logsPage.dart';
import 'UI/screens/school_api_choice/schoolAPIChoicePage.dart';
import 'utils/themeUtils.dart';
import 'notifications.dart';

var uuid = Uuid();

//login manager
TransparentLogin tlogin = TransparentLogin();
Offline offline = Offline();
API localApi = APIManager(offline);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

mainTestNewGrades() async {
  try {
    //Get the old number of mails
    var oldGradesLength = await getIntSetting("gradesNumber");
    //Getting the offline count of grades
    //instanciate an offline controller read only
    Offline _offline = Offline(locked: true);
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

    print("Online length is ${listOnlineGrades.length}");
    if (oldGradesLength != null && oldGradesLength != 0 && oldGradesLength < listOnlineGrades.length) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    await logFile("An error occured during the new grades test : " + e.toString());
    return false;
  }
}

mainTestNewMails() async {
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

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
//Register work manager
  await Workmanager.initialize(callbackDispatcher);
  await Workmanager.registerPeriodicTask("background", "backgroundFetcher");
  //Init the local notifications
  var initializationSettingsAndroid = new AndroidInitializationSettings(
    'newgradeicon',
  );
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: BackgroundService.onSelectNotification);

  //Init offline data
  await offline.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkModeEnabled ? Color(0xff414141) : Color(0xffF3F3F3),
      statusBarColor: Colors.transparent));
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
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
