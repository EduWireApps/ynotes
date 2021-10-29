part of logging_utils;

/// A data model for logging.
class YLog {
  /// The log category, for example notifications"
  final String category;

  /// A human readable comment
  final String comment;

  /// The log stacktrace
  final String? stacktrace;

  /// The log's date.
  final DateTime date;

  /// A data model for logging.
  YLog({
    required this.category,
    required this.comment,
    required this.date,
    this.stacktrace,
  });

  /// Creates a new [YLog] from a json object.
  factory YLog.fromJson(Map<String, dynamic> json) => YLog(
        category: (json['category'] as String?) ?? "",
        comment: (json['comment'] as String?) ?? "",
        stacktrace: (json['stacktrace'] as String?),
        date: (DateTime.tryParse(json['date'])) ?? DateTime.now(),
      );

  /// Creates a json object from a [YLog].
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'comment': comment.toString(),
      'stacktrace': stacktrace,
      'date': date.toString(),
    };
  }
}
