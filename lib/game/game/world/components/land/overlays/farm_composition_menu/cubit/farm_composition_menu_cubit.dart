import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:growgreen/services/log/log.dart';

import '../../../../../../grow_green_game.dart';
import '../../../components/farm/components/crop/enums/crop_type.dart';
import '../../../components/farm/components/farmer/enums/farmer_category.dart';
import '../../../components/farm/components/tree/enums/tree_type.dart';
import '../../../components/farm/farm.dart';
import '../../../components/farm/model/content.dart';
import '../../../components/farm/model/farm_content.dart';
import '../../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../../inventory/inventory.dart';

part 'farm_composition_menu_state.dart';

class FarmCompositionMenuCubit extends Cubit<FarmCompositionMenuState> {
  static const tag = 'FarmCompositionMenuCubit';

  final GrowGreenGame game;
  FarmContent? _farmContent;

  FarmCompositionMenuCubit({
    required this.game,
  }) : super(const FarmCompositionMenuEmpty());

  /// populate existing farm content
  void populate(FarmContent? farmContent) {
    _farmContent = farmContent;

    if (farmContent != null) {
      final displayState = FarmCompositionMenuDisplay(
        crops: farmContent.crop,
        trees: farmContent.tree ?? Content<TreeType>(type: TreeType.none, quantity: 0),
        fertilizers: farmContent.fertilizer ?? Content<FertilizerType>(type: FertilizerType.none, quantity: 0),
        farmer: farmContent.farmer,
      );

      emit(displayState);
    } else {
      emit(const FarmCompositionMenuEmpty());
    }
  }

  void onEditPressed(Farm farm) {
    if (!farm.farmController.isEditingAllowed) {
      throw Exception('$tag: $farm is not in editing state');
    }

    emit(
      FarmCompositionMenuEditing(
        /// TODO: determine the needs of the farm
        requirement: const CompositionRequirement(
          monoSeedsQuantity: 150,
          agroSeedsQuantity: 100,
          saplingsQuantity: 30,
          fertilizerQuantity: 100,
          farmerQuantity: 1,
        ),
        crops: Content.empty(CropType.none),
        trees: Content.empty(TreeType.none),
        fertilizers: Content.empty(FertilizerType.none),
        farmer: FarmerCategory.none,
      ),
    );

    /// show inventory overlay
    game.overlays.add(Inventory.overlayName);
  }

  /// We can get all data from `FarmCompositionMenuEditing` state
  void onDuringEditSavePressed() {
    if (state is! FarmCompositionMenuEditing) {
      throw Exception('$tag: onDuringEditSavePressed invoked in wrong state: $state. How is this possible?');
    }

    final saveState = state as FarmCompositionMenuEditing;

    /// TODO: Initialize a farm controller's sow whenever this is done!
  }

  void onDuringEditCancelPressed() {
    if (state is! FarmCompositionMenuEditing) {
      throw Exception('$tag: onDuringEditSavePressed invoked in wrong state: $state. How is this possible?');
    }

    final saveState = state as FarmCompositionMenuEditing;
    if (saveState.isEdited) {
      Log.d('$tag: onDuringEditCancelPressed unsaved changes detected!');

      /// TODO: Show a dialog box asking user to confirm action
      return;
    }

    // emit farm display state
    populate(_farmContent);

    // close inventory overlay
    game.overlays.remove(Inventory.overlayName);
  }
}
