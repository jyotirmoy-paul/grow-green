import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../game/game/grow_green_game.dart';
import '../../../game/game/services/datastore/game_datastore.dart';
import '../../../game/game/services/game_services/monetary/monetary_service.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameLoading()) {
    on<LoadGameEvent>(_onLoadGameEvent);
  }

  void _onLoadGameEvent(LoadGameEvent event, Emitter<GameState> emit) {
    final growGreenGame = GrowGreenGame(
      gameDatastore: event.gameDatastore,
      monetaryService: event.monetaryService,
    );

    emit(GameLoaded(game: growGreenGame));
  }
}
