import 'inventory_datastore.dart';

/// TODO: implement
class GameDatastore {
  final InventoryDatastore _inventoryDatastore = InventoryDatastore();

  GameDatastore();

  /// getters
  InventoryDatastore get inventoryDatastore => _inventoryDatastore;
}
