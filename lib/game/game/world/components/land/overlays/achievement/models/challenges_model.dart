import 'package:json_annotation/json_annotation.dart';

import 'offer.dart';

part 'challenges_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengesModel {
  final List<ChallengeModel> challenges;

  const ChallengesModel({
    required this.challenges,
  });

  static const defaultChallenges = ChallengesModel(challenges: []);

  ChallengesModel copyWith({
    List<ChallengeModel>? challenges,
  }) {
    return ChallengesModel(
      challenges: challenges ?? this.challenges,
    );
  }

  int get numberOfUnclaimedChallenges => challenges.where((c) => c.isAchieved && !c.isClaimed).length;
  factory ChallengesModel.fromJson(Map<String, dynamic> json) => _$ChallengesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengesModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChallengeModel {
  final double avgSoilHealth;
  final int bankBalance;
  final int landsBought;
  final int timePassedInYears;
  final bool isAchieved;
  final bool isClaimed;
  final GwalletOffer offer;
  final String label;

  const ChallengeModel({
    required this.avgSoilHealth,
    required this.bankBalance,
    required this.landsBought,
    required this.timePassedInYears,
    required this.isAchieved,
    required this.isClaimed,
    required this.offer,
    required this.label,
  });

  ChallengeModel copyWith({
    double? avgSoilHealth,
    int? bankBalance,
    int? landsBought,
    int? timePassedInYears,
    bool? isAchieved,
    bool? isClaimed,
    GwalletOffer? offer,
    String? label,
  }) {
    return ChallengeModel(
      avgSoilHealth: avgSoilHealth ?? this.avgSoilHealth,
      bankBalance: bankBalance ?? this.bankBalance,
      landsBought: landsBought ?? this.landsBought,
      timePassedInYears: timePassedInYears ?? this.timePassedInYears,
      isAchieved: isAchieved ?? this.isAchieved,
      isClaimed: isClaimed ?? this.isClaimed,
      offer: offer ?? this.offer,
      label: label ?? this.label,
    );
  }

  factory ChallengeModel.fromJson(Map<String, dynamic> json) => _$ChallengeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);
}
