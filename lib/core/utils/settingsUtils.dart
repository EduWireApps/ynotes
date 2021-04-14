import 'dart:convert';

import 'package:ynotes/core/services/shared_preferences.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';

class SettingsUtils {
  static const Map secureSettingsForm = {"username": "", "password": "", "pronoteurl": "", "pronotecas": ""};
  static Map settingsForm = {
    //System global settings
    "system": {
      "firstUse": false,
      "agreedTermsAndConfiguredApp": false,
      "chosenParser": 0,
      "lastMailCount": 0,
      "lastGradeCount": 0
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
      "summaryPage": {"summaryQuickHomework": 1},
      "homeworkPage": {
        "isExpandedByDefault": false,
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
  static Map getOldSettings() {
    Map _settings = settingsForm;
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
    (_settings["system"] as Map).forEach((key, value) {
      if (value.runtimeType == int) {
        value = getIntSetting(key);
      }
      if (value.runtimeType == bool) {
        value = getBoolSetting(key);
      }
    });
    print(_settings);
    return _settings;
    //The user's settings per page
  }

  static getSettings() async {
    Map _settings;
    Map _oldSettings;
    Map? _newSettings;
    _oldSettings = getOldSettings();
    print(_oldSettings == null);
    _newSettings = await getSavedSettings();

    print(_newSettings == null);

    //merge settings
    _settings = {
      ..._oldSettings,
      ..._newSettings ?? settingsForm,
    };
    return _settings;
  }

  static Future<Map?> getSavedSettings() async {
    final prefs = await (SharedPreferences.getInstance() as Future<SharedPreferences>);
    String? settings = prefs.getString("settings");

    if (settings == null) {
      settings = json.encode(settingsForm);
    }
    print(settings);
    Map? _settings = json.decode(settings);
    return _settings;
  }

  static setSetting(Map? newMap) async {
    final prefs = await (SharedPreferences.getInstance() as Future<SharedPreferences>);
    String encoded = json.encode(newMap);
    await prefs.setString("settings", encoded);
  }

  ///Deprecated
  static Future<bool?> getBoolSetting(String setting) async {
    final prefs = await (SharedPreferences.getInstance() as Future<SharedPreferences>);
    bool? value = prefs.getBool(setting);
    return value;
  }

  //Deprecated
  static Future<int> getIntSetting(String setting) async {
    final prefs = await (SharedPreferences.getInstance() as Future<SharedPreferences>);
    var value = prefs.getInt(setting);
    if (value == null) {
      value = 0;
      if (setting == "summaryQuickHomework") {
        value = 10;
      }
      if (setting == "lessonReminderDelay") {
        value = 5;
      }
    }
    return value;
  }

  static Map getAppSettings() {
    //App settings
    return {};
  }
}
