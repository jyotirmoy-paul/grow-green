import '../../../../../../enums/system_type.dart';
import '../components/crop/enums/crop_type.dart';
import '../components/system/real_life/utils/cost_calculator.dart';
import '../components/tree/enums/tree_type.dart';
import 'content.dart';
import 'fertilizer/fertilizer_type.dart';

class FarmContent {
  final Content<CropType>? crop;
  final List<Content<TreeType>>? trees;
  final Content<FertilizerType>? fertilizer;
  final SystemType systemType;

  FarmContent({
    required this.systemType,
    this.crop,
    this.trees,
    this.fertilizer,
  });

  FarmContent removeCrop() {
    return FarmContent(
      crop: null,
      trees: trees,
      fertilizer: fertilizer,
      systemType: systemType,
    );
  }

  FarmContent copyWith({
    Content<CropType>? crop,
    List<Content<TreeType>>? trees,
    Content<FertilizerType>? fertilizer,
    SystemType? systemType,
  }) {
    return FarmContent(
      crop: crop ?? this.crop,
      trees: trees ?? this.trees,
      fertilizer: fertilizer ?? this.fertilizer,
      systemType: systemType ?? this.systemType,
    );
  }

  int get priceOfFarmContent {
    final priceOfCrop = crop != null ? CostCalculator.seedCost(cropType: crop!.type, systemType: systemType) : 0;

    final priceOfTrees = trees != null
        ? trees!.fold(0, (pv, tree) => pv + CostCalculator.saplingCost(systemType: systemType, treeType: tree.type))
        : 0;

    /// TODO: use cost calculator
    final priceOfFertilizer = fertilizer != null ? 10000 : 0;

    return priceOfCrop + priceOfTrees + priceOfFertilizer;
  }

  bool get hasOnlyCrops => (crop != null && crop!.isNotEmpty) && (trees == null || trees!.isEmpty);

  bool get hasOnlyTrees => !hasOnlyCrops;

  bool get isEmpty =>
      (crop == null || crop!.isEmpty) &&
      (trees == null || trees!.isEmpty) &&
      (fertilizer == null || fertilizer!.isEmpty);

  @override
  String toString() {
    return 'FarmContent(crop: $crop, trees: $trees, systemType: $systemType, fertilizer: $fertilizer)';
  }
}
