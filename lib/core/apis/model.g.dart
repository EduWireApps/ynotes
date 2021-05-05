// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppAccount _$AppAccountFromJson(Map<String, dynamic> json) {
  return AppAccount(
    name: json['name'] as String?,
    surname: json['surname'] as String?,
    id: json['id'] as String?,
    managableAccounts: (json['managableAccounts'] as List<dynamic>?)
        ?.map((e) => SchoolAccount.fromJson(e as Map<String, dynamic>))
        .toList(),
    apiSettings: json['apiSettings'] as Map<String, dynamic>?,
    isParentMainAccount: json['isParentMainAccount'] as bool,
    apiType: _$enumDecode(_$API_TYPEEnumMap, json['apiType']),
  );
}

Map<String, dynamic> _$AppAccountToJson(AppAccount instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'id': instance.id,
      'apiSettings': instance.apiSettings,
      'isParentMainAccount': instance.isParentMainAccount,
      'apiType': _$API_TYPEEnumMap[instance.apiType],
      'managableAccounts': instance.managableAccounts,
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

const _$API_TYPEEnumMap = {
  API_TYPE.EcoleDirecte: 'EcoleDirecte',
  API_TYPE.Pronote: 'Pronote',
};

SchoolAccount _$SchoolAccountFromJson(Map<String, dynamic> json) {
  return SchoolAccount(
    name: json['name'] as String?,
    studentClass: json['studentClass'] as String?,
    studentID: json['studentID'] as String?,
    availableTabs: (json['availableTabs'] as List<dynamic>)
        .map((e) => _$enumDecode(_$appTabsEnumMap, e))
        .toList(),
    surname: json['surname'] as String?,
    schoolName: json['schoolName'] as String?,
  )..credentials = json['credentials'] as Map<String, dynamic>?;
}

Map<String, dynamic> _$SchoolAccountToJson(SchoolAccount instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'schoolName': instance.schoolName,
      'studentClass': instance.studentClass,
      'studentID': instance.studentID,
      'availableTabs':
          instance.availableTabs.map((e) => _$appTabsEnumMap[e]).toList(),
      'credentials': instance.credentials,
    };

const _$appTabsEnumMap = {
  appTabs.SUMMARY: 'SUMMARY',
  appTabs.GRADES: 'GRADES',
  appTabs.HOMEWORK: 'HOMEWORK',
  appTabs.AGENDA: 'AGENDA',
  appTabs.POLLS: 'POLLS',
  appTabs.MESSAGING: 'MESSAGING',
  appTabs.CLOUD: 'CLOUD',
  appTabs.FILES: 'FILES',
};
