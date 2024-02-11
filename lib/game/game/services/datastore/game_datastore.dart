import 'inventory_datastore.dart';
import 'system_datastore.dart';

/// TODO: implement
class GameDatastore {
  final InventoryDatastore _inventoryDatastore = InventoryDatastore();
  final SystemDatastore _systemDatastore = SystemDatastore();

  GameDatastore();

  /// getters
  InventoryDatastore get inventoryDatastore => _inventoryDatastore;

  SystemDatastore get systemDatastore => _systemDatastore;
}
