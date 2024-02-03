import 'dart:async';
import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
import 'package:growgreen/game/game/grow_green_world.dart';
import 'package:growgreen/services/log/log.dart';
import 'dart:math' as math;

class GrowGreenGame extends FlameGame with ScaleDetector, TapCallbacks {
  late CameraComponent cam;
  late GrowGreenWorld ggworld;

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    ggworld = GrowGreenWorld((center) {
      cam.viewfinder.position = center;
      cam.viewfinder.zoom = 1;
    });

    cam = CameraComponent(
      world: ggworld,
    );

    addAll([
      ggworld,
      cam,
    ]);

    cam.viewfinder.anchor = Anchor.center;
  }

  static const tileWidth = 1024.0;
  static const tileHeight = tileWidth / 1.6;

  static const double isometricAngle = 32 * math.pi / 180;
  static double isometricOffsetX = tileWidth * math.cos(isometricAngle) / 2;
  static double isometricOffsetY = tileHeight * math.sin(isometricAngle) / 2;

  SequenceEffectController sec() {
    return SequenceEffectController([
      LinearEffectController(1),
      PauseEffectController(0.2, progress: 1.0),
      ReverseLinearEffectController(1),
    ]);
  }

  Vector2 transformPoint(Vector2 point) {
    // Translate the point
    double x1 = point.x - 2048;
    double y1 = point.y;

    // Angle alpha in radians (58 degrees)
    double alpha = (32) * math.pi / 180;

    // Apply the rotation
    double x2 = x1 * math.cos(alpha) + y1 * math.sin(alpha);
    double y2 = -x1 * math.sin(alpha) + y1 * math.cos(alpha);

    // Return the transformed point
    return Vector2(x2, y2);
  }

  @override
  void onTapDown(TapDownEvent event) async {
    final tappedPosition = cam.viewfinder.parentToLocal(event.devicePosition);
    Log.i('tappedPosition: ${tappedPosition}');
    Log.i('real world: ${transformPoint(tappedPosition)}');

    final map = ggworld.mapp.tileMap.map;

    Log.i('tile: $map');

    map.

    // final stack = ggworld.mapp.tileMap.tileStack(0, 0, named: {'Ground'});

    // compo!.add(
    //   ScaleEffect.by(Vector2.all(2.0), sec(), onComplete: () {
    //     Log.i('tapp: onDone');
    //   }),
    // );

    // Log.i('tapp: $tappedPosition >> $}stack{}');
    // add(
    //   ScaleEffect.by(
    //     Vector2.all(2.0),
    //     EffectController(
    //       duration: 0.5,
    //       curve: Curves.bounceInOut,
    //     ),
    //   ),
    // );

    // for (final f in ggworld.farms.objects) {
    //   Log.i('tapp: ${f.name} ${f.x} ${f.y}');
    // }

    // const tileWidth = 1024.0;
    // const tileHeight = 640.0;

    // const ratio = (tileHeight / tileWidth) * 2.0;

    // Log.i('tapp: $ratio');

    // final int tileX = ((tappedPosition.x / tileWidth) + (tappedPosition.y / tileHeight * ratio)).floor();
    // final int tileY = ((tappedPosition.y / tileHeight * ratio) - (tappedPosition.x / tileWidth)).floor();

    // Log.i('tapp: $tileX, $tileY');
  }
  //////////

  void clampZoom() {
    cam.viewfinder.zoom = cam.viewfinder.zoom.clamp(0.1, 1.0);
  }

  void clamps() {
    final pos = cam.viewfinder.position;

    cam.viewfinder.position = pos;
  }

  late double startZoom;

  bool hasStarted = false;

  @override
  void onScaleStart(ScaleStartInfo info) {
    startZoom = cam.viewfinder.zoom;
    hasStarted = true;
  }

  int lastTimeCame = 0;

  List<double> generateEaseOutMultipliers(int steps) {
    return List.generate(steps, (index) {
      double t = index / (steps - 1);
      // Using a sine function to simulate the ease-out effect
      return math.sin(t * math.pi / 2);
    }).reversed.toList();
  }

  List<double> generateEaseInOutMultipliers(int steps) {
    return List.generate(steps, (index) {
      double t = index / (steps - 1);
      return math.pow(math.sin(t * math.pi / 2), 2).toDouble();
    }).reversed.toList();
  }

  @override
  void onScaleEnd(ScaleEndInfo info) async {
    final velocity = info.velocity.global;
    final modVelocity = velocity.distanceTo(Vector2.zero());
    if (modVelocity < 200) return;
    final currTime = DateTime.now().millisecondsSinceEpoch;
    if (currTime - lastTimeCame < 100) {
      return;
    }

    lastTimeCame = currTime;

    hasStarted = false;
    final camPos = cam.viewfinder.position;
    double dx = -stopDelta.x;
    double dy = -stopDelta.y;

    const tt = 40;

    for (int t = 0; t < tt; t++) {
      if (hasStarted) break;
      camPos.translate(dx, dy);
      cam.viewfinder.position = camPos;

      dx = dx * 0.92;
      dy = dy * 0.92;

      Log.i('joinam($dx, $dy)');

      await Future.delayed(const Duration(milliseconds: 16));
    }

    stopDelta.setZero();
  }

  Vector2 stopDelta = Vector2.zero();

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    /// zoom
    cam.viewfinder.zoom = startZoom * info.raw.scale;
    clampZoom();

    final delta = info.delta.global;
    final isDeltaGreater = delta.distanceTo(Vector2.zero()) > stopDelta.distanceTo(Vector2.zero());
    if (isDeltaGreater) stopDelta = delta;

    final zoom = cam.viewfinder.zoom;

    Log.i('devjyoti: $delta');

    final currPos = cam.viewfinder.position
      ..translate(
        -delta.x * (1 / zoom) * 0.92,
        -delta.y * (1 / zoom) * 0.92,
      );

    cam.viewfinder.position = currPos;
  }
}
