import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../../../routes/routes.dart';
import '../../../services/audio/audio_service.dart';
import '../../../services/auth/auth.dart';
import '../../../services/database/local/local_db.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AuthBloc authBloc;

  SplashScreenCubit({
    required this.authBloc,
  }) : super(SplashScreenInitial());

  Future<void> init() async {
    await Flame.images.loadAllImages();

    /// initialize local db
    await LocalDb().init();

    /// initialize audio service
    await AudioService().init();

    /// initialize authentication
    authBloc.add(AuthInitializeEvent());

    await Future.delayed(const Duration(milliseconds: 500));

    emit(SplashScreenDone());

    Navigation.pushReplacement(RouteName.landingScreen);
  }
}
