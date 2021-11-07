import 'dart:async';
import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/backward_compatibility.dart';
import 'package:ynotes/config.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/bugreport_utils.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/hive_life_cycle_manager.dart';
import 'package:ynotes/ui/themes/themes.dart';
import 'package:ynotes/ui/themes/utils/fonts.dart';
import 'package:ynotes_packages/config.dart';
import 'package:ynotes_packages/theme.dart';

Future main() async {
  Logger.level = Level.warning;
  WidgetsFlutterBinding.ensureInitialized();
  await backwardCompatibility();
  theme = YCurrentTheme(currentTheme: 1, themes: themes); // TODO: rework how theme integrates in the app

  appSys = ApplicationSystem();
  await appSys.initApp();

  BugReportUtils.init();

  if (!kIsWeb && !Platform.isLinux && !Platform.isWindows) BackgroundFetch.registerHeadlessTask(_headlessTask);

  runZoned<Future<void>>(() async {
    runApp(Phoenix(child: const App()));
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

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    AppConfig.navigatorKey = GlobalKey<NavigatorState>();

    return FocusDetector(
      onForegroundGained: () {
        UIUtils.setSystemUIOverlayStyle();
      },
      child: Responsive(builder: (context) {
        return YApp(
            initialTheme: appSys.themeName == "clair" ? 1 : 2,
            themes: themes,
            builder: (context) => ChangeNotifierProvider<ApplicationSystem>.value(
                  value: appSys,
                  child: Consumer<ApplicationSystem>(builder: (context, model, child) {
                    return HiveLifecycleManager(
                        child: MaterialApp(
                      localizationsDelegates: const [
                        // ... app-specific localization delegate[s] here
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: const [
                        Locale('fr'), //French
                      ],
                      debugShowCheckedModeBanner: false,
                      theme: model.themeData?.copyWith(
                          colorScheme: theme.themeData.colorScheme,
                          splashColor: theme.themeData.splashColor,
                          highlightColor: theme.themeData.highlightColor,
                          splashFactory: theme.themeData.splashFactory,
                          textSelectionTheme: theme.themeData.textSelectionTheme,
                          textTheme: temporaryTextTheme),
                      title: kDebugMode ? "yNotes DEV" : "yNotes",
                      navigatorKey: AppConfig.navigatorKey,
                      initialRoute: "/loading",
                      themeMode: ThemeMode.light,
                      onGenerateRoute: onGenerateRoute,
                    ));
                  }),
                ));
      }),
    );
  }

  @override
  initState() {
    super.initState();
  }
}
