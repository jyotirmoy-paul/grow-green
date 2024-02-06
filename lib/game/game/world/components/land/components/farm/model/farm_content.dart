import '../components/crop/enums/crop_type.dart';
import '../components/farmer/enums/farmer_category.dart';
import '../components/tree/enums/tree_type.dart';
import 'content.dart';
import 'fertilizer/fertilizer_type.dart';

/// A farm must contain crop & farmer, tree & fertilizer are optional
class FarmContent {
  final Content<CropType> crop;
  final Content<TreeType>? tree;
  final FarmerCategory farmer;
  final Content<FertilizerType>? fertilizer;

  FarmContent({
    required this.crop,
    this.tree,
    required this.farmer,
    this.fertilizer,
  });

  @override
  String toString() {
    return 'FarmContent(crop: $crop, $tree, ${farmer.name}, $fertilizer)';
  }
}
