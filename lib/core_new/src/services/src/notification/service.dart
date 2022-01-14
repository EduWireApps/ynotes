part of notification_service;

// TODO: implement
// https://pub.dev/packages/flutter_local_notifications

class NotificationService {
  const NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const String _logKey = "NOTIFICATION SERVICE";

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: (_, __, ___, ____) {});
    const MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);
    await _plugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
  }

  /// The functions that gets triggered when a notification is tapped.
  static void _onSelectNotification(String? payload) async {
    if (payload == null) {
      Logger.log(_logKey, "Notification tapped with no payload.");
      return;
    }
    final NotificationPayload notificationPayload = NotificationPayload.fromJson(json.decode(payload));
    // TODO: handle payload
  }

  static Future<void> show(Notification n) async {
    await _plugin.show(n.id, n.title, n.body, n.details, payload: n.payload);
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
