import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/components/crop/enums/crop_type.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/components/farmer/enums/farmer_category.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/components/tree/enums/tree_type.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/model/content.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';
import '../../../../../../services/datastore/inventory_datastore.dart';
import '../../farm_composition_menu/cubit/farm_composition_menu_cubit.dart';
import '../enums/inventory_options.dart';
import '../model/inventory_item.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  static const tag = 'InventoryCubit';

  final InventoryDatastore inventoryDatastore;
  final FarmCompositionMenuCubit farmCompositionMenuCubit;

  final List<Content<CropType>> _seeds;
  final List<Content<TreeType>> _saplings;
  final List<Content<FertilizerType>> _fertilizers;
  final List<Content<FarmerCategory>> _farmers;

  InventoryCubit({
    required this.inventoryDatastore,
    required this.farmCompositionMenuCubit,
  })  : _seeds = inventoryDatastore.seeds,
        _saplings = inventoryDatastore.saplings,
        _fertilizers = inventoryDatastore.fertilizers,
        _farmers = inventoryDatastore.farmers,
        super(const InventoryNotInitialized());

  FarmCompositionMenuEditing get _farmCompositionMenuEditingState =>
      farmCompositionMenuCubit.state as FarmCompositionMenuEditing;

  List<InventoryItem> _invSeeds = [];
  List<InventoryItem> _invFertilizers = [];
  List<InventoryItem> _invSaplings = [];
  List<InventoryItem> _invFarmers = [];
  List<InventoryItem> _invCombos = [];

  List<InventoryItem> _getInventoryItemsFor(InventoryOption option) {
    switch (option) {
      case InventoryOption.seeds:
        return _invSeeds;

      case InventoryOption.fertilizers:
        return _invFertilizers;

      case InventoryOption.saplings:
        return _invSaplings;

      case InventoryOption.farmers:
        return _invFarmers;

      case InventoryOption.combos:
        return _invCombos;
    }
  }

  /// populates inventory bucket from available items
  void initialize() {
    // populate seeds
    for (final it in _seeds.indexed) {
      _invSeeds.add(
        InventoryItem(
          id: it.$1,
          name: it.$2.type.name,
          image: '',
          quantity: it.$2.quantity,
        ),
      );
    }

    // populate fertilizers
    for (final it in _fertilizers.indexed) {
      _invFertilizers.add(
        InventoryItem(
          id: it.$1,
          name: it.$2.type.name,
          image: '',
          quantity: it.$2.quantity,
        ),
      );
    }

    // populate saplings
    for (final it in _saplings.indexed) {
      _invSaplings.add(
        InventoryItem(
          id: it.$1,
          name: it.$2.type.name,
          image: '',
          quantity: it.$2.quantity,
        ),
      );
    }

    /// populate farmers
    for (final it in _farmers.indexed) {
      _invFarmers.add(
        InventoryItem(
          id: it.$1,
          name: it.$2.type.name,
          image: '',
          quantity: it.$2.quantity,
        ),
      );
    }

    // populate combos
    _createCombos();

    // emit initilize
    _emitInventoryOptionFor(InventoryOption.seeds);
  }

  void _createCombos() {
    // TODO: create combos
  }

  void _emitInventoryOptionFor(InventoryOption option) {
    emit(
      InventoryOptionSelected(
        selectedOption: option,
        inventoryItems: _getInventoryItemsFor(option),
      ),
    );
  }

  void onOptionSelect(InventoryOption option) => _emitInventoryOptionFor(option);

  void _onSeedItemTap(InventoryItem item) {
    final seed = _seeds[item.id];
    final invSeedItem = _invSeeds[item.id];

    // find out seed requirement
    late int seedRequirement;
    if (_farmCompositionMenuEditingState.isAgroforestrySystem) {
      seedRequirement = _farmCompositionMenuEditingState.requirement.agroSeedsQuantity;
    } else {
      seedRequirement = _farmCompositionMenuEditingState.requirement.monoSeedsQuantity;
    }

    final menuCrop = _farmCompositionMenuEditingState.crops;

    final isDifferentCrop = menuCrop.type != seed.type;
    final isSeedRequirementAlreadyMet = menuCrop.quantity == seedRequirement;
    final isSeedSufficientlyAvailable = seedRequirement >= (invSeedItem.quantity ?? 0);

    // validate sufficient seed availability & farm composition is already not satifised
    if ((isSeedRequirementAlreadyMet || isSeedSufficientlyAvailable) && !isDifferentCrop) {
      // TODO: let user know insufficient seeds
      return;
    }

    if (isDifferentCrop) {
      /// refund the last crop
      
    }

    // update state in inventory
    final existingQuantity = _invSeeds[item.id].quantity ?? 0;
    _invSeeds = List.from(_invSeeds);
    _invSeeds[item.id] = _invSeeds[item.id].copyWith(
      quantity: existingQuantity - seedRequirement,
    );
    _emitInventoryOptionFor(InventoryOption.seeds);

    // update state in farm composition menu
    farmCompositionMenuCubit.emit(
      _farmCompositionMenuEditingState.copyWith(
        crops: Content(
          type: seed.type,
          quantity: seedRequirement,
        ),
      ),
    );
  }

  void onInventoryItemTap(InventoryItem item) {
    switch ((state as InventoryOptionSelected).selectedOption) {
      case InventoryOption.seeds:
        return _onSeedItemTap(item);

      case InventoryOption.fertilizers:
        return _onSeedItemTap(item);

      case InventoryOption.saplings:
        return _onSeedItemTap(item);

      case InventoryOption.farmers:
        return _onSeedItemTap(item);

      case InventoryOption.combos:
        return _onSeedItemTap(item);
    }
  }

  // void onItemRemoved() {}

  // // void _processSeedsChange() {}

  // void onInventoryItemTap(InventoryItem item) {
  //   // final invOption = state.selectedOption;

  //   // switch (invOption) {
  //   //   case InventoryOption.seeds:
  //   //     return _something();

  //   //   case InventoryOption.fertilizers:
  //   //     return _something();

  //   //   case InventoryOption.saplings:
  //   //     return _something();

  //   //   case InventoryOption.farmers:
  //   //     return _something();

  //   //   case InventoryOption.combos:
  //   //     return _something();
  //   // }
  // }
}
