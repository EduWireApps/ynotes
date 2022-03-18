part of models;

/// The model for a grade.
///
/// Can be stored in [Hive] storage.
@Collection()
class Grade extends _LinkedModel {
  @Id()
  int? id;

  /// The name of the assessment associated with this grade.

  final String name;

  /// The grade value and its numeric details
  final IsarLink<GradeValue> _gradeValue = IsarLink<GradeValue>();

  /// The type of assessment. Depends of the api.

  final String type;

  /// The assessment's date.

  final DateTime date;

  /// The date of the grade's entry by the teacher.

  final DateTime entryDate;

  /// The class average. Not calculated in realtime.

  final double classAverage;

  /// The highest grade in the class.

  final double classMax;

  /// The lowest grade in the class.

  final double classMin;

  /// If the grade is custom.

  final bool custom;

  final IsarLink<Subject> subject = IsarLink<Subject>();

  final IsarLink<Period> period = IsarLink<Period>();

  // TODO: implement competences

  Grade(
      {required this.name,
      required this.type,
      required this.date,
      required this.entryDate,
      required this.classAverage,
      required this.classMax,
      required this.classMin,
      this.custom = false});

  /// A grade that can be added by the user.
  /// Some fields are useless so this class let's you create a [Grade]
  /// with only required data.
  Grade.custom()
      : name = "Simulée",
        type = "Simulation",
        date = DateTime.now(),
        entryDate = DateTime.now(),
        classAverage = double.nan,
        classMax = double.nan,
        classMin = double.nan,
        custom = true;

  GradeValue get value {
    _gradeValue.loadSync();
    return _gradeValue.value!;
  }

  set value(GradeValue newValue) {
    _gradeValue.value = newValue;
  }

  /// The value out of 20. Use this to calculate averages.
  double get realValue {
    if (value.valueType == gradeValueType.double) {
      return 20 * value.doubleValue! / value.outOf!;
    }
    if (value.valueType == gradeValueType.stringWithValue) {
      return 20 * value.doubleValue! / value.outOf!;
    } else {
      return double.nan;
    }
  }

  @override
  void load() {
    Offline.isar.writeTxnSync((isar) {
      subject.loadSync();
      period.loadSync();
      _gradeValue.loadSync();
    });
  }
}

/// The grade displayed Value

/// It can be a regular double or a String

@Collection()
class GradeValue {
  @Id()
  int? id;

  /// The coefficient. Can be 0.
  final double coefficient;

  /// The grade's denominator, 20 is the default one in France.

  final double outOf;

  /// The grade's numerator. Between 0 and [outOf].
  @GradeValueTypeConverter()
  final gradeValueType valueType;

  /// Grade String value
  final String? stringValue;

  /// Grade double value
  final double? doubleValue;

  /// If the grade counts for the average.

  final bool significant;

  GradeValue(
      {required this.coefficient,
      required this.outOf,
      required this.valueType,
      this.stringValue,
      this.doubleValue,
      required this.significant}) {
    assert(
        (valueType == gradeValueType.string && stringValue != null) ||
            (valueType == gradeValueType.stringWithValue &&
                stringValue != null &&
                valueType == gradeValueType.double &&
                doubleValue != null &&
                outOf != null &&
                coefficient != null) ||
            (valueType == gradeValueType.double && doubleValue != null && outOf != null && coefficient != null),
        "Grade value should be consistent");
  }
  String get display {
    if (valueType == gradeValueType.double) {
      return doubleValue!.display();
    }
    return stringValue!;
  }

  dynamic get value {
    switch (valueType) {
      case (gradeValueType.double):
        return doubleValue;
      case (gradeValueType.string):
        return stringValue;
      case (gradeValueType.stringWithValue):
        return stringValue;
      default:
        return doubleValue;
    }
  }
}

enum gradeValueType { double, string, stringWithValue }
