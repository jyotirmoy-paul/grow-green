import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../game/game/grow_green_game.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial(game: GrowGreenGame())) {
    on<GameEvent>((event, emit) {});
  }
}
