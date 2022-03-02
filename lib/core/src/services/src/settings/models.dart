part of settings_service;

// flutter pub run build_runner build --delete-conflicting-outputs

// TODO: documentation

@JsonSerializable()
class GlobalSettings {
  String lastReadPatchNotes;
  int themeId;
  Apis api;
  bool batterySaver;
  bool shakeToReport;
  String? uuid;
  String? userFirstName;
  String? userLastName;

  GlobalSettings(
      {required this.lastReadPatchNotes,
      required this.themeId,
      required this.api,
      required this.batterySaver,
      required this.shakeToReport,
      required this.uuid,
      required this.userFirstName,
      required this.userLastName});

  factory GlobalSettings.fromJson(Map<String, dynamic> json) => _$GlobalSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$GlobalSettingsToJson(this);
}

@JsonSerializable()
class HomeworkPageSettings {
  bool forceMonochrome;
  int fontSize;
  int colorVariant;

  HomeworkPageSettings({required this.forceMonochrome, required this.fontSize, required this.colorVariant});

  factory HomeworkPageSettings.fromJson(Map<String, dynamic> json) => _$HomeworkPageSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkPageSettingsToJson(this);
}

@JsonSerializable()
class NotificationsSettings {
  bool newEmail;
  bool newGrade;

  NotificationsSettings({required this.newEmail, required this.newGrade});

  factory NotificationsSettings.fromJson(Map<String, dynamic> json) => _$NotificationsSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsSettingsToJson(this);
}

@JsonSerializable()
class PagesSettings {
  HomeworkPageSettings homework;

  PagesSettings({required this.homework});

  factory PagesSettings.fromJson(Map<String, dynamic> json) => _$PagesSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PagesSettingsToJson(this);
}

@JsonSerializable()
class Settings extends ChangeNotifier {
  GlobalSettings global;
  PagesSettings pages;
  NotificationsSettings notifications;

  Settings({required this.global, required this.pages, required this.notifications});

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  void notify() => notifyListeners();

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
