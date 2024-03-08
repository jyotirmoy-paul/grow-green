// This is assuming one hactar area

import '../../../../../../../../../../enums/agroforestry_type.dart';
import '../../../../../../../../../../enums/farm_system_type.dart';
import '../../../../../../../../../../enums/system_type.dart';

class PlantationLayout {
  final int numberOfTrees;
  final double leftoverAreaForCrops; // in square meters

  const PlantationLayout._({
    required this.numberOfTrees,
    required this.leftoverAreaForCrops,
  });

  static const boundary = PlantationLayout._(
    numberOfTrees: 158,
    leftoverAreaForCrops: 8760.6,
  );

  static const alleyCropping = PlantationLayout._(
    numberOfTrees: 348,
    leftoverAreaForCrops: 7270.18,
  );

  static const blockPlantation = PlantationLayout._(
    numberOfTrees: 594,
    leftoverAreaForCrops: 4473,
  );
  static const monoPlantation = PlantationLayout._(
    numberOfTrees: 0,
    leftoverAreaForCrops: 10000,
  );

  factory PlantationLayout.fromSytemType(SystemType type) {
    switch (type) {
      case AgroforestryType.boundary:
        return boundary;

      case AgroforestryType.alley:
        return alleyCropping;

      case AgroforestryType.block:
        return blockPlantation;

      case FarmSystemType.monoculture:
        return monoPlantation;
    }

    throw Exception('Please specify agroforestry type using AgroforestryType enum!');
  }

  double get areaFractionForCrops {
    return leftoverAreaForCrops / 10000;
  }
}
