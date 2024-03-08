import '../enums/agroforestry_type.dart';
import '../enums/farm_system_type.dart';
import '../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../world/components/land/components/farm/components/tree/enums/tree_type.dart';
import '../world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

abstract interface class FarmSystem {
  FarmSystemType get farmSystemType;
}

class MonocultureSystem implements FarmSystem {
  final FertilizerType fertilizer;
  final CropType crop;

  const MonocultureSystem({
    required this.fertilizer,
    required this.crop,
  });

  @override
  FarmSystemType get farmSystemType => FarmSystemType.monoculture;

  MonocultureSystem copyWith({
    FertilizerType? fertilizer,
    CropType? crop,
  }) {
    return MonocultureSystem(
      fertilizer: fertilizer ?? this.fertilizer,
      crop: crop ?? this.crop,
    );
  }
}

class AgroforestrySystem implements FarmSystem {
  final AgroforestryType agroforestryType;
  final TreeType tree;
  final CropType crop;
  final FertilizerType fertilizer;

  const AgroforestrySystem({
    required this.agroforestryType,
    required this.tree,
    required this.crop,
    required this.fertilizer,
  });

  @override
  FarmSystemType get farmSystemType => FarmSystemType.agroforestry;

  AgroforestrySystem copyWith({
    AgroforestryType? agroforestryType,
    TreeType? tree,
    CropType? crop,
    FertilizerType? fertilizer,
  }) {
    return AgroforestrySystem(
      agroforestryType: agroforestryType ?? this.agroforestryType,
      tree: tree ?? this.tree,
      crop: crop ?? this.crop,
      fertilizer: fertilizer ?? this.fertilizer,
    );
  }
}
