import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import '../../services/log/log.dart';
import 'app_bloc_observer.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    Log.e(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  return runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Flame.device.fullScreen();
      await Flame.device.setLandscape();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(await builder());
    },
    (error, stack) => Log.e(error.toString(), stackTrace: stack),
  );
}
