import '../../../../../../enums/agroforestry_type.dart';

import '../components/crop/enums/crop_type.dart';
import '../components/tree/enums/tree_type.dart';
import 'content.dart';
import 'fertilizer/fertilizer_type.dart';

class FarmContent {
  final Content<CropType>? crop;
  final List<Content<TreeType>>? trees;
  final Content<FertilizerType>? fertilizer;
  final AgroforestryType? agroforestryType;

  FarmContent({
    this.crop,
    this.trees,
    this.fertilizer,
    this.agroforestryType,
  });

  bool get hasOnlyCrops => (crop != null && crop!.isNotEmpty) && (trees == null || trees!.isEmpty);

  bool get hasOnlyTrees => !hasOnlyCrops;

  bool get isEmpty =>
      (crop == null || crop!.isEmpty) &&
      (trees == null || trees!.isEmpty) &&
      (fertilizer == null || fertilizer!.isEmpty);

  @override
  String toString() {
    return 'FarmContent(crop: $crop, trees: $trees, agroforestryType: $agroforestryType, fertilizer: $fertilizer)';
  }
}
