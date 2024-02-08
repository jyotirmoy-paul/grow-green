import '../model/inventory/inventory_operation_model.dart';
import '../../world/components/land/components/farm/components/farmer/enums/farmer_category.dart';
import '../../world/components/land/components/farm/model/content.dart';

import '../../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../../world/components/land/components/farm/components/tree/enums/tree_type.dart';
import '../../world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

/// TODO: Implement
class InventoryDatastore {
  InventoryDatastore();

  void edit(InventoryOperationModel inventoryOperationModel) {
    /// TODO: implement
  }

  List<Content<CropType>> get seeds {
    /// TODO: Mock seeds
    return List.generate(4, (index) {
      return Content<CropType>(
        type: CropType.values[index],
        quantity: (3 + index * 4) * 100,
      );
    });
  }

  List<Content<FertilizerType>> get fertilizers {
    /// TODO: Mock fertilizers
    return List.generate(2, (index) {
      return Content<FertilizerType>(
        type: FertilizerType.organic,
        quantity: (1 + index * 2) * 150,
      );
    });
  }

  List<Content<TreeType>> get saplings {
    /// TODO: Mock saplings
    return List.generate(5, (index) {
      return Content<TreeType>(
        type: TreeType.values[index],
        quantity: (2 + index * 3) * 200,
      );
    });
  }

  List<Content<FarmerCategory>> get farmers {
    /// TODO: Mock farmers
    return List.generate(
      2,
      (index) => Content<FarmerCategory>(
        type: FarmerCategory.values[index],
        quantity: 3,
      ),
    );
  }
}
