// GENERATED CODE - DO NOT MODIFY BY HAND

part of settings_service;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalSettings _$GlobalSettingsFromJson(Map<String, dynamic> json) =>
    GlobalSettings(
      lastReadPatchNotes: json['lastReadPatchNotes'] as String,
      themeId: json['themeId'] as int,
      api: $enumDecode(_$ApisEnumMap, json['api']),
      batterySaver: json['batterySaver'] as bool,
      shakeToReport: json['shakeToReport'] as bool,
      uuid: json['uuid'] as String?,
      userFirstName: json['userFirstName'] as String?,
      userLastName: json['userLastName'] as String?,
    );

Map<String, dynamic> _$GlobalSettingsToJson(GlobalSettings instance) =>
    <String, dynamic>{
      'lastReadPatchNotes': instance.lastReadPatchNotes,
      'themeId': instance.themeId,
      'api': _$ApisEnumMap[instance.api],
      'batterySaver': instance.batterySaver,
      'shakeToReport': instance.shakeToReport,
      'uuid': instance.uuid,
      'userFirstName': instance.userFirstName,
      'userLastName': instance.userLastName,
    };

const _$ApisEnumMap = {
  Apis.ecoleDirecte: 'ecoleDirecte',
  Apis.pronote: 'pronote',
};

HomeworkPageSettings _$HomeworkPageSettingsFromJson(
        Map<String, dynamic> json) =>
    HomeworkPageSettings(
      forceMonochrome: json['forceMonochrome'] as bool,
      fontSize: json['fontSize'] as int,
      colorVariant: json['colorVariant'] as int,
    );

Map<String, dynamic> _$HomeworkPageSettingsToJson(
        HomeworkPageSettings instance) =>
    <String, dynamic>{
      'forceMonochrome': instance.forceMonochrome,
      'fontSize': instance.fontSize,
      'colorVariant': instance.colorVariant,
    };

NotificationsSettings _$NotificationsSettingsFromJson(
        Map<String, dynamic> json) =>
    NotificationsSettings(
      newEmail: json['newEmail'] as bool,
      newGrade: json['newGrade'] as bool,
    );

Map<String, dynamic> _$NotificationsSettingsToJson(
        NotificationsSettings instance) =>
    <String, dynamic>{
      'newEmail': instance.newEmail,
      'newGrade': instance.newGrade,
    };

PagesSettings _$PagesSettingsFromJson(Map<String, dynamic> json) =>
    PagesSettings(
      homework: HomeworkPageSettings.fromJson(
          json['homework'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PagesSettingsToJson(PagesSettings instance) =>
    <String, dynamic>{
      'homework': instance.homework,
    };

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      global: GlobalSettings.fromJson(json['global'] as Map<String, dynamic>),
      pages: PagesSettings.fromJson(json['pages'] as Map<String, dynamic>),
      notifications: NotificationsSettings.fromJson(
          json['notifications'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'global': instance.global,
      'pages': instance.pages,
      'notifications': instance.notifications,
    };
