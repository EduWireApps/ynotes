part of notification_service;

// TODO: implement
// https://pub.dev/packages/flutter_local_notifications

class NotificationService {
  const NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const String _logKey = "NOTIFICATION SERVICE";

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('appicon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: (_, __, ___, ____) {});
    const MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
        const LinuxInitializationSettings initializationSettingsLinux= LinuxInitializationSettings(defaultActionName: "");

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS, linux: initializationSettingsLinux);
    await _plugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
    // TODO: handle intents.
    // final NotificationAppLaunchDetails? appLaunchDetails = await _plugin.getNotificationAppLaunchDetails();
    // if (appLaunchDetails != null && appLaunchDetails.didNotificationLaunchApp) {
    //   _onSelectNotification(appLaunchDetails.payload);
    // }
  }

  /// The functions that gets triggered when a notification is tapped.
  static void _onSelectNotification(String? payload) async {
    if (payload == null) {
      Logger.log(_logKey, "Notification tapped with no payload.");
      return;
    }
    debugPrint(payload);
    final NotificationPayload notificationPayload = NotificationPayload.fromJson(json.decode(payload));
    Navigator.of(AppConfig.navigatorKey.currentState!.context)
        .pushNamed(notificationPayload.routePath, arguments: notificationPayload.arguments);
    // TODO: handle payload
  }

  static Future<void> show(OSNotification n) async {
    await _plugin.show(n.id, n.title, n.body, n.details, payload: n.payload);
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
