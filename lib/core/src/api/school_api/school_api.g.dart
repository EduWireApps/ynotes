// GENERATED CODE - DO NOT MODIFY BY HAND

part of school_api;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_S _$SFromJson(Map<String, dynamic> json) => _S(
      currentPeriodId: json['currentPeriodId'] as String?,
      currentFilterId: json['currentFilterId'] as String?,
      appAccountId: json['appAccountId'] as String?,
      schoolAccountId: json['schoolAccountId'] as String?,
    );

Map<String, dynamic> _$SToJson(_S instance) => <String, dynamic>{
      'currentPeriodId': instance.currentPeriodId,
      'currentFilterId': instance.currentFilterId,
      'appAccountId': instance.appAccountId,
      'schoolAccountId': instance.schoolAccountId,
    };
