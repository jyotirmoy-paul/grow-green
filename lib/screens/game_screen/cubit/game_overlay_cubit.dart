import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../game/game/world/components/land/components/farm/farm.dart';

part 'game_overlay_state.dart';

class GameOverlayCubit extends Cubit<GameOverlayState> {
  GameOverlayCubit() : super(GameOverlayNone());

  void onFarmCompositionShow(Farm farm) {
    emit(GameOverlayFarmComposition(farm: farm));
  }
}
