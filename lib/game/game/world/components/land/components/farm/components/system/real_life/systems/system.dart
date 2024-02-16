import '../../../../../../../../../enums/system_type.dart';
import '../../../crop/enums/crop_type.dart';
import '../calculators/base_crop.dart';
import '../calculators/qty.dart';
import 'database/layouts.dart';

class System {
  final SystemType systemType;

  System({required this.systemType});

  PlantationLayout get plantationLayout => PlantationLayout.fromSytemType(systemType);

  Qty seedQty(CropType cropType) {
    final cropArea = plantationLayout.leftoverAreaForCrops;
    final cropQty = BaseCropCalculator.fromCropType(cropType).getSeedsRequiredPerHacter();
    final areaAdjustedValue = cropArea * cropQty.value ~/ 10000;
    return Qty(value: areaAdjustedValue, scale: cropQty.scale);
  }

  int get saplingQty {
    return plantationLayout.numberOfTrees;
  }
}
