import 'dart:async';
import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/logic/appConfig/controller.dart';
import 'package:ynotes/core/services/shared_preferences.dart';
import 'package:ynotes/ui/screens/carousel/carousel.dart';
import 'package:ynotes/ui/screens/drawer/drawerBuilder.dart';
import 'package:ynotes/ui/screens/loading/loadingPage.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/globals.dart' as globals;
import 'ui/screens/school_api_choice/schoolAPIChoicePage.dart';
import 'core/utils/themeUtils.dart';

var uuid = Uuid();

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension on TextStyle {
  /// Temporary fix the following Flutter Web issues
  /// https://github.com/flutter/flutter/issues/63467
  /// https://github.com/flutter/flutter/issues/64904#issuecomment-699039851
  /// https://github.com/flutter/flutter/issues/65526
  TextStyle get withZoomFix => copyWith(wordSpacing: 0);
}

/*//login manager
LoginController appSys.loginController;
Offline offline;
API appSys.api;*/

///The app main class
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globals.appSys.initApp();
  /*offline = Offline(false);
  await appSys.offline.init();
  if (Platform.isAndroid || Platform.isIOS) {
    await initBackgroundTask();
  }

  //Load api
  await reloadChosenApi();

  appSys.api = APIManager(offline);
  appSys.loginController = LoginController();
  //Set system notification bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkModeEnabled ? Color(0xff414141) : Color(0xffF3F3F3),
      statusBarColor: Colors.transparent));
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  //Load connection status
  connectionStatus.initialize();*/
  runZoned<Future<Null>>(() async {
    runApp(HomeApp());
  });
}

class HomeApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ApplicationSystem>.value(
      value: globals.appSys,
      child: Consumer<ApplicationSystem>(builder: (context, model, child) {
        return Wiredash(
          projectId: "ynotes-giw0qs2",
          secret: "y9zengsvskpriizwniqxr6vxa1ka1n6u",
          navigatorKey: _navigatorKey,
          theme: WiredashThemeData(
              backgroundColor: isDarkModeEnabled ? Color(0xff313131) : Colors.white,
              primaryBackgroundColor: isDarkModeEnabled ? Color(0xff414141) : Color(0xffF3F3F3),
              secondaryBackgroundColor: isDarkModeEnabled ? Color(0xff313131) : Colors.white,
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
            theme: globals.appSys.theme,
            title: kDebugMode ? "yNotes DEV" : "yNotes",
            navigatorKey: _navigatorKey,
            home: loader(),
            themeMode: ThemeMode.light,
          ),
        );
      }),
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
