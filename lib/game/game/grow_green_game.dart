import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:growgreen/game/game/grow_green_world.dart';
import 'package:growgreen/game/utils/game_extensions.dart';
import 'package:growgreen/services/log/log.dart';

class GrowGreenGame extends FlameGame with ScaleDetector, TapCallbacks {
  static const tap = 'GrowGreenGame';

  late CameraComponent cam;
  late GrowGreenWorld gameWorld;

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;

    gameWorld = GrowGreenWorld()
      ..onWorldLoad = (worldCenter) {
        cam.viewfinder.position = worldCenter;
      };

    cam = CameraComponent(
      world: gameWorld,
    )..viewfinder.anchor = Anchor.center;

    addAll([
      gameWorld,
      cam,
    ]);
  }

  @override
  void onTapUp(TapUpEvent event) async {
    final tappedPosition = cam.viewfinder.parentToLocal(event.devicePosition);
    Log.i('GrowGreenGame: tappedPosition: $tappedPosition');

    final gameTappedPosition = tappedPosition.toIso();
    Log.i('GrowGreenGame: gameTappedPosition: $gameTappedPosition');

    for (final f in gameWorld.farms.objects) {
      final rect = Rect.fromLTWH(f.x, f.y, f.width, f.height);
      if (rect.contains(gameTappedPosition.toOffset())) {
        Log.i('GrowGreenGame: ${f.name} is tapped');
        break;
      }
    }
  }

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

    final currPos = cam.viewfinder.position
      ..translate(
        -delta.x * (1 / zoom) * 0.92,
        -delta.y * (1 / zoom) * 0.92,
      );

    cam.viewfinder.position = currPos;
  }
}
