import '../../enums/agroforestry_type.dart';
import '../../models/farm_system.dart';
import '../../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../../world/components/land/components/farm/components/tree/enums/tree_type.dart';
import '../../world/components/land/components/farm/model/content.dart';
import '../../world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

/// Class holds various systems initially available to the user
class SystemDatastore {
  /// Alley agroforestry system
  final _agroforestrySystem1 = AgroforestrySystem(
    agroforestryType: AgroforestryType.alley,
    trees: [
      Content<TreeType>(type: TreeType.a, quantity: 10),
      Content<TreeType>(type: TreeType.b, quantity: 20),
    ],
    crop: Content<CropType>(type: CropType.a, quantity: 100),
  );

  /// Block agroforestry system
  final _agroforestrySystem2 = AgroforestrySystem(
    agroforestryType: AgroforestryType.block,
    trees: [
      Content<TreeType>(type: TreeType.e, quantity: 15),
      Content<TreeType>(type: TreeType.c, quantity: 15),
    ],
    crop: Content<CropType>(type: CropType.b, quantity: 90),
  );

  /// Boundary agroforestry system
  final _agroforestrySystem3 = AgroforestrySystem(
    agroforestryType: AgroforestryType.boundary,
    trees: [
      Content<TreeType>(type: TreeType.a, quantity: 5),
      Content<TreeType>(type: TreeType.b, quantity: 20),
      Content<TreeType>(type: TreeType.c, quantity: 5),
    ],
    crop: Content<CropType>(type: CropType.d, quantity: 100),
  );

  /// Organic fertilizer monoculture system
  final _monocultureSystem1 = MonocultureSystem(
    fertilizer: Content<FertilizerType>(type: FertilizerType.organic, quantity: 100),
    crop: Content<CropType>(type: CropType.a, quantity: 90),
  );

  /// Chemical fertilizer monoculture sysetm
  final _monocultureSystem2 = MonocultureSystem(
    fertilizer: Content<FertilizerType>(type: FertilizerType.chemical, quantity: 80),
    crop: Content<CropType>(type: CropType.c, quantity: 100),
  );

  List<FarmSystem> get systems => [
        _agroforestrySystem1,
        _agroforestrySystem2,
        _agroforestrySystem3,
        _monocultureSystem1,
        _monocultureSystem2,
      ];
}
