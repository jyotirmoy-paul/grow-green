// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckPointModel _$CheckPointModelFromJson(Map<String, dynamic> json) =>
    CheckPointModel(
      isClaimed: json['isClaimed'] as bool,
      isAchieved: json['isAchieved'] as bool,
      value: (json['value'] as num).toDouble(),
      achievementType:
          $enumDecode(_$AchievementTypeEnumMap, json['achievementType']),
      offer: MoneyOffer.fromJson(json['offer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckPointModelToJson(CheckPointModel instance) =>
    <String, dynamic>{
      'achievementType': _$AchievementTypeEnumMap[instance.achievementType]!,
      'isClaimed': instance.isClaimed,
      'isAchieved': instance.isAchieved,
      'value': instance.value,
      'offer': instance.offer.toJson(),
    };

const _$AchievementTypeEnumMap = {
  AchievementType.lands: 'lands',
  AchievementType.soilHealth: 'soilHealth',
};

AchievementsModel _$AchievementsModelFromJson(Map<String, dynamic> json) =>
    AchievementsModel(
      lands: (json['lands'] as List<dynamic>)
          .map((e) => CheckPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      soilHealth: (json['soilHealth'] as List<dynamic>)
          .map((e) => CheckPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AchievementsModelToJson(AchievementsModel instance) =>
    <String, dynamic>{
      'lands': instance.lands.map((e) => e.toJson()).toList(),
      'soilHealth': instance.soilHealth.map((e) => e.toJson()).toList(),
    };
