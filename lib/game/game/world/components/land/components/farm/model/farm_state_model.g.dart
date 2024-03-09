// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmStateModel _$FarmStateModelFromJson(Map<String, dynamic> json) =>
    FarmStateModel(
      farmId: json['farmId'] as String,
      soilHealthPercentage: (json['soilHealthPercentage'] as num).toDouble(),
      farmState: $enumDecode(_$FarmStateEnumMap, json['farmState']),
      farmContent: json['farmContent'] == null
          ? null
          : FarmContent.fromJson(json['farmContent'] as Map<String, dynamic>),
      treeLastHarvestedOn: json['treeLastHarvestedOn'] == null
          ? null
          : DateTime.parse(json['treeLastHarvestedOn'] as String),
      treesLifeStartedAt: json['treesLifeStartedAt'] == null
          ? null
          : DateTime.parse(json['treesLifeStartedAt'] as String),
      cropSowRequestedAt: json['cropSowRequestedAt'] == null
          ? null
          : DateTime.parse(json['cropSowRequestedAt'] as String),
      cropsLifeStartedAt: json['cropsLifeStartedAt'] == null
          ? null
          : DateTime.parse(json['cropsLifeStartedAt'] as String),
      treesLastMaintenanceRefillOn: json['treesLastMaintenanceRefillOn'] == null
          ? null
          : DateTime.parse(json['treesLastMaintenanceRefillOn'] as String),
    );

Map<String, dynamic> _$FarmStateModelToJson(FarmStateModel instance) =>
    <String, dynamic>{
      'farmId': instance.farmId,
      'soilHealthPercentage': instance.soilHealthPercentage,
      'farmState': _$FarmStateEnumMap[instance.farmState]!,
      'farmContent': instance.farmContent?.toJson(),
      'treeLastHarvestedOn': instance.treeLastHarvestedOn?.toIso8601String(),
      'treesLifeStartedAt': instance.treesLifeStartedAt?.toIso8601String(),
      'cropSowRequestedAt': instance.cropSowRequestedAt?.toIso8601String(),
      'cropsLifeStartedAt': instance.cropsLifeStartedAt?.toIso8601String(),
      'treesLastMaintenanceRefillOn':
          instance.treesLastMaintenanceRefillOn?.toIso8601String(),
    };

const _$FarmStateEnumMap = {
  FarmState.notBought: 'notBought',
  FarmState.onlyCropsWaiting: 'onlyCropsWaiting',
  FarmState.treesAndCropsButCropsWaiting: 'treesAndCropsButCropsWaiting',
  FarmState.treesRemovedOnlyCropsWaiting: 'treesRemovedOnlyCropsWaiting',
  FarmState.functioning: 'functioning',
  FarmState.functioningOnlyTrees: 'functioningOnlyTrees',
  FarmState.functioningOnlyCrops: 'functioningOnlyCrops',
  FarmState.notFunctioning: 'notFunctioning',
  FarmState.barren: 'barren',
};

SoilHealthValueUpdateModel _$SoilHealthValueUpdateModelFromJson(
        Map<String, dynamic> json) =>
    SoilHealthValueUpdateModel(
      soilHealthPercentage: (json['soilHealthPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$SoilHealthValueUpdateModelToJson(
        SoilHealthValueUpdateModel instance) =>
    <String, dynamic>{
      'soilHealthPercentage': instance.soilHealthPercentage,
    };
