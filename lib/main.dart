import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/hive_life_cycle_manager.dart';
import 'package:ynotes/ui/screens/carousel/index.dart';
import 'package:ynotes/ui/screens/loading/index.dart';

import 'core/utils/theme_utils.dart';
import 'ui/screens/school_api_choice/index.dart';

import 'package:sizer/sizer.dart';

Future main() async {
  Logger.level = Level.warning;
  WidgetsFlutterBinding.ensureInitialized();

  appSys = ApplicationSystem();
  await appSys.initApp();
  if (!kIsWeb) BackgroundFetch.registerHeadlessTask(_headlessTask);

  runZoned<Future<Null>>(() async {
    runApp(Phoenix(child: HomeApp()));
  });
}

_headlessTask(HeadlessTask? task) async {
  if (task != null) {
    if (task.timeout) {
      await AppNotification.cancelNotification(task.taskId.hashCode);
      BackgroundFetch.finish(task.taskId);
    }
    await BackgroundService.backgroundFetchHeadlessTask(task.taskId, headless: true);
    BackgroundFetch.finish(task.taskId);
  }
}

class Carousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SlidingCarousel(),
    ));
  }
}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(body: LoadingPage());
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SchoolAPIChoice());
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
          child: HiveLifecycleManager(
            child: Sizer(
              builder: (context, orientation, deviceType) => MaterialApp(
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
                home: Loader(),
                themeMode: ThemeMode.light,
                onGenerateRoute: onGenerateRoute,
              ),
            ),
          ),
        );
      }),
    );
  }

  initState() {
    super.initState();
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
