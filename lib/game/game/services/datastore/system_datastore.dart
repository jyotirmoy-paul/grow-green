import '../../enums/agroforestry_type.dart';
import '../../enums/farm_system_type.dart';
import '../../models/farm_system.dart';
import '../../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../../world/components/land/components/farm/components/system/real_life/calculators/qty.dart';
import '../../world/components/land/components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../world/components/land/components/farm/components/tree/enums/tree_type.dart';
import '../../world/components/land/components/farm/model/content.dart';
import '../../world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

/// Class holds various systems initially available to the user
class SystemDatastore {
  /// Alley agroforestry system
  final _agroforestrySystem1 = AgroforestrySystem(
    agroforestryType: AgroforestryType.alley,
    trees: [
      Content<TreeType>(
        type: TreeType.cocounut,
        qty: QtyCalculator.getNumOfSaplingsFor(AgroforestryType.alley),
      ),
    ],
    crop: Content<CropType>(
      type: CropType.bajra,
      qty: QtyCalculator.getSeedQtyRequireFor(
        systemType: AgroforestryType.alley,
        cropType: CropType.bajra,
      ),
    ),
  );

  /// Block agroforestry system
  final _agroforestrySystem2 = AgroforestrySystem(
    agroforestryType: AgroforestryType.block,
    trees: [
      Content<TreeType>(
        type: TreeType.cocounut,
        qty: QtyCalculator.getNumOfSaplingsFor(AgroforestryType.block),
      ),
    ],
    crop: Content<CropType>(
      type: CropType.maize,
      qty: QtyCalculator.getSeedQtyRequireFor(
        systemType: AgroforestryType.block,
        cropType: CropType.maize,
      ),
    ),
  );

  /// Boundary agroforestry system
  final _agroforestrySystem3 = AgroforestrySystem(
    agroforestryType: AgroforestryType.boundary,
    trees: [
      Content<TreeType>(
        type: TreeType.mango,
        qty: QtyCalculator.getNumOfSaplingsFor(AgroforestryType.boundary),
      ),
    ],
    crop: Content<CropType>(
      type: CropType.pepper,
      qty: QtyCalculator.getSeedQtyRequireFor(
        systemType: AgroforestryType.boundary,
        cropType: CropType.pepper,
      ),
    ),
  );

  /// Organic fertilizer monoculture system
  final _monocultureSystem1 = MonocultureSystem(
    fertilizer: const Content<FertilizerType>(
      type: FertilizerType.organic,
      qty: Qty(
        value: 100,
        scale: Scale.kg,
      ),
    ),
    crop: Content<CropType>(
      type: CropType.wheat,
      qty: QtyCalculator.getSeedQtyRequireFor(
        systemType: FarmSystemType.monoculture,
        cropType: CropType.wheat,
      ),
    ),
  );

  /// Chemical fertilizer monoculture sysetm
  final _monocultureSystem2 = MonocultureSystem(
    fertilizer: const Content<FertilizerType>(
      type: FertilizerType.organic,
      qty: Qty(
        value: 190,
        scale: Scale.kg,
      ),
    ),
    crop: Content<CropType>(
      type: CropType.bajra,
      qty: QtyCalculator.getSeedQtyRequireFor(
        systemType: FarmSystemType.monoculture,
        cropType: CropType.bajra,
      ),
    ),
  );

  List<FarmSystem> get systems => [
        _agroforestrySystem1,
        _agroforestrySystem2,
        _agroforestrySystem3,
        _monocultureSystem1,
        _monocultureSystem2,
      ];
}
