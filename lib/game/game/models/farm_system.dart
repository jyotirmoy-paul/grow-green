import '../enums/agroforestry_type.dart';
import '../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../world/components/land/components/farm/components/tree/enums/tree_type.dart';
import '../world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

import '../enums/farm_system_type.dart';

abstract interface class FarmSystem {
  FarmSystemType get farmSystemType;
  double get estimatedSetupCost;
}

class MonocultureSystem implements FarmSystem {
  final FertilizerType fertilizerType;
  final CropType crop;

  const MonocultureSystem({
    required this.fertilizerType,
    required this.crop,
  });

  @override
  FarmSystemType get farmSystemType => FarmSystemType.monoculture;

  @override
  double get estimatedSetupCost {
    /// TODO: calculate estimated setup depending upon factors
    return 0.0;
  }

  MonocultureSystem copyWith({
    FertilizerType? fertilizerType,
    CropType? crop,
  }) {
    return MonocultureSystem(
      fertilizerType: fertilizerType ?? this.fertilizerType,
      crop: crop ?? this.crop,
    );
  }
}

class AgroforestrySystem implements FarmSystem {
  final AgroforestryType agroforestryType;
  final List<TreeType> tree;
  final CropType crop;

  const AgroforestrySystem({
    required this.agroforestryType,
    required this.tree,
    required this.crop,
  });

  @override
  FarmSystemType get farmSystemType => FarmSystemType.agroforestry;

  @override
  double get estimatedSetupCost {
    /// TODO: calculate estimated setup depending upon factors
    return 0.0;
  }

  AgroforestrySystem copyWith({
    AgroforestryType? agroforestryType,
    List<TreeType>? tree,
    CropType? crop,
  }) {
    return AgroforestrySystem(
      agroforestryType: agroforestryType ?? this.agroforestryType,
      tree: tree ?? this.tree,
      crop: crop ?? this.crop,
    );
  }
}
