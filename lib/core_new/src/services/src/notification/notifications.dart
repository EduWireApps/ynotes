part of notification_service;

class Notification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final NotificationDetails? details;

  Notification({
    required this.id,
    this.title,
    this.body,
    this.details,
    NotificationPayload? payload,
  }) : payload = json.encode(payload?.toJson());
}
