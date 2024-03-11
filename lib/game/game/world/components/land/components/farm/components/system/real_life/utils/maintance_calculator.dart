import 'package:json_annotation/json_annotation.dart';

import '../../../../../../../../../enums/system_type.dart';
import '../../enum/growable.dart';
import '../../model/qty.dart';
import '../systems/database/layouts.dart';
import 'soil_health_calculator.dart';

part 'maintance_calculator.g.dart';

class MaintenanceCalculator {
  static const _oneHactare = 10000.0;
  static const _waterMaintenceQtyPerHactarePerYear = Qty(value: 300, scale: Scale.units);
  static const _waterPricePerUnit = 100;

  static const _laborMaintenceQtyPerHactarePerYear = Qty(value: 4, scale: Scale.units);
  static const _laborPricePerUnit = 10000;
  static const _miscMaintenceQtyPerHactarePerYear = Qty(value: 100, scale: Scale.units);
  static const _miscPricePerUnit = 100;

  // This returns area in sq meter for Maintenance
  static double getMaintenanceArea({
    required SystemType systemType,
    required GrowableType growableType,
  }) {
    final cropArea = PlantationLayout.fromSytemType(systemType).leftoverAreaForCrops;

    switch (growableType) {
      case GrowableType.crop:
        return cropArea;
      case GrowableType.tree:
        return _oneHactare - cropArea;
    }
  }

  static MaintenanceQty getMaintenanceQtyPerYear({
    required SystemType systemType,
    required GrowableType growableType,
    required double soilHealthPercentage,
  }) {
    final maintenanceArea = getMaintenanceArea(systemType: systemType, growableType: growableType);

    final areaRatio = maintenanceArea / _oneHactare;
    final soilHealthRatio = SoilHealthCalculator.calculateSoilHealthFactor(soilHealthPercentage);

    final qty = MaintenanceQty(
      waterQty: _waterMaintenceQtyPerHactarePerYear,
      laborQty: _laborMaintenceQtyPerHactarePerYear,
      miscQty: _miscMaintenceQtyPerHactarePerYear,
    );
    return qty * areaRatio * soilHealthRatio;
  }

  static int getMaintenanceCostFromQty({required MaintenanceQty maintenanceQty}) {
    final waterCost = maintenanceQty.waterQty.value * _waterPricePerUnit;
    final laborCost = maintenanceQty.laborQty.value * _laborPricePerUnit;
    final miscCost = maintenanceQty.miscQty.value * _miscPricePerUnit;

    return waterCost + laborCost + miscCost;
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class MaintenanceQty {
  final Qty waterQty;
  final Qty laborQty;
  final Qty miscQty;

  MaintenanceQty({
    required this.waterQty,
    required this.laborQty,
    required this.miscQty,
  });

  // define * operator with double
  MaintenanceQty operator *(double factor) {
    return MaintenanceQty(
      waterQty: (waterQty * factor).round(),
      laborQty: (laborQty * factor).round(),
      miscQty: (miscQty * factor).round(),
    );
  }

  factory MaintenanceQty.fromJson(Map<String, dynamic> json) => _$MaintenanceQtyFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceQtyToJson(this);
}
