import 'package:flutter/material.dart';

import '../../../game/game/grow_green_game.dart';
import '../../../game/game/overlays/game_stat_overlay/game_stat_overlay.dart';
import '../../../services/audio/audio_service.dart';
import '../../../utils/constants.dart';

class GameLoadingScreen extends StatefulWidget {
  static const overlayName = 'game-loading-screen';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    return GameLoadingScreen(game: game);
  }

  final GrowGreenGame game;

  const GameLoadingScreen({
    super.key,
    required this.game,
  });

  @override
  State<GameLoadingScreen> createState() => _GameLoadingScreenState();
}

class _GameLoadingScreenState extends State<GameLoadingScreen> {
  void onGameLoaded() async {
    if (widget.game.gameController.isGameLoaded.value != true) return;

    /// wait a little more to finish animations!
    await Future.delayed(kMS300);

    /// play intro audio
    AudioService.gameWorldIntro();

    /// add game stat overlay
    widget.game.overlays.add(GameStatOverlay.overlayName);

    /// remove loading screen
    widget.game.overlays.remove(GameLoadingScreen.overlayName);
  }

  @override
  void initState() {
    super.initState();
    widget.game.gameController.isGameLoaded.addListener(onGameLoaded);
  }

  @override
  void dispose() {
    widget.game.gameController.isGameLoaded.removeListener(onGameLoaded);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Doing something!'),
      ),
    );
  }
}
