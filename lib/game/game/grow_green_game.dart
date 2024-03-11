import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'grow_green_game_controller.dart';
import 'services/datastore/game_datastore.dart';
import 'services/game_services/monetary/monetary_service.dart';

class GrowGreenGame extends FlameGame with ScaleDetector, ScrollDetector {
  final GrowGreenGameController gameController;

  final GameDatastore gameDatastore;
  final MonetaryService monetaryService;

  GrowGreenGame({
    required this.gameDatastore,
    required this.monetaryService,
  }) : gameController = GrowGreenGameController(gameDatastore: gameDatastore, monetaryService: monetaryService);

  @override
  FutureOr<void> onLoad() async {
    /// remove default camera
    remove(camera);

    debugMode = false;
    final components = await gameController.initialize(game: this);
    addAll(components);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameController.onUpdate(dt);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    gameController.onScaleStart(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    gameController.onScaleUpdate(info);
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    gameController.onScaleEnd(info);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    gameController.onScroll(info);
  }
}
