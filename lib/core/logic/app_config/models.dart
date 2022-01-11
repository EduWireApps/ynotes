import 'package:json_annotation/json_annotation.dart';

enum appTabs {
  @JsonValue("SUMMARY")
  summary,
  @JsonValue("GRADES")
  grades,
  @JsonValue("HOMEWORK")
  homework,
  @JsonValue("AGENDA")
  agenda,
  @JsonValue("POLLS")
  polls,
  @JsonValue("MESSAGING")
  messaging,
  @JsonValue("CLOUD")
  cloud,
  @JsonValue("FILES")
  files,
  @JsonValue("SCHOOL_LIFE")
  schoolLife,
}
