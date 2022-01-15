part of notification_service;

class Notification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final NotificationDetails details =
      NotificationDetails(android: AndroidNotificationDetails("id", "ynotes_notifications"));

  Notification({
    required this.id,
    this.title,
    this.body,
    NotificationPayload? payload,
  }) : payload = json.encode(payload?.toJson());
}
