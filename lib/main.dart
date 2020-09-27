import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:ynotes/UI/screens/carousel.dart';
import 'package:ynotes/UI/screens/loadingPage.dart';
import 'package:ynotes/UI/screens/tabBuilder.dart';
import 'package:sentry/sentry.dart';
import 'package:ynotes/models.dart';
import 'package:ynotes/offline.dart';
import 'package:ynotes/parsers/EcoleDirecte/ecoleDirecteMethods.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/parsers/Pronote.dart';
import 'package:ynotes/background.dart';
import 'package:uuid/uuid.dart';
import 'package:wiredash/wiredash.dart';
import 'UI/screens/logsPage.dart';
import 'UI/screens/schoolAPIChoicePage.dart';
import 'UI/utils/themeUtils.dart';

var uuid = Uuid();

//login manager
TransparentLogin tlogin = TransparentLogin();

API localApi = APIManager();
Offline offline = Offline();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final logger = loader();

//Background task when when app is closed
void backgroundFetchHeadlessTask(String taskId) async {
  print("Starting the headless closed bakground task");
  var initializationSettingsAndroid = new AndroidInitializationSettings('newgradeicon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: BackgroundService.onSelectNotification);
//Ensure that grades notification are enabled and battery saver disabled
  if (await getSetting("notificationNewGrade") && !await getSetting("batterySaver")) {
    if (await mainTestNewGrades()) {
      BackgroundService.showNotificationNewGrade();
    } else {
      print("Nothing updated");
    }
  } else {
    print("New grade notification disabled");
  }
  if (await getSetting("notificationNewMail") && !await getSetting("batterySaver")) {
    if (await mainTestNewMails()) {
      BackgroundService.showNotificationNewMail();
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
  BackgroundFetch.finish(taskId);
}

mainTestNewGrades() async {
  try {
    //Getting the offline count of grades
    List<Grade> listOfflineGrades = getAllGrades(await offline.disciplines(), overrideLimit: true);
    print("Offline length is ${listOfflineGrades.length}");
    //Getting the online count of grades
    await getChosenParser();
    List<Grade> listOnlineGrades = List<Grade>();
    if (chosenParser == 0) {
      listOnlineGrades = getAllGrades(await EcoleDirecteMethod.grades(), overrideLimit: true);
    }
    if (chosenParser == 1) {
      print("Getting grades from Pronote");
      API api = APIPronote();
      //Login creds
      String u = await ReadStorage("username");
      String p = await ReadStorage("password");
      String url = await ReadStorage("pronoteurl");
      String cas = await ReadStorage("pronotecas");
      await api.login(u, p, url: url, cas: cas);
      listOnlineGrades = getAllGrades(await api.getGrades(), overrideLimit: true);
    }

    print("Online length is ${listOnlineGrades.length}");
    if (listOfflineGrades.length < listOnlineGrades.length) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

mainTestNewMails() async {
  try {
    //Get the old number of mails
    var oldMailLength = await getIntSetting("mailNumber");
    print("Old length is $oldMailLength");
    //Get new mails
    await getMails();
    var newMailLength = await getIntSetting("mailNumber");
    print("New length is ${newMailLength}");
    if (oldMailLength != 0) {
      if (oldMailLength < (newMailLength != null ? newMailLength : 0)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    print("Erreur dans la verification de nouveaux mails hors ligne " + e.toString());
    return null;
  }
}

Future main() async {
//Init the local notifications
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  var initializationSettingsAndroid = new AndroidInitializationSettings(
    'newgradeicon',
  );
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: BackgroundService.onSelectNotification);
  //Init offline data
  await offline.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: isDarkModeEnabled ? Color(0xff414141) : Color(0xffF3F3F3), statusBarColor: Colors.transparent));
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

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
}

class HomeApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return Wiredash(
          projectId: "ynotes-giw0qs2",
          secret: "y9zengsvskpriizwniqxr6vxa1ka1n6u",
          navigatorKey: _navigatorKey,
          options: WiredashOptionsData(

              /// You can set your own locale to override device default (`window.locale` by default)
              locale: const Locale.fromSubtags(languageCode: 'fr'),
              showDebugFloatingEntryPoint: false),
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
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          ),
        );
      },
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
          child: TabBuilder(),
        ));
  }
}
