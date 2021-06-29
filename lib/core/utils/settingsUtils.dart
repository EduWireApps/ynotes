import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AgendaPageSettings {
  bool lighteningOverride;
  bool agendaOnGoingNotification;
  bool reverseWeekNames;
  int lessonReminderDelay;
  bool enableDNDWhenOnGoingNotifEnabled;
  bool disableAtDayEnd;

  AgendaPageSettings({
    required this.lighteningOverride,
    required this.agendaOnGoingNotification,
    required this.reverseWeekNames,
    required this.lessonReminderDelay,
    required this.enableDNDWhenOnGoingNotifEnabled,
    required this.disableAtDayEnd,
  });

  factory AgendaPageSettings.fromJson(Map<String, dynamic> json) => AgendaPageSettings(
        lighteningOverride: (json['lighteningOverride'] as bool?) ?? false,
        agendaOnGoingNotification: (json['agendaOnGoingNotification'] as bool?) ?? false,
        reverseWeekNames: (json['reverseWeekNames'] as bool?) ?? false,
        lessonReminderDelay: (json['lessonReminderDelay'] as int?) ?? 5,
        enableDNDWhenOnGoingNotifEnabled: (json['enableDNDWhenOnGoingNotifEnabled'] as bool?) ?? false,
        disableAtDayEnd: (json['disableAtDayEnd'] as bool?) == false,
      );

  Map<String, Object> toJson() => {
        'lighteningOverride': lighteningOverride,
        'agendaOnGoingNotification': agendaOnGoingNotification,
        'reverseWeekNames': reverseWeekNames,
        'lessonReminderDelay': lessonReminderDelay,
        'enableDNDWhenOnGoingNotifEnabled': enableDNDWhenOnGoingNotifEnabled,
        'disableAtDayEnd': disableAtDayEnd,
      };
}

class FormSettings {
  SystemSettings system;
  UserSettings user;

  FormSettings({
    required this.system,
    required this.user,
  });

