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

  Vector2 transformPoint(Vector2 point) {
    // Translate the point
    double x1 = point.x - 2048;
    double y1 = -point.y;

    double alphax = math.atan(320 / 512);
    // Apply the rotation
    double x2 = x1 * math.cos(alphax) - y1 * math.sin(alphax);
    double y2 = x1 * math.sin(alphax) + y1 * math.cos(alphax);

    double side = 603.779;
    // Apply the scaling
    // double x3 = x2 * side / 1024;
    // double y3 = y2 * side / 640;x

    // Return the transformed point
    return Vector2(x2, -y2);
  }

  Vector2 cartToIso(Vector2 p, [double alpha = 32]) {
    var p1 = p;
    p1.x = p.x - 2048;
    p1.y = p.y.abs();

    double sin64 = math.sin(radians(alpha * 2));
    double r = p1.length;
    double sinRatio = r / sin64;
    double atan = math.atan(p1.x.abs() / p1.y);

    double sinX = math.cos(atan + radians(alpha));
    double sinY = math.cos(radians(alpha) - atan);

    double a = sinX * sinRatio;
    double b = sinY * sinRatio;
    if (p1.x < 0) return Vector2(a, b);
    return Vector2(b, a);
  }

  Vector2 transformPointScaleOnly(Vector2 point) {
    double side = 603.8;
    // Apply the scaling
    double x3 = point.x * side / 640;
    double y3 = point.y * side / 640;
    // Return the transformed point
    return Vector2(x3, y3);
  }

  Vector2 reverseTransformPoint(Vector2 point) {
    point = Vector2(point.x, -point.y);
    // Rotate back by the negative angle
    double alphax = (90 - 32) * math.pi / 180;
    double x1 = point.x * math.cos(-alphax) - point.y * math.sin(-alphax);
    double y1 = point.x * math.sin(-alphax) + point.y * math.cos(-alphax);

    // Translate the point back
    double x = x1 + 2048;
    double y = -y1;

    // Return the original point
    return Vector2(x, -y);
  }

  Vector2 isoToCart(Vector2 p, [double alpha = 32]) {
    // Assuming `a` and `b` are the isometric coordinates to be converted back to Cartesian
    double a = p.x;
    double b = p.y;

    // Reverse the angle adjustment and ratio calculations
    double sin64 = math.sin(radians(alpha * 2));
    // Assuming an average or combined length `r` based on `a` and `b` for the inversion
    double r = (a + b) / 2; // This might need adjustment based on your specific isometric setup
    double sinRatio = r * sin64; // Reversing the division to multiplication for the ratio

    // Reverse trigonometric transformations to estimate original x and y
    // The exact reversal might depend on the specific transformations applied in `cartToIso`
    double atanX = math.atan(a / sinRatio);
    double atanY = math.atan(b / sinRatio);

    // Reverse the angle adjustment to compute original Cartesian coordinates
    double x = sinRatio * math.cos(atanX - radians(alpha));
    double y = sinRatio * math.cos(atanY + radians(alpha));

    // Adjust based on the original transformation logic in `cartToIso`
    // This might require further refinement
    x += 2048; // Assuming an offset was applied in cartToIso
    y = y.abs(); // Adjusting y based on its absolute value treatment in cartToIso

    return Vector2(x, y);
  }

  double radians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  void onTapDown(TapDownEvent event) async {
    final tappedPosition = cam.viewfinder.parentToLocal(event.devicePosition);
    final isometricPosition = cartToIso(tappedPosition);
    Log.i('cart: $tappedPosition');
    Log.i('iso : $isometricPosition');

    final map = ggworld.mapp.tileMap.map;

    // Log.i('tile: $map');

    for (final f in ggworld.farms.objects) {
      final farmXIso = transformPointScaleOnly(Vector2(f.x, f.y));

      final rect = Rect.fromLTWH(farmXIso.x, farmXIso.y, 603.779, 603.779);
      final isContained = rect.contains(isometricPosition.toOffset());
      if (isContained) {
        final farmBottomXCart = f.x + f.width;
        final farmBottomYCart = f.y + f.height;
        final farmBottomPosCart = Vector2(farmBottomXCart, farmBottomYCart);

        Log.i("farm  ${f.name} tapped with iso cordinates : ${rect.toString()}");
        // Log.i("farm  ${f.name} tapped with  bottomCart : $farmPositionInGameWorld");
        // ggworld.selector.position = farmBottomPosCart;
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
