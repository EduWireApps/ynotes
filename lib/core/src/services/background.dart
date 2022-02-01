library background_service;

import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:ynotes/app/app.dart';

import 'package:ynotes/core/services.dart';
import 'package:ynotes/core/utilities.dart';

/// A class that manages background interactions. Works only on
/// Android and iOS (handled within [init]).
class BackgroundService {
  const BackgroundService._();

  static const String _logKey = 'BACKGROUND SERVICE';

  /// Starts the background service.
  static Future<void> init() async {
    Logger.log(_logKey, "Intializing...");
    if (!(Platform.isAndroid)) {
      Logger.log(_logKey, "Unsupported platform");
      return;
    }

    await _registerHeadlessTask();
    Logger.log(_logKey, "Headless task registered.");
    Logger.log(_logKey, "Configuring.");
    final int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY),
        (String taskId) async => await _onfetch(taskId, headless: true),
        (String taskId) async => await _onTimeout(taskId));
    Logger.log(_logKey, "Status: $status");
  }

  /// Registers the headless task in [BackgroundFetch].
  static Future<void> _registerHeadlessTask() async {
    await BackgroundFetch.registerHeadlessTask((HeadlessTask task) async {
      String taskId = task.taskId;
      bool isTimeout = task.timeout;
      if (isTimeout) {
        await _onTimeout(taskId);
        return;
      }
      await _onfetch(taskId, headless: true);
    });
  }

  /// Handles the fetch event.
  static Future<void> _onfetch(String taskId, {required bool headless}) async {
    Logger.log(_logKey, "Headless event received: $taskId");
    try {
      if (headless) {
        await SystemService.init();
      }
      await schoolApi.fetch();
    } catch (e) {
      // TODO: cancel notification
      // await AppNotification.cancelNotification(a.hashCode);
    }
    // REQUIRED
    // This instruction muse be located at the end of this function.
    BackgroundFetch.finish(taskId);
  }

  /// Handles the timeout event.
  static Future<void> _onTimeout(String taskId) async {
    Logger.log(_logKey, "Headless task timed-out: $taskId");
    // TODO: cancel notification
    // await AppNotification.cancelNotification(task.taskId.hashCode);
    BackgroundFetch.finish(taskId);
  }
}
