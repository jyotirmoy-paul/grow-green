import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../services/auth/auth.dart';
import '../../../routes/routes.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AuthBloc authBloc;

  SplashScreenCubit({
    required this.authBloc,
  }) : super(SplashScreenInitial());

  Future<void> init() async {
    /// TODO: Initialize assets

    /// Initialize authentication
    authBloc.add(AuthInitializeEvent());

    await Future.delayed(const Duration(milliseconds: 500));

    emit(SplashScreenDone());

    Navigation.pushReplacement(RouteName.landingScreen);
  }
}
