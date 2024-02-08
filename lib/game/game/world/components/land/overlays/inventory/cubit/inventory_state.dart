part of 'inventory_cubit.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

final class InventoryNotInitialized extends InventoryState {
  const InventoryNotInitialized();
}

final class InventoryOptionSelected extends InventoryState {
  final InventoryOption selectedOption;
  final List<InventoryItem> inventoryItems;

  const InventoryOptionSelected({
    required this.selectedOption,
    required this.inventoryItems,
  });

  @override
  List<Object> get props => [
        selectedOption,
        inventoryItems,
      ];
}
