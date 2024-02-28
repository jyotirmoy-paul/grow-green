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
  final List<TreeType> trees;
  final CropType crop;

  const AgroforestrySystem({
    required this.agroforestryType,
    required this.trees,
    required this.crop,
  });

  @override
  FarmSystemType get farmSystemType => FarmSystemType.agroforestry;

  AgroforestrySystem copyWith({
    AgroforestryType? agroforestryType,
    List<TreeType>? trees,
    CropType? crop,
  }) {
    return AgroforestrySystem(
      agroforestryType: agroforestryType ?? this.agroforestryType,
      trees: trees ?? this.trees,
      crop: crop ?? this.crop,
    );
  }
}
