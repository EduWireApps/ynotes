import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/UI/screens/carousel.dart';
import 'package:ynotes/UI/screens/loadingPage.dart';
import 'package:ynotes/UI/screens/loginPage.dart';
import 'package:ynotes/UI/screens/tabBuilder.dart';
import 'package:sentry/sentry.dart';
import 'package:ynotes/offline.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:alice/alice.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/parsers/Pronote.dart';
import 'package:ynotes/background.dart';
import 'package:uuid/uuid.dart';
import 'package:wiredash/wiredash.dart';
import 'UI/screens/schoolAPIChoicePage.dart';
import 'multilanguage.dart';

var uuid = Uuid();

API localApi = APIManager();

///TO DO : Disable after bêta, Sentry is used to send bug reports
final SentryClient _sentry = SentryClient(uuidGenerator: uuid.v4, dsn: "");
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  try {
    await logFile(error.toString());
    final SentryResponse response = await _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  } catch (e) {}
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final logger = loader();

//Background task when when app is closed
void backgroundFetchHeadlessTask(String taskId) async {
  print("Starting the headless closed bakground task");
  var initializationSettingsAndroid = new AndroidInitializationSettings('newgradeicon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings =
      new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: BackgroundServices.onSelectNotification);
//Ensure that grades notification are enabled and battery saver disabled
  if (await getSetting("notificationNewGrade") && !await getSetting("batterySaver")) {
    if (await mainTestNewGrades()) {
      BackgroundServices.showNotificationNewGrade();
    } else {
      print("Nothing updated");
    }
    BackgroundFetch.finish(taskId);
  } else {
    print("New grade notification disabled");
  }
  if (await getSetting("notificationNewMail") && !await getSetting("batterySaver")) {
    if (await mainTestNewMails()) {
      BackgroundServices.showNotificationNewMail();
    } else {
      print("Nothing updated");
    }
    BackgroundFetch.finish(taskId);
  } else {
    print("New mail notification disabled");
  }
}

mainTestNewGrades() async {
  try {
    //Getting the offline count of grades
    List<Grade> listOfflineGrades = getAllGrades(await getGradesFromDB(), overrideLimit: true);
    print("Offline length is ${listOfflineGrades.length}");
    //Getting the online count of grades
    getChosenParser();
    List<Grade> listOnlineGrades = List<Grade>();
    if (chosenParser == 0) {
      listOnlineGrades = getAllGrades(await getGradesFromInternet(), overrideLimit: true);
    }
    if (chosenParser == 1) {
      listOnlineGrades = getAllGrades(await getPronoteGradesFromInternet(), overrideLimit: true);
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
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    _sentry.captureException(
      exception: details.exception,
      stackTrace: details.stack,
    );
  };
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
          MultiLanguage.setLanguage(path: Languages.fr, context: context);
          return AppStateNotifier();
        },
      ),
    );
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
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
    showDebugFloatingEntryPoint: false
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
