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
      harvestModels: (json['harvestModels'] as List<dynamic>?)
          ?.map((e) => HarvestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'harvestModels': instance.harvestModels?.map((e) => e.toJson()).toList(),
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
