// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmStateModel _$FarmStateModelFromJson(Map<String, dynamic> json) =>
    FarmStateModel(
      farmId: json['farmId'] as String,
      soilHealth: (json['soilHealth'] as num).toDouble(),
      farmState: $enumDecode(_$FarmStateEnumMap, json['farmState']),
      farmContent: json['farmContent'] == null
          ? null
          : FarmContent.fromJson(json['farmContent'] as Map<String, dynamic>),
      treeLastHarvestedInMonth:
          $enumDecodeNullable(_$MonthEnumMap, json['treeLastHarvestedInMonth']),
      treesLifeStartedAt: json['treesLifeStartedAt'] == null
          ? null
          : DateTime.parse(json['treesLifeStartedAt'] as String),
      cropsLifeStartedAt: json['cropsLifeStartedAt'] == null
          ? null
          : DateTime.parse(json['cropsLifeStartedAt'] as String),
      harvestModel: json['harvestModel'] == null
          ? null
          : HarvestModel.fromJson(json['harvestModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FarmStateModelToJson(FarmStateModel instance) =>
    <String, dynamic>{
      'farmId': instance.farmId,
      'soilHealth': instance.soilHealth,
      'farmState': _$FarmStateEnumMap[instance.farmState]!,
      'farmContent': instance.farmContent,
      'treeLastHarvestedInMonth':
          _$MonthEnumMap[instance.treeLastHarvestedInMonth],
      'treesLifeStartedAt': instance.treesLifeStartedAt?.toIso8601String(),
      'cropsLifeStartedAt': instance.cropsLifeStartedAt?.toIso8601String(),
      'harvestModel': instance.harvestModel,
    };

const _$FarmStateEnumMap = {
  FarmState.notBought: 'notBought',
  FarmState.onlyCropsWaiting: 'onlyCropsWaiting',
  FarmState.treesAndCropsButCropsWaiting: 'treesAndCropsButCropsWaiting',
  FarmState.functioning: 'functioning',
  FarmState.functioningOnlyTrees: 'functioningOnlyTrees',
  FarmState.functioningOnlyCrops: 'functioningOnlyCrops',
  FarmState.notFunctioning: 'notFunctioning',
  FarmState.barren: 'barren',
};

const _$MonthEnumMap = {
  Month.jan: 'jan',
  Month.feb: 'feb',
  Month.mar: 'mar',
  Month.apr: 'apr',
  Month.may: 'may',
  Month.jun: 'jun',
  Month.jul: 'jul',
  Month.aug: 'aug',
  Month.sep: 'sep',
  Month.oct: 'oct',
  Month.nov: 'nov',
  Month.dec: 'dec',
};
