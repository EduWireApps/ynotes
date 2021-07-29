import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_responsive_breakpoints/flutter_responsive_breakpoints.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/services/background.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/hive_life_cycle_manager.dart';
import 'package:ynotes/ui/screens/loading/loading.dart';
import 'package:ynotes/ui/themes/themes.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

import 'package:sizer/sizer.dart';

Future main() async {
  Logger.level = Level.warning;
  WidgetsFlutterBinding.ensureInitialized();
  theme = YCurrentTheme(currentTheme: 1, themes: themes, fontFamily: "Asap");

  appSys = ApplicationSystem();
  await appSys.initApp();
  if (!kIsWeb) BackgroundFetch.registerHeadlessTask(_headlessTask);

  runZoned<Future<Null>>(() async {
    runApp(Phoenix(child: App()));
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
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ChangeNotifierProvider<ApplicationSystem>.value(
      value: appSys,
      child: Consumer<ApplicationSystem>(builder: (context, model, child) {
        return Wiredash(
            projectId: "ynotes-giw0qs2",
            secret: "y9zengsvskpriizwniqxr6vxa1ka1n6u",
            navigatorKey: _navigatorKey,
            theme: WiredashThemeData(
                brightness: Brightness.dark,
                primaryColor: theme.colors.primary.shade300,
                secondaryColor: theme.colors.primary.shade300,
                primaryTextColor: theme.colors.neutral.shade500,
                secondaryTextColor: theme.colors.neutral.shade400,
                tertiaryTextColor: theme.colors.neutral.shade400,
                primaryBackgroundColor: theme.colors.neutral.shade200,
                secondaryBackgroundColor: theme.colors.neutral.shade100,
                backgroundColor: theme.colors.neutral.shade200,
                dividerColor: theme.variableStyles.primary.plain.text,
                errorColor: theme.colors.danger.shade300,
                firstPenColor: theme.colors.danger.shade300,
                secondPenColor: theme.colors.success.shade300,
                thirdPenColor: theme.colors.warning.shade300,
                fourthPenColor: theme.colors.primary.shade300,
                sheetBorderRadius: BorderRadius.vertical(top: Radius.circular(YScale.s6)),
                fontFamily: theme.fontFamily),
            options: WiredashOptionsData(
              /// You can set your own locale to override device default (`window.locale` by default)
              locale: const Locale.fromSubtags(languageCode: 'fr'),
            ),
            child: HiveLifecycleManager(
              child: Responsive(
                builder: (context) => Sizer(
                  builder: (context, orientation, deviceType) => MaterialApp(
                    localizationsDelegates: [
                      // ... app-specific localization delegate[s] here
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: [
                      const Locale('fr'), //French
                    ],
                    debugShowCheckedModeBanner: false,
                    theme: model.themeData,
                    title: kDebugMode ? "yNotes DEV" : "yNotes",
                    navigatorKey: _navigatorKey,
                    home: LoadingPage(),
                    themeMode: ThemeMode.light,
                    onGenerateRoute: onGenerateRoute,
                  ),
                ),
              ),
            ));
      }),
    );
  }

  initState() {
    super.initState();
  }
}
