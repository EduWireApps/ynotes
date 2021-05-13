import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/logic/appConfig/controller.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/carousel/carousel.dart';
import 'package:ynotes/ui/screens/drawer/drawerBuilder.dart';
import 'package:ynotes/ui/screens/loading/loadingPage.dart';

import 'core/utils/themeUtils.dart';
import 'ui/screens/school_api_choice/schoolAPIChoicePage.dart';

Future main() async {
  Logger.level = Level.warning;
  WidgetsFlutterBinding.ensureInitialized();
  appSys = ApplicationSystem();
  await appSys.initApp();
  BackgroundFetch.registerHeadlessTask(_headlessTask);

  //appSys.loginController = LoginController();

  runZoned<Future<Null>>(() async {
    runApp(HomeApp());
  });
}

var setting;

var uuid = Uuid();

///The app main class
///
///
_headlessTask(HeadlessTask? task) async {
  if (task != null) {
    await BackgroundService.backgroundFetchHeadlessTask(task.taskId, headless: true);
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

/*//login manager
LoginController appSys.loginController;
Offline offline;
API appSys.api;*/

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
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

class _HomeAppState extends State<HomeApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ApplicationSystem>.value(
      value: appSys,
      child: Consumer<ApplicationSystem>(builder: (context, model, child) {
        return Wiredash(
          projectId: "ynotes-giw0qs2",
          secret: "y9zengsvskpriizwniqxr6vxa1ka1n6u",
          navigatorKey: _navigatorKey,
          theme: WiredashThemeData(
              backgroundColor: ThemeUtils.isThemeDark ? Color(0xff313131) : Colors.white,
              primaryBackgroundColor: ThemeUtils.isThemeDark ? Color(0xff414141) : Color(0xffF3F3F3),
              secondaryBackgroundColor: ThemeUtils.isThemeDark ? Color(0xff313131) : Colors.white,
              secondaryColor: Theme.of(context).primaryColorDark,
              primaryColor: Theme.of(context).primaryColor,
              primaryTextColor: ThemeUtils.textColor(),
              brightness: Brightness.dark,
              secondaryTextColor: ThemeUtils.textColor().withOpacity(0.8)),
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
            theme: model.theme,
            title: kDebugMode ? "yNotes DEV" : "yNotes",
            navigatorKey: _navigatorKey,
            home: loader(),
            themeMode: ThemeMode.light,
          ),
        );
      }),
    );
  }

  initState() {
    super.initState();
  }
}

extension on TextStyle {
  /// Temporary fix the following Flutter Web issues
  /// https://github.com/flutter/flutter/issues/63467
  /// https://github.com/flutter/flutter/issues/64904#issuecomment-699039851
  /// https://github.com/flutter/flutter/issues/65526
  TextStyle get withZoomFix => copyWith(wordSpacing: 0);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
