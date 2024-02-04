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
      cam.viewfinder.zoom = 0.15;
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

  Vector2 cartToIso(Vector2 p, [double alpha = 32]) {
    // translation
    Vector2 p1 = Vector2.copy(p) - Vector2(2048, 0);

    // calculate sine ratio
    double atan = math.atan2(p1.x, p1.y), r = p1.length;
    double alpharad = radians(alpha);
    double sinRatio = r / math.sin(alpharad * 2);

    // using sine rule to find other edges
    double y1 = math.cos(alpharad + atan) * sinRatio;
    double x1 = math.cos(alpharad - atan) * sinRatio;

    return Vector2(x1, y1);
  }

  Vector2 isoToCart(Vector2 v, [double alpha = 32]) {
    double alpharad = radians(alpha);
    double x = v.x * math.cos(alpharad) - v.y * math.cos(alpharad);
    double y = v.x * math.sin(alpharad) + v.y * math.sin(alpharad);
    return Vector2(x + 2048, y);
  }

  Vector2 gameToIso(Vector2 point) {
    double side = 603.8;
    // Apply the scaling
    double x3 = point.x * side / 640;
    double y3 = point.y * side / 640;
    // Return the transformed point
    return Vector2(x3, y3);
  }

  @override
  void onTapDown(TapDownEvent event) async {
    final tappedPosition = cam.viewfinder.parentToLocal(event.devicePosition);
    final isometricPosition = cartToIso(tappedPosition);
    final isoToCartP = isoToCart(isometricPosition);
    Log.i('cart: $tappedPosition');
    Log.i('iso : $isometricPosition');

    Log.i("isoToCart : $isoToCartP");

    final map = ggworld.mapp.tileMap.map;

    // Log.i('tile: $map');

    for (final f in ggworld.farms.objects) {
      final farmXIso = gameToIso(Vector2(f.x, f.y));

      final rect = Rect.fromLTWH(farmXIso.x, farmXIso.y, 603.779, 603.779);

      final isContained = rect.contains(isometricPosition.toOffset());
      if (isContained) {
        final farmBottomXCart = f.x + f.width;
        final farmBottomYCart = f.y + f.height;
        final farmBottomPosGame = Vector2(farmBottomXCart, farmBottomYCart);
        final farmBottomIso = gameToIso(farmBottomPosGame);
        final farmBottomCart = isoToCart(farmBottomIso);
        Log.i("farm  ${f.name} tapped with iso cordinates : ${rect.toString()}");
        // Log.i("farm  ${f.name} tapped with  bottomCart : $farmPositionInGameWorld");
        ggworld.selector.position = farmBottomCart;
        break;
      }
    }
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
