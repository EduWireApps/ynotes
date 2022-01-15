part of notification_service;

final Color _color = Colors.indigo[600]!;

class OSNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails("yn", "ynotes_notifications",
          importance: Importance.high, priority: Priority.high, color: _color, subText: "Notes"));

  OSNotification({
    required this.id,
    this.title,
    this.body,
    NotificationPayload? payload,
  }) : payload = json.encode(payload?.toJson());
}
