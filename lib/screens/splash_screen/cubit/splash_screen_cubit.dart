import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../routes/routes.dart';
import '../../../services/auth/auth.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AuthBloc authBloc;

  SplashScreenCubit({
    required this.authBloc,
  }) : super(SplashScreenInitial());

  Future<void> init() async {
    /// TODO: On web: Pre fetch the assets

    /// Initialize authentication
    authBloc.add(AuthInitializeEvent());

    await Future.delayed(const Duration(milliseconds: 500));

    emit(SplashScreenDone());

    Navigation.pushReplacement(RouteName.landingScreen);
  }
}
