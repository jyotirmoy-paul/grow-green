import '../../enums/agroforestry_type.dart';
import '../../models/farm_system.dart';
import '../../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../../world/components/land/components/farm/components/tree/enums/tree_type.dart';
import '../../world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

/// Class holds various systems initially available to the user
abstract class SystemDatastore {
  /// Alley agroforestry system
  static const _agroforestrySystem1 = AgroforestrySystem(
    agroforestryType: AgroforestryType.alley,
    trees: [
      TreeType.coconut,
    ],
    crop: CropType.bajra,
    fertilizer: FertilizerType.organic,
  );

  /// Block agroforestry system
  static const _agroforestrySystem2 = AgroforestrySystem(
    agroforestryType: AgroforestryType.block,
    trees: [
      TreeType.coconut,
    ],
    crop: CropType.maize,
    fertilizer: FertilizerType.organic,
  );

  /// Boundary agroforestry system
  static const _agroforestrySystem3 = AgroforestrySystem(
    agroforestryType: AgroforestryType.boundary,
    trees: [
      TreeType.mango,
    ],
    crop: CropType.pepper,
    fertilizer: FertilizerType.organic,
  );

  /// Organic fertilizer monoculture system
  static const _monocultureSystem1 = MonocultureSystem(
    fertilizer: FertilizerType.organic,
    crop: CropType.wheat,
  );

  /// Chemical fertilizer monoculture sysetm
  static const _monocultureSystem2 = MonocultureSystem(
    fertilizer: FertilizerType.organic,
    crop: CropType.bajra,
  );

  static const List<FarmSystem> systems = [
    _agroforestrySystem1,
    _monocultureSystem1,
    _agroforestrySystem2,
    _agroforestrySystem3,
    _monocultureSystem2,
  ];
}
