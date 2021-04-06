import 'dart:convert';

import 'package:ynotes/core/services/shared_preferences.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';

class SettingsUtils {
  static const Map secureSettingsForm = {"username": "", "password": "", "pronoteurl": "", "pronotecas": ""};
  static const Map settingsForm = {
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
          value = getIntSetting(key2) ?? value;
        }
        if (value.runtimeType == bool) {
          value = getBoolSetting(key2) ?? value;
        }
      });
    });
    (_settings["system"] as Map).forEach((key, value) {
      if (value.runtimeType == int) {
        value = getIntSetting(key) ?? value;
      }
      if (value.runtimeType == bool) {
        value = getBoolSetting(key) ?? value;
      }
    });
    print(_settings);
    return _settings;
    //The user's settings per page
  }

  static getSettings() async {
    Map _settings;
    Map _oldSettings;
    Map _newSettings;

    _oldSettings = getOldSettings();
    _newSettings = await getSavedSettings();

    //merge settings
    _settings = {
      ..._oldSettings,
      ..._newSettings,
    };
    return _settings;
  }

  static Future<Map> getSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String settings = prefs.getString("settings") ?? json.encode(settingsForm);
    Map _settings = json.decode(settings);
    return _settings;
  }

  static setSetting(List<String> setting, var value) async {
    final prefs = await SharedPreferences.getInstance();
    Map temp = await getSavedSettings();
    var m = temp ?? {};
    for (int i = 0; i < setting.length - 1; i++) {
      m = m[setting[i]] ?? {};
      print(m);
    }
    m[setting.last] = value;
    String encoded = json.encode(m);
    await prefs.setString("settings", encoded);
  }

  ///Deprecated
  static Future<bool> getBoolSetting(String setting) async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(setting);
    return value;
  }

  //Deprecated
  static Future<int> getIntSetting(String setting) async {
    final prefs = await SharedPreferences.getInstance();
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
  }
}
