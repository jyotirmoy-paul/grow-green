import '../../../../../../enums/agroforestry_type.dart';
import '../../../../../../enums/system_type.dart';
import '../../../../../../models/farm_system.dart';

class LayoutInfo {
  final SystemType systemType;
  final String info;

  LayoutInfo({required this.systemType, required this.info});

  factory LayoutInfo.fromSystemType(FarmSystem system) {
    if (system is MonocultureSystem) {
      return LayoutInfo(
        systemType: system.farmSystemType,
        info: _monoCultureInfo,
      );
    } else {
      final agrosystem = (system as AgroforestrySystem).agroforestryType;
      return LayoutInfo(
        systemType: agrosystem,
        info: _buildAgroforestryInfo(agrosystem),
      );
    }
  }

  static const String _monoCultureInfo =
      "Monoculture refers to cultivation of only crops . You only get income from crops.";

  static String _buildAgroforestryInfo(AgroforestryType agrosystem) {
    return switch (agrosystem) {
      AgroforestryType.alley =>
        "Alley cropping involves planting parallel rows of crops between rows of trees . This improves soil health and trees generate extra revenue from trees.",
      AgroforestryType.boundary =>
        "Boundary planting involves growing trees or shrubs along the edges of agricultural fields . This improves soil health and trees generate extra revenue from trees.",
      AgroforestryType.block =>
        "Block planting involves planting trees in a block pattern within a field . This improves soil health and trees generate extra revenue from trees.",
    };
  }
}
