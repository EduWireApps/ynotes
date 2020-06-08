import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/UI/carousel.dart';
import 'package:ynotes/UI/gradesPage.dart';
import 'package:ynotes/UI/loadingPage.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:ynotes/UI/tabBuilder.dart';
import 'package:sentry/sentry.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:alice/alice.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/background.dart';

///TO DO : Disable after bêta, Sentry is used to send bug reports
final SentryClient _sentry = SentryClient(
    dsn: "https://c55eb82b0cab4437aeda267bb0392959@sentry.io/3147528");
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  try {
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
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('newgradeicon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String value) {
    haveToReopenOnGradePage = true;
  });
//Ensure that grades notification are enabled and battery saver disabled
  if (await getSetting("notificationNewGrade") &&
      !await getSetting("batterySaver")) {
    if (await mainTestNewGrades()) {
      BackgroundServices.showNotification();
    } else {
      print("Nothing updated");
    }
    BackgroundFetch.finish(taskId);
  } else {
    print("New grade notification disabled");
  }
}

mainTestNewGrades() async {
  try {
    //Getting the offline count of grades
    List<grade> listOfflineGrades =
        getAllGrades(await getOfflineGrades(), overrideLimit: true);
    print("Offline length is ${listOfflineGrades.length}");
    //Getting the online count of grades
    List<grade> listOnlineGrades =
        getAllGrades(await getGradesFromInternet(), overrideLimit: true);
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
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
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
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp(
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
          darkTheme: darkTheme,
          home: loader(),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
        body: LoginPage());
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
