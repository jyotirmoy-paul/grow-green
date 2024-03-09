import 'package:json_annotation/json_annotation.dart';

import '../enum/farm_state.dart';
import 'farm_content.dart';

part 'farm_state_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class FarmStateModel {
  final String farmId;
  double soilHealthPercentage;
  FarmState farmState;
  FarmContent? farmContent;
  DateTime? treeLastHarvestedOn;
  DateTime? treesLifeStartedAt;
  DateTime? cropSowRequestedAt;
  DateTime? cropsLifeStartedAt;
  DateTime? treesLastMaintenanceRefillOn;

  FarmStateModel({
    required this.farmId,
    required this.soilHealthPercentage,
    required this.farmState,
    this.farmContent,
    this.treeLastHarvestedOn,
    this.treesLifeStartedAt,
    this.cropSowRequestedAt,
    this.cropsLifeStartedAt,
    this.treesLastMaintenanceRefillOn,
  });

  FarmStateModel copyWith({
    String? farmId,
    double? soilHealthPercentage,
    FarmState? farmState,
    FarmContent? farmContent,
    DateTime? treeLastHarvestedOn,
    DateTime? treesLifeStartedAt,
    DateTime? cropSowRequestedAt,
    DateTime? cropsLifeStartedAt,
    DateTime? treesLastMaintenanceRefillOn,
  }) {
    return FarmStateModel(
      farmId: farmId ?? this.farmId,
      soilHealthPercentage: soilHealthPercentage ?? this.soilHealthPercentage,
      farmState: farmState ?? this.farmState,
      farmContent: farmContent ?? this.farmContent,
      treeLastHarvestedOn: treeLastHarvestedOn ?? this.treeLastHarvestedOn,
      treesLifeStartedAt: treesLifeStartedAt ?? this.treesLifeStartedAt,
      cropsLifeStartedAt: cropsLifeStartedAt ?? this.cropsLifeStartedAt,
      cropSowRequestedAt: cropSowRequestedAt ?? this.cropSowRequestedAt,
      treesLastMaintenanceRefillOn: treesLastMaintenanceRefillOn ?? this.treesLastMaintenanceRefillOn,
    );
  }

  factory FarmStateModel.fromJson(Map<String, dynamic> json) => _$FarmStateModelFromJson(json);
  Map<String, dynamic> toJson() => _$FarmStateModelToJson(this);

  @override
  String toString() {
    return 'FarmStateModel(farmId: $farmId, soilHealthPercentage: $soilHealthPercentage, farmState: $farmState)';
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class SoilHealthValueUpdateModel {
  double soilHealthPercentage;

  SoilHealthValueUpdateModel({
    required this.soilHealthPercentage,
  });

  factory SoilHealthValueUpdateModel.fromJson(Map<String, dynamic> json) => _$SoilHealthValueUpdateModelFromJson(json);
  Map<String, dynamic> toJson() => _$SoilHealthValueUpdateModelToJson(this);
}
