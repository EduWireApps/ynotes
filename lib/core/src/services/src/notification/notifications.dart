part of notification_service;

final Color _color = Colors.indigo[600]!;

abstract class OSNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final NotificationDetails details;

  OSNotification({
    required this.id,
    this.title,
    this.body,
    required this.details,
    NotificationPayload? payload,
  }) : payload = json.encode(payload?.toJson());
}

class GradeNotification extends OSNotification {
  GradeNotification({required Grade grade, required List<Subject> subjects})
      : super(
          id: grade.hashCode,
          title:
              "${grade.value.display()}/${grade.outOf.display()} coefficient ${grade.coefficient.display()} en ${grade.subject.value!.name}",
          body: "Moyenne de la classe: ${grade.classAverage.display()}/${grade.outOf.display()}",
          details: NotificationDetails(
              android: AndroidNotificationDetails("yn", "ynotes_notifications",
                  importance: Importance.high, priority: Priority.high, color: _color, subText: "Nouvelle note")),
          payload: NotificationPayload(
            routePath: "/grades",
            arguments: {"id:": grade.hashCode, "periodId": grade.period.value?.id},
          ),
        );
}
