import 'package:json_annotation/json_annotation.dart';

import '../../../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../../../components/farm/components/system/real_life/utils/maintance_calculator.dart';
import '../../../../components/farm/model/content.dart';

part 'support_config.g.dart';

@JsonSerializable(explicitToJson: true)
class SupportConfig {
  MaintenanceQty maintenanceConfig;
  Content fertilizerConfig;

  SupportConfig({
    required this.maintenanceConfig,
    required this.fertilizerConfig,
  });

  int get cost {
    final fertilizerCost = CostCalculator.fertilizerCostFromContent(fertilizerContent: fertilizerConfig);
    final maintenanceCost = CostCalculator.maintenanceCost(maintenanceConfig);
    return fertilizerCost + maintenanceCost;
  }

  factory SupportConfig.fromJson(Map<String, dynamic> json) => _$SupportConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SupportConfigToJson(this);
}
