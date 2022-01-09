part of settings_service;

class SettingsService {
  SettingsService._();

  static const String _settingsKey = "settings";

  static late Settings settings;

  static Future<void> update() async {
    CustomLogger.log("SETTINGS SERVICE", "update");
    await KVS.write(key: _settingsKey, value: json.encode(settings.toJson()));
    settings.notify();
  }

  static Future<void> reset() async {
    CustomLogger.log("SETTINGS SERVICE", "reset");
    settings = Settings.fromJson(_defaultSettings);
    await update();
    await updateTheme(settings.global.themeId);
  }

  static Future<void> init() async {
    CustomLogger.log("SETTINGS SERVICE", "init");
    final String? savedSettings = await KVS.read(key: _settingsKey);
    final Map<String, dynamic> settingsMap = savedSettings != null ? json.decode(savedSettings) : _defaultSettings;
    settings = Settings.fromJson(settingsMap);
    await update();
  }

  static Future<void> updateTheme(int id) async {
    settings.global.themeId = id;
    theme.updateCurrentTheme(settings.global.themeId);
    UIUtils.setSystemUIOverlayStyle();
    await update();
  }
}
