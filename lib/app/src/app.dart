part of app;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late Brightness _brightness;

  void setBrightness(Brightness brightness) {
    setState(() {
      _brightness = brightness;
    });
  }

  @override
  initState() {
    super.initState();
    AppConfig.navigatorKey = GlobalKey<NavigatorState>();
    final window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      setBrightness(window.platformBrightness);
    };
    setBrightness(window.platformBrightness);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return FocusDetector(
      onForegroundGained: () {
        UIU.setSystemUIOverlayStyle();
      },
      child: Responsive(builder: (context) {
        return YApp(
            initialTheme: SettingsService.settings.global.themeId,
            themes: themes(_brightness),
            builder: (context) {
              UIU.setSystemUIOverlayStyle();
              return ChangeNotifierConsumer<Settings>(
                  controller: SettingsService.settings,
                  builder: (context, _, __) => MaterialApp(
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
                        theme: theme.themeData.copyWith(textTheme: temporaryTextTheme),
                        title: kDebugMode ? "yNotes DEV" : "yNotes",
                        navigatorKey: AppConfig.navigatorKey,
                        initialRoute: "loading",
                        themeMode: ThemeMode.light,
                        onGenerateRoute: AppRouter.onGenerateRoute,
                      ));
            });
      }),
    );
  }
}
