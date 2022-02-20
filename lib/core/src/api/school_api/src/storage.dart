part of school_api;

@JsonSerializable()
class _S {
  String? currentPeriodId;
  String? currentFilterId;
  String? appAccountId;
  String? schoolAccountId;

  _S({
    required this.currentPeriodId,
    required this.currentFilterId,
    required this.appAccountId,
    required this.schoolAccountId,
  });

  factory _S.fromJson(Map<String, dynamic> json) => _$SFromJson(json);

  Map<String, dynamic> toJson() => _$SToJson(this);
}

class _Storage {
  static late _S values;

  static const String _storageKey = "school_api_storage";
  static const String _loggerKey = "SCHOOL API STORAGE";

  const _Storage._();

  static Future<void> update() async {
    Logger.log(_loggerKey, "update");
    await KVS.write(key: _storageKey, value: json.encode(values.toJson()));
  }

  static Future<void> reset() async {
    Logger.log(_loggerKey, "reset");
    values = _S.fromJson(_defaultStorage);
    await update();
  }

  static Future<void> init() async {
    Logger.log(_loggerKey, "init");
    final String? saved = await KVS.read(key: _storageKey);
    final Map<String, dynamic> storageMap = saved != null ? _migrate(json.decode(saved)) : _defaultStorage;
    values = _S.fromJson(storageMap);
    await update();
  }

  static Map<String, dynamic> _migrate(Map<String, dynamic> map, {Map<String, dynamic>? defaultStorage}) {
    // If [defaultSettings] is not provided, use the default settings.
    defaultStorage ??= _defaultStorage;
    // We iterate through the entries of the default settings;
    for (final entry in defaultStorage.entries) {
      final String key = entry.key;
      final dynamic value = entry.value;
      // If the key is in the map, we have to do several checks.
      // If not, we just add the default value.
      if (map.containsKey(key)) {
        // If the value is a map, we migrate the map. (recursive)
        if (map[key] is Map && value is Map) {
          map[key] = _migrate(Map<String, dynamic>.from(map[key]), defaultStorage: value as Map<String, dynamic>);
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
      if (!defaultStorage.containsKey(key)) {
        extraKeys.add(key);
      }
    }
    for (final key in extraKeys) {
      map.remove(key);
    }
    return map;
  }
}

final Map<String, dynamic> _defaultStorage = {
  "currentPeriodId": null,
  "currentFilterId": null,
  "appAccountId": null,
  "schoolAccountId": null,
};
