part of notification_service;

class NotificationPayload {
  final String routePath;
  final Map<String, dynamic> arguments;

  const NotificationPayload({
    required this.routePath,
    required this.arguments,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      routePath: json['routePath'] as String,
      arguments: json['arguments'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routePath': routePath,
      'arguments': arguments,
    };
  }
}
