// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarvestModel _$HarvestModelFromJson(Map<String, dynamic> json) => HarvestModel(
      harvestType: $enumDecode(_$HarvestTypeEnumMap, json['harvestType']),
      yield: (json['yield'] as num).toDouble(),
      money: MoneyModel.fromJson(json['money'] as Map<String, dynamic>),
      growable: const GrowableConverter().fromJson(json['growable'] as String),
      dateOfHarvest: DateTime.parse(json['dateOfHarvest'] as String),
      ageAtHarvest: json['ageAtHarvest'] as int,
    );

Map<String, dynamic> _$HarvestModelToJson(HarvestModel instance) =>
    <String, dynamic>{
      'harvestType': _$HarvestTypeEnumMap[instance.harvestType]!,
      'growable': const GrowableConverter().toJson(instance.growable),
      'dateOfHarvest': instance.dateOfHarvest.toIso8601String(),
      'ageAtHarvest': instance.ageAtHarvest,
      'yield': instance.yield,
      'money': instance.money.toJson(),
    };

const _$HarvestTypeEnumMap = {
  HarvestType.recurring: 'recurring',
  HarvestType.oneTime: 'oneTime',
};
