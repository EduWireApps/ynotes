part of logger;

/// A data model for logging.
class Log {
  /// The log category, for example notifications"
  final String category;

  /// A human readable comment
  final String comment;

  /// The log stacktrace
  final String? stacktrace;

  late DateTime _date;

  /// The log's date.
  DateTime get date => _date;

  /// A data model for logging.
  Log({
    required this.category,
    required this.comment,
    DateTime? date,
    this.stacktrace,
  }) {
    _date = date ?? DateTime.now();
  }

  /// Creates a new [Log] from a json object.
  factory Log.fromJson(Map<String, dynamic> json) => Log(
        category: (json['category'] as String?) ?? "",
        comment: (json['comment'] as String?) ?? "",
        stacktrace: (json['stacktrace'] as String?),
        date: (DateTime.tryParse(json['date'])) ?? DateTime.now(),
      );

  /// Creates a json object from a [Log].
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'comment': comment.toString(),
      'stacktrace': stacktrace.toString(),
      'date': date.toString(),
    };
  }
}
