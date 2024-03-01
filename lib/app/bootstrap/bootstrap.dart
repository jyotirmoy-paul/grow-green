import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:macos_window_utils/window_manipulator.dart';

import '../../firebase_options.dart';
import '../../services/log/log.dart';
import 'app_bloc_observer.dart';

const useFirebaseEmulator = false;

Future<void> _setupFirebaseEmulator() async {
  const macIp = '192.168.0.108';
  const firestoreIp = '$macIp:8080';

  await FirebaseAuth.instance.useAuthEmulator(macIp, 9099);

  FirebaseFirestore.instance.settings = const Settings(
    host: firestoreIp,
    sslEnabled: false,
    persistenceEnabled: false,
  );
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    Log.e(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  return runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // For macos window , hide zoom button and enter fullscreen
      await WindowManipulator.initialize();
      await WindowManipulator.hideZoomButton();
      await WindowManipulator.enterFullscreen();

      await Flame.device.fullScreen();
      await Flame.device.setLandscape();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (useFirebaseEmulator) {
        await _setupFirebaseEmulator();
      }

      runApp(await builder());
    },
    (error, stack) => Log.e(error.toString(), stackTrace: stack),
  );
}
