import 'package:flutter/material.dart';

import '../../../game/game/grow_green_game.dart';
import '../../../game/game/overlays/game_stat_overlay/game_stat_overlay.dart';
import '../../../game/utils/game_assets.dart';
import '../../../services/audio/audio_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/stylized_text.dart';

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
    await Future.delayed(kMS400);

    /// play intro audio
    AudioService().gameWorldIntro();

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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(GameAssets.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: StylizedText(
              text: Text(
                'Preparing Your Village',
                style: TextStyles.s42,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
