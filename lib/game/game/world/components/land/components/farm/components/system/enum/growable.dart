import 'package:flutter/material.dart';

import '../../../../../../../../../../l10n/l10n.dart';
import '../../../../../../../../../../routes/routes.dart';
import '../../../asset/crop_asset.dart';
import '../../../asset/tree_asset.dart';
import '../../crop/enums/crop_type.dart';
import '../../tree/enums/tree_type.dart';
import '../real_life/calculators/crops/base_crop.dart';
import '../real_life/calculators/trees/base_tree.dart';

abstract class Growable implements Enum {
  GrowableType getGrowableType();
}

enum GrowableType {
  tree,
  crop;

  bool get isTree => this == tree;
}

extension GrowableExtension on Growable {
  static BuildContext get context => Navigation.navigationKey.currentContext!;

  String get growableName {
    switch (getGrowableType()) {
      case GrowableType.tree:
        return switch (this as TreeType) {
          TreeType.mahagony => context.l10n.mahagony,
          TreeType.neem => context.l10n.neem,
          TreeType.rosewood => context.l10n.rosewood,
          TreeType.teakwood => context.l10n.teakwood,
          TreeType.coconut => context.l10n.coconut,
          TreeType.jackfruit => context.l10n.jackfruit,
          TreeType.mango => context.l10n.mango,
        };

      case GrowableType.crop:
        return switch (this as CropType) {
          CropType.maize => context.l10n.maize,
          CropType.bajra => context.l10n.bajra,
          CropType.wheat => context.l10n.wheat,
          CropType.groundnut => context.l10n.groundnut,
          CropType.pepper => context.l10n.pepper,
          CropType.banana => context.l10n.banana,
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
