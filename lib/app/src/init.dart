part of app;

Future<void> initApp() async {
  Logger.level = Level.warning;
  WidgetsFlutterBinding.ensureInitialized();
  await backwardCompatibility();
  theme = YCurrentTheme(currentTheme: 1, themes: themes); // TODO: rework how theme integrates in the app

  appSys = ApplicationSystem();
  await appSys.initApp();

  BugReportUtils.init();

  if (!kIsWeb && !Platform.isLinux && !Platform.isWindows) BackgroundFetch.registerHeadlessTask(_headlessTask);
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
