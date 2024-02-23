import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../game/game/services/datastore/game_datastore.dart';
import '../../../game/game/services/game_services/monetary/monetary_service.dart';
import '../../../game/game/services/game_services/time/time_service.dart';
import '../../../services/auth/auth.dart';
import '../../game_screen/bloc/game_bloc.dart';

part 'landing_screen_state.dart';

class LandingScreenCubit extends Cubit<LandingScreenState> {
  static const tag = 'LandingScreenCubit';

  final GameBloc gameBloc;
  final AuthBloc authBloc;

  LandingScreenCubit({
    required this.gameBloc,
    required this.authBloc,
  }) : super(const LandingScreenInitial());

  /// method responsible for initializing all sservices needed by the game
  Future<void> _initializeServices() async {
    if (authBloc.state is! AuthLoggedIn) {
      throw Exception('$tag: _initializeServices() invoked has no logged in user. How did we get so far?');
    }
    final authLoggedInState = authBloc.state as AuthLoggedIn;

    /// initialize gameDatastore
    final gameDatastore = GameDatastore();
    await gameDatastore.initialize(authLoggedInState.user);

    /// initialize monetary service
    final monetaryService = MonetaryService(gameDatastore: gameDatastore);
    await monetaryService.initialize();

    /// initialize time service
    await TimeService().initialize(gameDatastore: gameDatastore);

    gameBloc.add(
      LoadGameEvent(
        monetaryService: monetaryService,
        gameDatastore: gameDatastore,
      ),
    );
  }

  Future<void> _prepareGame() async {
    /// initialize services needed for game to function
    await _initializeServices();
  }

  Future<void> onStartGame() async {
    emit(const LandingScreenPreparingGame());

    await _prepareGame();

    emit(const LandingScreenGameReady());
  }
}
