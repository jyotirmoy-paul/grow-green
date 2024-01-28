import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../routes/routes.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(SplashScreenInitial());

  Future<void> init() async {
    /// TODO: Initialize assets

    /// TODO: Get login status

    await Future.delayed(const Duration(milliseconds: 500));

    emit(SplashScreenDone());

    Navigation.pushReplacement(RouteName.landingScreen);
  }
}
