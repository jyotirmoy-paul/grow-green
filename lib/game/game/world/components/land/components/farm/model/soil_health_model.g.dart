// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soil_health_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoilHealthModel _$SoilHealthModelFromJson(Map<String, dynamic> json) =>
    SoilHealthModel(
      recordedOnDate: DateTime.parse(json['recordedOnDate'] as String),
      currentSoilHealth: (json['currentSoilHealth'] as num).toDouble(),
      systemType:
          const SystemTypeConverter().fromJson(json['systemType'] as String),
      fertilizerType:
          $enumDecodeNullable(_$FertilizerTypeEnumMap, json['fertilizerType']),
      areTreesPresent: json['areTreesPresent'] as bool,
    );

Map<String, dynamic> _$SoilHealthModelToJson(SoilHealthModel instance) =>
    <String, dynamic>{
      'recordedOnDate': instance.recordedOnDate.toIso8601String(),
      'currentSoilHealth': instance.currentSoilHealth,
      'systemType': const SystemTypeConverter().toJson(instance.systemType),
      'fertilizerType': _$FertilizerTypeEnumMap[instance.fertilizerType],
      'areTreesPresent': instance.areTreesPresent,
    };

const _$FertilizerTypeEnumMap = {
  FertilizerType.organic: 'organic',
  FertilizerType.chemical: 'chemical',
};
