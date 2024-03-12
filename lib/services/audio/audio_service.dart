import 'package:flame_audio/flame_audio.dart';

import '../../game/game/overlays/game_stat_overlay/enum/time_option.dart';
import '../../game/game/services/game_services/time/time_service.dart';
import '../../game/utils/game_audio_assets.dart';

abstract class AudioService {
  static void init() {
    FlameAudio.bgm.initialize();

    bool isPaused = false;

    TimeService().timePaceStream.listen((timePaceFactor) {
      final paused = timePaceFactor == TimeOption.pause.timePaceFactor;
      if (isPaused == paused) return;

      playBgm(isTimePaused: paused);
      isPaused = paused;
    });

    playBgm();
  }

  /// BGM
  static void playBgm({bool isTimePaused = false}) {
    FlameAudio.bgm.play(
      isTimePaused ? GameAudioAssets.timePaused : GameAudioAssets.backgroundScore,
    );
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  /// SFX
  static void tap() {
    FlameAudio.play(GameAudioAssets.tap);
  }

  static void coinCollect() {
    FlameAudio.play(GameAudioAssets.coinCollect);
  }

  static void congratsAchievement() {
    FlameAudio.play(GameAudioAssets.congratsAchievements);
  }

  static void cropHarvest() {
    FlameAudio.play(GameAudioAssets.cropHarvest);
  }

  static void treeDied() {
    FlameAudio.play(GameAudioAssets.treeDied);
  }

  static void treeSold() {
    FlameAudio.play(GameAudioAssets.treeSold);
  }

  static void sowedInFarm() {
    FlameAudio.play(GameAudioAssets.farmSowed);
  }

  static void farmTap() {
    FlameAudio.play(GameAudioAssets.farmTap);
  }

  static void farmPurchased() {
    FlameAudio.play(GameAudioAssets.farmPurchased);
  }

  static void gameWorldIntro() {
    FlameAudio.play(GameAudioAssets.gameWorldIntro);
  }
}
