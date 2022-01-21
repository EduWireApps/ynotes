part of settings_service;

class SettingsService {
  SettingsService._();

  static const String _settingsKey = "settings";

  static late Settings settings;

  static Future<void> update() async {
    Logger.log("SETTINGS SERVICE", "update");
    await KVS.write(key: _settingsKey, value: json.encode(settings.toJson()));
    settings.notify();
  }

  static Future<void> reset() async {
    Logger.log("SETTINGS SERVICE", "reset");
    settings = Settings.fromJson(_defaultSettings);
    await update();
    await updateTheme(settings.global.themeId);
  }

  static Future<void> init() async {
    Logger.log("SETTINGS SERVICE", "init");
    final String? savedSettings = await KVS.read(key: _settingsKey);
    final Map<String, dynamic> settingsMap =
        savedSettings != null ? _migrate(json.decode(savedSettings)) : _defaultSettings;
    settings = Settings.fromJson(settingsMap);
    await update();
  }

  static Map<String, dynamic> _migrate(Map<String, dynamic> map, {Map<String, dynamic>? defaultSettings}) {
    // If [defaultSettings] is not provided, use the default settings.
    defaultSettings ??= _defaultSettings;
    // We iterate through the entries of the default settings;
    for (final entry in defaultSettings.entries) {
      final String key = entry.key;
      final dynamic value = entry.value;
      // If the key is in the map, we have to do several checks.
      // If not, we just add the default value.
      if (map.containsKey(key)) {
        // If the value is a map, we migrate the map. (recursive)
        if (map[key] is Map && value is Map) {
          map[key] = _migrate(Map<String, dynamic>.from(map[key]), defaultSettings: value as Map<String, dynamic>);
          // If the type of the value has changed, we have to assign the default value to the value.
        } else if (map[key].runtimeType != value.runtimeType) {
          map[key] = value;
        }
      } else {
        map[key] = value;
      }
    }
    // If they are unused values, we delete them.
    final List<String> extraKeys = [];
    for (final key in map.keys) {
      if (!defaultSettings.containsKey(key)) {
        extraKeys.add(key);
      }
    }
    for (final key in extraKeys) {
      map.remove(key);
    }
    return map;
  }

  static Future<void> updateTheme(int id) async {
    settings.global.themeId = id;
    theme.updateCurrentTheme(settings.global.themeId);
    UIU.setSystemUIOverlayStyle();
    await update();
  }
}
