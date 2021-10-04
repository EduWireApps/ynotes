import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_responsive_breakpoints/flutter_responsive_breakpoints.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/backward_compatibility.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/hive_life_cycle_manager.dart';
import 'package:ynotes/ui/screens/loading/loading.dart';
import 'package:ynotes/ui/themes/themes.dart';
import 'package:ynotes_packages/config.dart';
import 'package:ynotes_packages/theme.dart';

Future main() async {
  Logger.level = Level.warning;
  WidgetsFlutterBinding.ensureInitialized();
  await backwardCompatibility();
  theme = YCurrentTheme(currentTheme: 1, themes: themes); // TODO: rework how theme integrates in the app

  appSys = ApplicationSystem();
  await appSys.initApp();
  if (!kIsWeb) BackgroundFetch.registerHeadlessTask(_headlessTask);

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
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return FocusDetector(
      onForegroundGained: () {
        UIUtils.setSystemUIOverlayStyle();
      },
      child: ChangeNotifierProvider<ApplicationSystem>.value(
        value: appSys,
        child: Consumer<ApplicationSystem>(builder: (context, model, child) {
          return Wiredash(
            projectId: "ynotes-giw0qs2",
            secret: "y9zengsvskpriizwniqxr6vxa1ka1n6u",
            navigatorKey: _navigatorKey,
            theme: WiredashThemeData(
                backgroundColor: ThemeUtils.isThemeDark ? const Color(0xff313131) : Colors.white,
                primaryBackgroundColor: ThemeUtils.isThemeDark ? const Color(0xff414141) : const Color(0xffF3F3F3),
                secondaryBackgroundColor: ThemeUtils.isThemeDark ? const Color(0xff313131) : Colors.white,
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
              child: YApp(
                initialTheme: 1,
                themes: themes,
                builder: (context) => Responsive(
                  builder: (context) => MaterialApp(
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
                    ),
                    title: kDebugMode ? "yNotes DEV" : "yNotes",
                    navigatorKey: _navigatorKey,
                    home: const LoadingPage(),
                    themeMode: ThemeMode.light,
                    onGenerateRoute: onGenerateRoute,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  initState() {
    super.initState();
  }
}
