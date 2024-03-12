import 'package:flame_audio/flame_audio.dart';

import '../../game/game/overlays/game_stat_overlay/enum/time_option.dart';
import '../../game/game/services/game_services/time/time_service.dart';
import '../../game/utils/game_audio_assets.dart';
import '../database/local/local_db.dart';

/// MVP1: Refactor this service
class AudioService {
  static const tag = 'AudioService';
  static const _bgmVolumeKey = 'bgm-volume';
  static const _sfxVolumeKey = 'sfx-volume';

  static AudioService? _instance;

  final LocalDb _db;
  AudioService._() : _db = LocalDb();

  factory AudioService() {
    return _instance ??= AudioService._();
  }

  double _sfxVolume = 1.0;
  double get sfxVolume => _sfxVolume;

  double _bgmVolume = 1.0;
  double get bgmVolume => _bgmVolume;

  bool _isPausedBgmPlaying = false;

  void updateSfxVolumne(double newVolumn) {
    assert(0 <= newVolumn && newVolumn <= 1.0, '$tag: invalid volume: $newVolumn');

    _sfxVolume = newVolumn;
    _db.setDouble(_sfxVolumeKey, newVolumn);
  }

  void updateBgmVolume(double newVolumn) {
    assert(0 <= newVolumn && newVolumn <= 1.0, '$tag: invalid volume: $newVolumn');

    _bgmVolume = newVolumn;
    _db.setDouble(_bgmVolumeKey, newVolumn);

    FlameAudio.bgm.audioPlayer.setVolume(newVolumn);
  }

  Future<void> init() async {
    /// read user set value from db
    _bgmVolume = _db.getDouble(_bgmVolumeKey) ?? _bgmVolume;
    _sfxVolume = _db.getDouble(_sfxVolumeKey) ?? _sfxVolume;

    /// fetch all assets!
    await FlameAudio.audioCache.loadAll(GameAudioAssets.audios);

    /// initialize BGM
    FlameAudio.bgm.initialize();

    /// listen for when to change bgm
    TimeService().timePaceStream.listen((timePaceFactor) {
      final paused = timePaceFactor == TimeOption.pause.timePaceFactor;
      if (_isPausedBgmPlaying == paused) return;

      _playBgm(isTimePaused: paused, volume: _bgmVolume);
      _isPausedBgmPlaying = paused;
    });

    /// finally, play bgm
    _playBgm(volume: _bgmVolume);
  }

  /// play bgm is a private method, it's managed internally
  void _playBgm({
    bool isTimePaused = false,
    double volume = 1.0,
  }) {
    FlameAudio.bgm.play(
      isTimePaused ? GameAudioAssets.timePaused : GameAudioAssets.backgroundScore,
      volume: volume,
    );
  }

  void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  bool get isSfxTurnedOff => _sfxVolume == 0.0;

  /// SFX
  void tap() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.tap, volume: _sfxVolume);
  }

  void coinCollect() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.coinCollect, volume: _sfxVolume);
  }

  void congratsAchievement() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.congratsAchievements, volume: _sfxVolume);
  }

  void cropHarvest() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.cropHarvest, volume: _sfxVolume);
  }

  void treeDied() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.treeDied, volume: _sfxVolume);
  }

  void treeSold() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.treeSold, volume: _sfxVolume);
  }

  void sowedInFarm() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.farmSowed, volume: _sfxVolume);
  }

  void farmTap() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.farmTap, volume: _sfxVolume);
  }

  void farmPurchased() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.farmPurchased, volume: _sfxVolume);
  }

  void gameWorldIntro() {
    if (isSfxTurnedOff) return;
    FlameAudio.play(GameAudioAssets.gameWorldIntro, volume: _sfxVolume);
  }
}
