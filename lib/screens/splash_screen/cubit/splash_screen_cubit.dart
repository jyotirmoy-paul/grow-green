import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../../../game/utils/game_audio_assets.dart';
import '../../../routes/routes.dart';
import '../../../services/auth/auth.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AuthBloc authBloc;

  SplashScreenCubit({
    required this.authBloc,
  }) : super(SplashScreenInitial());

  Future<void> init() async {
    await Flame.images.loadAllImages();
    await FlameAudio.audioCache.loadAll(GameAudioAssets.audios);

    /// Initialize authentication
    authBloc.add(AuthInitializeEvent());

    await Future.delayed(const Duration(milliseconds: 500));

    emit(SplashScreenDone());

    Navigation.pushReplacement(RouteName.landingScreen);
  }
}
