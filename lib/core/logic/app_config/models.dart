import 'package:json_annotation/json_annotation.dart';

enum appTabs {
  @JsonValue("SUMMARY")
  SUMMARY,
  @JsonValue("GRADES")
  GRADES,
  @JsonValue("COMPETENCES")
  COMPETENCES,
  @JsonValue("HOMEWORK")
  HOMEWORK,
  @JsonValue("AGENDA")
  AGENDA,
  @JsonValue("POLLS")
  POLLS,
  @JsonValue("MESSAGING")
  MESSAGING,
  @JsonValue("CLOUD")
  CLOUD,
  @JsonValue("FILES")
  FILES,
  @JsonValue("SCHOOL_LIFE")
  SCHOOL_LIFE,
}
