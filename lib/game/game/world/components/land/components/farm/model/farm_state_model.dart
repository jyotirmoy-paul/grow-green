import 'package:json_annotation/json_annotation.dart';

import '../../../../utils/month.dart';
import '../enum/farm_state.dart';
import 'farm_content.dart';
import 'harvest_model.dart';

part 'farm_state_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class FarmStateModel {
  final String farmId;
  double soilHealthPercentage;
  FarmState farmState;
  FarmContent? farmContent;
  Month? treeLastHarvestedInMonth;
  DateTime? treesLifeStartedAt;
  DateTime? cropsLifeStartedAt;
  HarvestModel? harvestModel;

  FarmStateModel({
    required this.farmId,
    required this.soilHealthPercentage,
    required this.farmState,
    this.farmContent,
    this.treeLastHarvestedInMonth,
    this.treesLifeStartedAt,
    this.cropsLifeStartedAt,
    this.harvestModel,
  });

  FarmStateModel copyWith({
    String? farmId,
    double? soilHealthPercentage,
    FarmState? farmState,
    FarmContent? farmContent,
    Month? treeLastHarvestedInMonth,
    DateTime? treesLifeStartedAt,
    DateTime? cropsLifeStartedAt,
    HarvestModel? harvestModel,
  }) {
    return FarmStateModel(
      farmId: farmId ?? this.farmId,
      soilHealthPercentage: soilHealthPercentage ?? this.soilHealthPercentage,
      farmState: farmState ?? this.farmState,
      farmContent: farmContent ?? this.farmContent,
      treeLastHarvestedInMonth: treeLastHarvestedInMonth ?? this.treeLastHarvestedInMonth,
      treesLifeStartedAt: treesLifeStartedAt ?? this.treesLifeStartedAt,
      cropsLifeStartedAt: cropsLifeStartedAt ?? this.cropsLifeStartedAt,
      harvestModel: harvestModel ?? this.harvestModel,
    );
  }

  factory FarmStateModel.fromJson(Map<String, dynamic> json) => _$FarmStateModelFromJson(json);
  Map<String, dynamic> toJson() => _$FarmStateModelToJson(this);
}