  factory FormSettings.fromJson(Map<String, dynamic> json) => FormSettings(
        system: SystemSettings.fromJson(
          json['system'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        user: UserSettings.fromJson(
          json['user'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
      );
}

class GlobalUserSettings {
  bool nightmode;
  String theme;
  bool batterySaver;
  bool notificationNewMail;
  bool notificationNewGrade;
  bool shakeToReport;
  bool autoCloseDrawer;

  GlobalUserSettings({
    required this.nightmode,
    required this.theme,
    required this.batterySaver,
    required this.notificationNewMail,
    required this.notificationNewGrade,
    required this.shakeToReport,
    required this.autoCloseDrawer,
  });

  factory GlobalUserSettings.fromJson(Map<String, dynamic> json) => GlobalUserSettings(
        nightmode: (json['nightmode'] as bool?) ?? false,
        theme: (json['theme'] as String?) ?? 'clair',
        batterySaver: (json['batterySaver'] as bool?) ?? false,
        notificationNewMail: (json['notificationNewMail'] as bool?) ?? false,
        notificationNewGrade: (json['notificationNewGrade'] as bool?) ?? false,
        shakeToReport: (json['shakeToReport'] as bool?) ?? false,
        autoCloseDrawer: (json['autoCloseDrawer'] as bool?) ?? false,
      );

  Map<String, Object> toJson() => {
        'nightmode': nightmode,
        'theme': theme,
        'batterySaver': batterySaver,
        'notificationNewMail': notificationNewMail,
        'notificationNewGrade': notificationNewGrade,
        'shakeToReport': shakeToReport,
        'autoCloseDrawer': autoCloseDrawer,
      };
}

class HomeworkPageSettings {
  bool isExpandedByDefault;
  bool forceMonochromeContent;
  int fontSize;
  int pageColorVariant;
  String customDisciplinesList;

  HomeworkPageSettings({
    required this.isExpandedByDefault,
    required this.forceMonochromeContent,
    required this.fontSize,
    required this.pageColorVariant,
    required this.customDisciplinesList,
  });

  factory HomeworkPageSettings.fromJson(Map<String, dynamic> json) => HomeworkPageSettings(
        isExpandedByDefault: (json['isExpandedByDefault'] as bool?) ?? false,
        forceMonochromeContent: (json['forceMonochromeContent'] as bool?) ?? false,
        fontSize: (json['fontSize'] as int?) ?? 20,
        pageColorVariant: (json['pageColorVariant'] as int?) ?? 0,
        customDisciplinesList: (json['customDisciplinesList'] as String?) ?? '[]',
      );

  Map<String, Object> toJson() => {
        'isExpandedByDefault': isExpandedByDefault,
        'forceMonochromeContent': forceMonochromeContent,
        'fontSize': fontSize,
        'pageColorVariant': pageColorVariant,
        'customDisciplinesList': customDisciplinesList,
      };
}

class SettingsUtils {
  static const Map secureSettingsForm = {"username": "", "password": "", "pronoteurl": "", "pronotecas": ""};
  static const Map settingsForm = {
    //System global settings
    "system": {
      "firstUse": false,
      "lastReadUpdateNote": "",
      "chosenParser": null,
      "lastMailCount": 0,
      "lastGradeCount": 0,
      "migratedHW": false,
      "accountIndex": null
    },

    ///The user's app global settings
    ///As theme, notifications, choices..
    "user": {
      "global": {
        "nightmode": false,
        "theme": "clair",
        "batterySaver": false,
        "notificationNewMail": false,
        "notificationNewGrade": false,
        "shakeToReport": false,
        "autoCloseDrawer": false,
      },
      "summaryPage": {"summaryQuickHomework": 11},
      "homeworkPage": {
        "isExpandedByDefault": false,
        "forceMonochromeContent": false,
        "fontSize": 20,
        "pageColorVariant": 0,
        "customDisciplinesList": "[]"
      },
      "agendaPage": {
        "lighteningOverride": false,
        "agendaOnGoingNotification": false,
        "reverseWeekNames": false,
        "lessonReminderDelay": 5,
        "enableDNDWhenOnGoingNotifEnabled": false,
        "disableAtDayEnd": false
      }
    },
  };
  //retrieve old settings
  //and parse it to new settings format
  static forceRestoreOldSettings() async {
    var _oldSettings = await getOldSettings();
    await setSetting(FormSettings.fromJson(_oldSettings));
    return _oldSettings;
  }

  static Map getAppSettings() {
    //App settings
    return {};
  }

  ///Deprecated
  static Future<bool?> getBoolSetting(String setting) async {
    final prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool(setting);
    return value;
  }

  static Future<int> getIntSetting(String setting) async {
    final prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(setting);
    if (value == null) {
      value = 0;
      if (setting == "summaryQuickHomework") {
        value = 10;
      }
      if (setting == "fontSize") {
        value = 11;
      }
      if (setting == "lessonReminderDelay") {
        value = 5;
      }
    }
    return value;
  }

  static Future<Map<String, dynamic>> getOldSettings() async {
    //Deep clone lol
    Map<String, dynamic> _settings = json.decode(json.encode(settingsForm));

    for (var key1 in (_settings["user"] as Map).keys) {
      for (var entry in (_settings["user"][key1] as Map).entries) {
        if (entry.value.runtimeType == int) {
          _settings["user"][key1][entry.key] = (await getIntSetting(entry.key));
        }
        if (entry.value.runtimeType == bool) {
          _settings["user"][key1][entry.key] = (await getBoolSetting(entry.key)) ?? entry.value;
        }
      }
    }
    for (var entry in (_settings["system"] as Map).entries) {
      if (entry.value.runtimeType == int) {
        _settings["system"][entry.key] = (await getIntSetting(entry.key));
      }
      if (entry.value.runtimeType == bool) {
        _settings["system"][entry.key] = (await getBoolSetting(entry.key)) ?? entry.value;
      }
    }
    return _settings;
    //The user's settings per page
  }

  static Map getOldSettingsOld() {
    Map _settings = json.decode(json.encode(settingsForm));
    (_settings["user"] as Map).keys.forEach((key1) {
      (_settings["user"][key1] as Map).forEach((key2, value) {
        if (value.runtimeType == int) {
          value = getIntSetting(key2);
        }
        if (value.runtimeType == bool) {
          value = getBoolSetting(key2);
        }
      });
    });
    (_settings["user"] as Map).forEach((key, value) {
      if (value.runtimeType == int) {
        value = getIntSetting(key);
      }
      if (value.runtimeType == bool) {
        value = getBoolSetting(key);
      }
    });
    return _settings;
    //The user's settings per page
  }

  static Future<Map<String, dynamic>?> getSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? settings = prefs.getString("settings");
    if (settings == null) {
      settings = json.encode(settingsForm);
    }
    Map<String, dynamic>? _settings = json.decode(settings);
    return _settings;
  }

  //Oops
  static getSettings() async {
    return FormSettings.fromJson((await getSavedSettings()) ?? {});
  }

  static setSetting(FormSettings newSettings) async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = json.encode(newSettings);
    await prefs.setString("settings", encoded);
  }
}

class SummaryPageSettings {
  int summaryQuickHomework;

  SummaryPageSettings({
    required this.summaryQuickHomework,
  });

  factory SummaryPageSettings.fromJson(Map<String, dynamic> json) => SummaryPageSettings(
        summaryQuickHomework: (json['summaryQuickHomework'] as int?) ?? 11,
      );

  Map<String, Object> toJson() => {
        'summaryQuickHomework': summaryQuickHomework,
      };
}

class SystemSettings {
  bool firstUse;
  String lastReadUpdateNote;
  Null chosenParser;
  int lastMailCount;
  int lastGradeCount;
  bool migratedHW;
  int accountIndex;
  SystemSettings({
    required this.firstUse,
    required this.lastReadUpdateNote,
    required this.chosenParser,
    required this.lastMailCount,
    required this.lastGradeCount,
    required this.migratedHW,
    required this.accountIndex,
  });

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
        firstUse: (json['firstUse'] as bool?) ?? false,
        lastReadUpdateNote: (json['lastReadUpdateNote'] as String?) ?? '',
        chosenParser: json['chosenParser'] as Null,
        lastMailCount: (json['lastMailCount'] as int?) ?? 0,
        lastGradeCount: (json['lastGradeCount'] as int?) ?? 0,
        migratedHW: (json['migratedHW'] as bool?) ?? false,
        accountIndex: (json['accountIndex'] as int?) ?? 0,
      );

  Map<String, Object?> toJson() => {
        'firstUse': firstUse,
        'lastReadUpdateNote': lastReadUpdateNote,
        'chosenParser': chosenParser,
        'lastMailCount': lastMailCount,
        'lastGradeCount': lastGradeCount,
        'migratedHW': migratedHW,
        'accountIndex': accountIndex
      };
}

class UserSettings {
  GlobalUserSettings global;
  SummaryPageSettings summaryPage;
  HomeworkPageSettings homeworkPage;
  AgendaPageSettings agendaPage;

  UserSettings({
    required this.global,
    required this.summaryPage,
    required this.homeworkPage,
    required this.agendaPage,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        global: GlobalUserSettings.fromJson(
          json['global'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        summaryPage: SummaryPageSettings.fromJson(
          json['summaryPage'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        homeworkPage: HomeworkPageSettings.fromJson(
          json['homeworkPage'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        agendaPage: AgendaPageSettings.fromJson(
          json['agendaPage'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
      );

  Map<String, Object> toJson() => {
        'global': global,
        'summaryPage': summaryPage,
        'homeworkPage': homeworkPage,
        'agendaPage': agendaPage,
      };
}
