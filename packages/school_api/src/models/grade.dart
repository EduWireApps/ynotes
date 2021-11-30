part of school_api;

class Grade extends Model<Grade> {
  const Grade({required this.value});
  factory Grade.fromMap(Map<String, dynamic> data) {
    return Grade(value: data['value']);
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      "value": value,
    };
  }

  final double value;
}

final Grade grade = Grade.fromMap(const {});
