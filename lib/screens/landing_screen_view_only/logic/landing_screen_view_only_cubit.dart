import 'package:bloc/bloc.dart';

import '../../../game/game/services/datastore/game_datastore.dart';
import '../../../game/game/services/game_services/monetary/monetary_service.dart';
import '../../../game/game/services/game_services/time/time_service.dart';
import '../../../models/auth/user.dart';
import '../../../services/database/database_service_factory.dart';
import '../../game_screen/bloc/game_bloc.dart';
import 'landing_screen_view_only_state.dart';

class LandingScreenViewOnlyCubit extends Cubit<LandingScreenViewOnlyState> {
  static const tag = 'LandingScreenViewOnlyCubit';

  final GameBloc gameBloc;
  final String? id;
  LandingScreenViewOnlyCubit({
    required this.gameBloc,
    this.id,
  }) : super(const LandingScreenViewOnlyInitial());

  Future<void> _initializeServices() async {
    if (id == null) {
      throw Exception('No user id found in the uri');
    }

    /// initialize gameDatastore
    final gameDatastore = GameDatastore(dmManagerServiceType: SupportedDbManagerService.neverSync);
    await gameDatastore.initialize(User(id: id!));

    /// initialize monetary service
    final monetaryService = MonetaryService(gameDatastore: gameDatastore);
    await monetaryService.initialize();

    /// initialize time service
    await TimeService().initialize(gameDatastore: gameDatastore);

    gameBloc.add(
      LoadGameEvent(
        monetaryService: monetaryService,
        gameDatastore: gameDatastore,
        isViewOnly: true,
      ),
    );
  }

  Future<void> _prepareGame() async {
    await _initializeServices();
  }

  Future<void> onStartGame() async {
    emit(const LandingScreenViewOnlyPreparingGame());

    await _prepareGame();

    emit(const LandingScreenViewOnlyGameReady());
  }

  
}
