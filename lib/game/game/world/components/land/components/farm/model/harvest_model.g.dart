// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarvestModel _$HarvestModelFromJson(Map<String, dynamic> json) => HarvestModel(
      yield: (json['yield'] as num).toDouble(),
      money: MoneyModel.fromJson(json['money'] as Map<String, dynamic>),
      growable: $enumDecode(_$ComponentIdEnumMap, json['growable']),
    );

Map<String, dynamic> _$HarvestModelToJson(HarvestModel instance) =>
    <String, dynamic>{
      'yield': instance.yield,
      'money': instance.money,
      'growable': _$ComponentIdEnumMap[instance.growable]!,
    };

const _$ComponentIdEnumMap = {
  ComponentId.crop: 'crop',
  ComponentId.trees: 'trees',
  ComponentId.fertilizer: 'fertilizer',
  ComponentId.agroforestryLayout: 'agroforestryLayout',
  ComponentId.action: 'action',
  ComponentId.none: 'none',
};
