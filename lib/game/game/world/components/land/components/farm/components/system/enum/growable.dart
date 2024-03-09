import '../../../asset/crop_asset.dart';
import '../../../asset/tree_asset.dart';
import '../../crop/enums/crop_type.dart';
import '../../tree/enums/tree_type.dart';
import '../real_life/calculators/crops/base_crop.dart';
import '../real_life/calculators/trees/base_tree.dart';

/// TODO: Language
abstract class Growable implements Enum {
  GrowableType getGrowableType();
}

enum GrowableType {
  tree,
  crop;

  bool get isTree => this == tree;
}

extension GrowableExtension on Growable {
  String get growableName {
    switch (getGrowableType()) {
      case GrowableType.tree:
        return switch (this as TreeType) {
          TreeType.mahagony => 'Mahagony',
          TreeType.neem => 'Neem',
          TreeType.rosewood => 'Rosewood',
          TreeType.teakwood => 'Teakwood',
          TreeType.coconut => 'Coconut',
          TreeType.jackfruit => 'Jackfruit',
          TreeType.mango => 'Mango',
        };

      case GrowableType.crop:
        return switch (this as CropType) {
          CropType.maize => 'Maize',
          CropType.bajra => 'Bajra',
          CropType.wheat => 'Wheat',
          CropType.groundnut => 'Groundnut',
          CropType.pepper => 'Pepper',
          CropType.banana => 'Banana',
        };
    }
  }

  /// returns representative asset for particular growable type
  String get representativeAsset {
    switch (getGrowableType()) {
      case GrowableType.tree:
        return TreeAsset.representativeOf(this as TreeType);

      case GrowableType.crop:
        return CropAsset.representativeOf(this as CropType);
    }
  }

  String representativeAtAge(int ageInDays) {
    switch (getGrowableType()) {
      case GrowableType.tree:
        return TreeAsset.raw(this as TreeType)
            .at(BaseTreeCalculator.fromTreeType(this as TreeType).getTreeStage(ageInDays));

      case GrowableType.crop:
        return CropAsset.raw(this as CropType)
            .at(BaseCropCalculator.fromCropType(this as CropType).getCropStage(ageInDays));
    }
  }
}
