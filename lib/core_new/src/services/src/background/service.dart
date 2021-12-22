part of background_service;

// TODO: implement BackgroundService

class BackgroundService {
  const BackgroundService._();

  static Future<void> init() async {
    // if (!kIsWeb && !Platform.isLinux && !Platform.isWindows) BackgroundFetch.registerHeadlessTask(_headlessTask);
  }
}

// _headlessTask(HeadlessTask? task) async {
//   if (task != null) {
//     if (task.timeout) {
//       await AppNotification.cancelNotification(task.taskId.hashCode);
//       BackgroundFetch.finish(task.taskId);
//     }
//     await bgs.BackgroundService.backgroundFetchHeadlessTask(task.taskId, headless: true);
//     BackgroundFetch.finish(task.taskId);
//   }
// }
