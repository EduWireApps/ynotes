part of notifications_service;

class NotificationService {
  const NotificationService._();

  Future<void> cancelNotification(int id) async {
    // await flutterLocalNotificationsPlugin.cancel(id);
  }
}
