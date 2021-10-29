import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utils/settings/model.dart';

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
    for (var key1 in (_settings["user"] as Map).keys) {
      (_settings["user"][key1] as Map).forEach((key2, value) {
        if (value.runtimeType == int) {
          value = getIntSetting(key2);
        }
        if (value.runtimeType == bool) {
          value = getBoolSetting(key2);
        }
      });
    }
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
    settings ??= json.encode(settingsForm);
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
    CustomLogger.log("SETTINGS", "Set setting: $encoded");
    await prefs.setString("settings", encoded);
  }
}
