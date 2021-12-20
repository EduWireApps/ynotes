part of app;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  initState() {
    super.initState();
    AppConfig.navigatorKey = GlobalKey<NavigatorState>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
}
