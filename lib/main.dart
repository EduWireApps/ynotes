import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/UI/carousel.dart';
import 'package:ynotes/UI/loadingPage.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:ynotes/UI/tabBuilder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ynotes/landGrades.dart';
import 'package:sentry/sentry.dart';
import 'package:logging/logging.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:alice/alice.dart';
//Alice is used to debug
Alice alice = Alice(showNotification: true);

///TO DO : Disable after bêta, Sentry is used to send bug reports
final SentryClient _sentry = SentryClient(
    dsn: "https://c55eb82b0cab4437aeda267bb0392959@sentry.io/3147528");
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );
}

final logger = loader();

Future<Null> main() async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    _sentry.captureException(
      exception: details.exception,
      stackTrace: details.stack,
    );
  };

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
        return MaterialApp(navigatorKey: alice.getNavigatorKey(),
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
