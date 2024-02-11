import '../../enums/agroforestry_type.dart';
import '../../models/farm_system.dart';
import '../../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../../world/components/land/components/farm/components/tree/enums/tree_type.dart';
import '../../world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

/// Class holds various systems initially available to the user
class SystemDatastore {
  /// Alley agroforestry system
  final _agroforestrySystem1 = const AgroforestrySystem(
    agroforestryType: AgroforestryType.alley,
    tree: [TreeType.a],
    crop: CropType.a,
  );

  /// Block agroforestry system
  final _agroforestrySystem2 = const AgroforestrySystem(
    agroforestryType: AgroforestryType.block,
    tree: [TreeType.b],
    crop: CropType.b,
  );

  /// Boundary agroforestry system
  final _agroforestrySystem3 = const AgroforestrySystem(
    agroforestryType: AgroforestryType.boundary,
    tree: [TreeType.a, TreeType.b, TreeType.c],
    crop: CropType.c,
  );

  /// Organic fertilizer monoculture system
  final _monocultureSystem1 = const MonocultureSystem(
    fertilizerType: FertilizerType.organic,
    crop: CropType.a,
  );

  /// Chemical fertilizer monoculture sysetm
  final _monocultureSystem2 = const MonocultureSystem(
    fertilizerType: FertilizerType.chemical,
    crop: CropType.c,
  );

  List<FarmSystem> get systems => [
        _agroforestrySystem1,
        _agroforestrySystem2,
        _agroforestrySystem3,
        _monocultureSystem1,
        _monocultureSystem2,
      ];
}
