// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenges_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengesModel _$ChallengesModelFromJson(Map<String, dynamic> json) =>
    ChallengesModel(
      challenges: (json['challenges'] as List<dynamic>)
          .map((e) => ChallengeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChallengesModelToJson(ChallengesModel instance) =>
    <String, dynamic>{
      'challenges': instance.challenges.map((e) => e.toJson()).toList(),
    };

ChallengeModel _$ChallengeModelFromJson(Map<String, dynamic> json) =>
    ChallengeModel(
      avgSoilHealth: (json['avgSoilHealth'] as num).toDouble(),
      bankBalance: json['bankBalance'] as int,
      landsBought: json['landsBought'] as int,
      timePassedInYears: json['timePassedInYears'] as int,
      isAchieved: json['isAchieved'] as bool,
      isClaimed: json['isClaimed'] as bool,
      offer: GwalletOffer.fromJson(json['offer'] as Map<String, dynamic>),
      label: json['label'] as String,
    );

Map<String, dynamic> _$ChallengeModelToJson(ChallengeModel instance) =>
    <String, dynamic>{
      'avgSoilHealth': instance.avgSoilHealth,
      'bankBalance': instance.bankBalance,
      'landsBought': instance.landsBought,
      'timePassedInYears': instance.timePassedInYears,
      'isAchieved': instance.isAchieved,
      'isClaimed': instance.isClaimed,
      'offer': instance.offer.toJson(),
      'label': instance.label,
    };
