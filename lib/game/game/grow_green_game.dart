import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:growgreen/game/game/grow_green_world.dart';
import 'package:growgreen/services/log/log.dart';
import 'dart:math' as math;

class GrowGreenGame extends FlameGame with ScaleDetector {
  late CameraComponent cam;

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    final ggworld = GrowGreenWorld((center) {
      Log.i('ggworld.center: $center');
      cam.viewfinder.position = center;
    });

    cam = CameraComponent(
      world: ggworld,
    );

    addAll([
      ggworld,
      cam,
    ]);

    // _camera.anchor = Anchor.topRight;
    cam.viewfinder.anchor = Anchor.center;

    // comp.position = Vector2(500, 500);

    // final world = GrowGreenWorld((f) {
    //   // _cam.viewfinder.position = f;
    // });
    // debugMode = true;

    // _cam = CameraComponent(
    //   world: world,
    // );

    // // _cam.viewfinder.anchor = Anchor.topLeft;

    // // _cam.viewfinder.position = Vector2.all(-100);

    // addAll([world]);

    // Future.delayed(const Duration(seconds: 3)).then((_) {
    //   _cam.viewfinder.zoom = 2.0;
    // });

    // _cam.viewfinder.position = comp.center;

    // _cam.snap = comp.absoluteCenter;
    // _cam.viewport.position = comp.absoluteCenter;

    // add(_cam);

    // return super.onLoad();
  }

  void clampZoom() {
    cam.viewfinder.zoom = cam.viewfinder.zoom.clamp(1.0, 5.0);
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
    Log.i('velorant: ${info.velocity.global}');
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
