import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:growgreen/game/game/grow_green_game.dart';
import 'package:growgreen/game/game/world/components/land/overlays/system_selector_menu/system_selector_menu.dart';

import '../../../game/game/world/components/land/components/farm/farm.dart';

part 'game_overlay_state.dart';

class GameOverlayCubit extends Cubit<GameOverlayState> {
  final GrowGreenGame game;

  GameOverlayCubit({required this.game}) : super(const GameOverlayNone());

  void onShowSystemSelectorMenu(Farm farm) {
    emit(GameOverlaySystemSelector(farm: farm));

    game.overlays.add(SystemSelectorMenu.overlayName);
  }
}
