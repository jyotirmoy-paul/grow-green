import 'package:json_annotation/json_annotation.dart';

import 'offer.dart';

part 'achievements_model.g.dart';

enum AchievementType {
  lands,
  soilHealth,
}

@JsonSerializable(explicitToJson: true)
class CheckPointModel {
  final AchievementType achievementType;
  final bool isClaimed;
  final bool isAchieved;
  final double value;
  final MoneyOffer offer;

  CheckPointModel({
    required this.isClaimed,
    required this.isAchieved,
    required this.value,
    required this.achievementType,
    required this.offer,
  });

  CheckPointModel copyWith({
    bool? isClaimed,
    bool? isAchieved,
    double? value,
    AchievementType? achievementType,
    MoneyOffer? offer,
  }) {
    return CheckPointModel(
      isClaimed: isClaimed ?? this.isClaimed,
      isAchieved: isAchieved ?? this.isAchieved,
      value: value ?? this.value,
      achievementType: achievementType ?? this.achievementType,
      offer: offer ?? this.offer,
    );
  }

  factory CheckPointModel.fromJson(Map<String, dynamic> json) => _$CheckPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckPointModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckPointModel &&
        other.achievementType == achievementType &&
        other.isClaimed == isClaimed &&
        other.isAchieved == isAchieved &&
        other.value == value &&
        other.offer == offer;
  }

  @override
  int get hashCode {
    return achievementType.hashCode ^ isClaimed.hashCode ^ isAchieved.hashCode ^ value.hashCode ^ offer.hashCode;
  }
}

@JsonSerializable(explicitToJson: true)
class AchievementsModel {
  List<CheckPointModel> lands;
  List<CheckPointModel> soilHealth;

  AchievementsModel({
    required this.lands,
    required this.soilHealth,
  });

  List<CheckPointModel> checkpoints(AchievementType achievementType) {
    switch (achievementType) {
      case AchievementType.lands:
        return lands;
      case AchievementType.soilHealth:
        return soilHealth;
    }
  }

  int get numberOfUnclaimedAchievements {
    int result = 0;
    for (final achievementType in AchievementType.values) {
      result += checkpoints(achievementType).where((element) => !element.isClaimed && element.isAchieved).length;
    }
    return result;
  }

  AchievementsModel copyWith({
    List<CheckPointModel>? lands,
    List<CheckPointModel>? soilHealth,
  }) {
    return AchievementsModel(
      lands: lands ?? this.lands,
      soilHealth: soilHealth ?? this.soilHealth,
    );
  }

  void updateCheckpoints(AchievementType achievementType, List<CheckPointModel> checkpoints) {
    switch (achievementType) {
      case AchievementType.lands:
        lands = checkpoints;
        break;
      case AchievementType.soilHealth:
        soilHealth = checkpoints;
        break;
    }
  }

  static AchievementsModel get defaultAchievements => AchievementsModel(lands: [], soilHealth: []);

  factory AchievementsModel.fromJson(Map<String, dynamic> json) => _$AchievementsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementsModelToJson(this);
}
