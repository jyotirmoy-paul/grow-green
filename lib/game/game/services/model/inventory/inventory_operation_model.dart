import 'package:growgreen/game/game/world/components/land/components/farm/components/crop/enums/crop_type.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/components/farmer/enums/farmer_category.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/components/tree/enums/tree_type.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

enum InventoryOperationType {
  addtion,
  removal,
}

class InventoryOperationModel {
  final InventoryOperationType operationType;

  final CropType? cropType;
  final int? cropQuantity;

  final TreeType? treeType;
  final int? treeQuantity;

  final FertilizerType? fertilizerType;
  final int? fertilizerQuantity;

  final FarmerCategory? farmerCategory;
  final int? farmerQuantity;

  InventoryOperationModel({
    required this.operationType,
    this.cropType,
    this.cropQuantity,
    this.treeType,
    this.treeQuantity,
    this.fertilizerType,
    this.fertilizerQuantity,
    this.farmerCategory,
    this.farmerQuantity,
  });
}
