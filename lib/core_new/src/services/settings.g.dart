// GENERATED CODE - DO NOT MODIFY BY HAND

part of settings_service;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings(
    global: GlobalSettings.fromJson(json['global'] as Map<String, dynamic>),
    pages: PagesSettings.fromJson(json['pages'] as Map<String, dynamic>),
    notifications: NotificationsSettings.fromJson(
        json['notifications'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'global': instance.global,
      'pages': instance.pages,
      'notifications': instance.notifications,
    };

GlobalSettings _$GlobalSettingsFromJson(Map<String, dynamic> json) {
  return GlobalSettings(
    lastReadPatchNotes: json['lastReadPatchNotes'] as String,
    themeId: json['themeId'] as int,
    api: _$enumDecode(_$ApisEnumMap, json['api']),
    batterySaver: json['batterySaver'] as bool,
    shakeToReport: json['shakeToReport'] as bool,
    uuid: json['uuid'] as String?,
  );
}

Map<String, dynamic> _$GlobalSettingsToJson(GlobalSettings instance) =>
    <String, dynamic>{
      'lastReadPatchNotes': instance.lastReadPatchNotes,
      'themeId': instance.themeId,
      'api': _$ApisEnumMap[instance.api],
      'batterySaver': instance.batterySaver,
      'shakeToReport': instance.shakeToReport,
      'uuid': instance.uuid,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ApisEnumMap = {
  Apis.ecoleDirecte: 'ecoleDirecte',
};

PagesSettings _$PagesSettingsFromJson(Map<String, dynamic> json) {
  return PagesSettings(
    homework:
        HomeworkPageSettings.fromJson(json['homework'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PagesSettingsToJson(PagesSettings instance) =>
    <String, dynamic>{
      'homework': instance.homework,
    };

HomeworkPageSettings _$HomeworkPageSettingsFromJson(Map<String, dynamic> json) {
  return HomeworkPageSettings(
    forceMonochrome: json['forceMonochrome'] as bool,
    fontSize: json['fontSize'] as int,
    colorVariant: json['colorVariant'] as int,
  );
}

Map<String, dynamic> _$HomeworkPageSettingsToJson(
        HomeworkPageSettings instance) =>
    <String, dynamic>{
      'forceMonochrome': instance.forceMonochrome,
      'fontSize': instance.fontSize,
      'colorVariant': instance.colorVariant,
    };

NotificationsSettings _$NotificationsSettingsFromJson(
    Map<String, dynamic> json) {
  return NotificationsSettings(
    newEmail: json['newEmail'] as bool,
    newGrade: json['newGrade'] as bool,
  );
}

Map<String, dynamic> _$NotificationsSettingsToJson(
        NotificationsSettings instance) =>
    <String, dynamic>{
      'newEmail': instance.newEmail,
      'newGrade': instance.newGrade,
    };
