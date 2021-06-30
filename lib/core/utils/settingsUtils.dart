import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loggingUtils.dart';

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
      "migratedHW": false
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
    await setSetting(_oldSettings);
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

  static Future<Map> getOldSettings() async {
    //Deep clone lol
    Map _settings = json.decode(json.encode(settingsForm));

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

  static Future<Map?> getSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? settings = prefs.getString("settings");

    if (settings == null) {
      settings = json.encode(settingsForm);
    }
    CustomLogger.log("SETTINGS UTILS", "Settings form: $settingsForm");
    CustomLogger.log("SETTINGS UTILS", "Settings: $settings");

    Map? _settings = json.decode(settings);
    return mergeMaps(json.decode(json.encode(settingsForm)), _settings ?? {});
  }

  //Oops
  static getSettings() async {
    Map _settings;
    Map _oldSettings;
    Map? _newSettings;
    _oldSettings = await getOldSettings();
    _newSettings = await getSavedSettings();

    CustomLogger.log("SETTINGS UTILS", "Are new settings null? ${_newSettings == null}");
    //merge settings
    _settings = Map.from(json.decode(json.encode(_oldSettings)))..addAll(_newSettings ?? {});
    if (_newSettings == null) {
      await setSetting(_settings);
    }
    CustomLogger.log("SETTINGS UTILS", "Settings: $_settings");
    return _settings;
  }

  static setSetting(Map? newMap) async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = json.encode(newMap);
    await prefs.setString("settings", encoded);
  }
}
