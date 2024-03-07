import '../../../../../../../../../enums/system_type.dart';
import '../systems/database/layouts.dart';

class MaintenanceCalculator {
  static const _oneHactare = 10000.0;

  static const _waterMaintenancePerHactarePerYear = 30000;
  static const _laborMaintenancePerHactarePerYear = 40000;
  static const _miscMaintenancePerHactarePerYear = 10000;
  static const _totalMaintenancePerHactarePerYear =
      _waterMaintenancePerHactarePerYear + _laborMaintenancePerHactarePerYear + _miscMaintenancePerHactarePerYear;

  // This returns area in sq meter for Maintenance
  static double getMaintenanceArea({
    required SystemType systemType,
    required MaintenanceFor maintenanceFor,
  }) {
    final cropArea = PlantationLayout.fromSytemType(systemType).leftoverAreaForCrops;

    switch (maintenanceFor) {
      case MaintenanceFor.crop:
        return cropArea;
      case MaintenanceFor.tree:
        return _oneHactare - cropArea;
      case MaintenanceFor.cropAndTree:
        return _oneHactare;
    }
  }

  static double getMaintenanceCostPerYear({
    required SystemType systemType,
    required MaintenanceFor maintenanceFor,
  }) {
    final maintenanceArea = getMaintenanceArea(systemType: systemType, maintenanceFor: maintenanceFor);
    final maintenanceCost = _totalMaintenancePerHactarePerYear * (maintenanceArea / _oneHactare);
    return maintenanceCost;
  }
}

enum MaintenanceFor { crop, tree, cropAndTree }
