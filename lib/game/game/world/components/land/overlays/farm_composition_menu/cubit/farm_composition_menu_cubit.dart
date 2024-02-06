import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../grow_green_game.dart';
import '../../inventory/inventory.dart';

part 'farm_composition_menu_state.dart';

class FarmCompositionMenuCubit extends Cubit<FarmCompositionMenuState> {
  final GrowGreenGame game;

  FarmCompositionMenuCubit({
    required this.game,
  }) : super(FarmCompositionMenuDisplay());

  void onEditPressed() {
    /// TODO: check validations for edit, a farm cannot be edited at any time

    /// emit farm editing state
    emit(const FarmCompositionMenuEditing());

    /// show inventory overlay
    game.overlays.add(Inventory.overlayName);
  }

  void onDuringEditSavePressed() {
    /// TODO: Initialize a farm controller's sow whenever this is done!
  }

  void onDuringEditCancelPressed() {
    /// TODO: show progress would be lost if any changes were made

    /// emit farm display state
    emit(const FarmCompositionMenuDisplay());

    /// close inventory overlay
    game.overlays.remove(Inventory.overlayName);
  }
}
