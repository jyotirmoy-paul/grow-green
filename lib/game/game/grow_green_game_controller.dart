import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import '../../services/log/log.dart';
import '../utils/game_extensions.dart';
import '../utils/game_utils.dart';
import 'world/world/grow_green_world.dart';

class GrowGreenGameController {
  static const tag = 'GrowGreenGameController';

  late final CameraComponent camera;
  late final GrowGreenWorld world;

  late final double _minZoom;
  static const _maxZoomStable = GameUtils.maxZoom;
  static const _maxZoom = _maxZoomStable * 1.6;

  /// called from `grow_green_land_controller` after the world is loaded
  /// gets world's absolute center to adjust the camera zoom & position
  void onWorldLoad(Vector2 worldCenter) {
    final worldSize = GameUtils().gameWorldSize;
    _minZoom = camera.viewport.size.length / worldSize.length;

    // TODO: We can pick last user zoom level & position from storage
    camera.viewfinder
      ..anchor = Anchor.center
      ..position = worldCenter
      ..zoom = _minZoom;
  }

  /// initialize components of the game
  Future<List<Component>> initialize() async {
    world = GrowGreenWorld();
    camera = CameraComponent(world: world);

    return [
      world,
      camera,
    ];
  }

  /// scaling & translating functionality

  double _startZoom = 1.0;
  bool _hasTranslationInertia = false;
  bool _hasScaleInertia = false;
  Vector2 _stopScaleTranslationVelocity = Vector2.zero();

  bool get _hasInertia => _hasTranslationInertia || _hasScaleInertia;

  double get _zoom => camera.viewfinder.zoom;
  set _zoom(double v) => camera.viewfinder.zoom = v.clamp(_minZoom, _maxZoom);

  Vector2 get _position => camera.viewfinder.position;
  set _position(Vector2 v) => camera.viewfinder.position = _getClampedPosition(v);

  Vector2 _getClampedPosition(Vector2 position) {
    if (kDebugMode) return position;
    final halfViewPortSize = camera.viewport.size.scaled(1 / _zoom).half().toSize();
    final halfWorldSize = GameUtils().gameWorldSize.half().toSize();

    final widthFreedom = (halfWorldSize.width - halfViewPortSize.width).abs();
    final heightFreedom = (halfWorldSize.height - halfViewPortSize.height).abs();

    final clampedX = position.x.clamp(-widthFreedom, widthFreedom);
    final clampedY = position.y.clamp(-heightFreedom, heightFreedom);

    Log.i('position: $position $clampedX, $clampedY}');

    return Vector2(clampedX, clampedY);
  }

  void onScaleStart(ScaleStartInfo info) {
    /// stop inertias
    _hasTranslationInertia = false;
    _hasScaleInertia = false;

    /// record current zoom
    _startZoom = _zoom;
  }

  void onScaleUpdate(ScaleUpdateInfo info) {
    /// handle zoom
    _zoom = _startZoom * info.raw.scale;

    Log.i('$tag: onScaleUpdate: zoom: $_zoom');

    /// handle movements
    final delta = info.delta.global.scaled(1 / _zoom);
    _position = _position.translated(
      -delta.x,
      -delta.y,
    );
  }

  void onScaleEnd(ScaleEndInfo info) {
    _stopScaleTranslationVelocity = info.velocity.global;

    /// when there are no pointers, we can start intertial motions
    if (info.pointerCount == 0) {
      _hasTranslationInertia = true;
      _hasScaleInertia = true;
    }
  }

  /// inertia to continue translating even after user input is stopped
  void _updateInertialTranslation(double dt) {
    final adjustedVelocity = _stopScaleTranslationVelocity.scaled(dt * -1); // -1 for opposite direction
    _position = _position.translated(
      adjustedVelocity.x,
      adjustedVelocity.y,
    );

    /// deceleration: at every update cycle lower the vector 95%
    _stopScaleTranslationVelocity.scale(0.95);
  }

  /// inertia to return back to `_maxZoomStable` after an overshoot zoom
  void _updateInertialScale(double dt) {
    if (_zoom > _maxZoomStable && _hasScaleInertia) {
      final zoomDiff = _zoom - _maxZoomStable;
      _zoom -= zoomDiff * (1 - math.pow(math.e, -5 * dt));
    }
  }

  /// stop inertial actions whenever threshold crosses
  void _deactivateInertia() {
    if (_hasTranslationInertia && _stopScaleTranslationVelocity.length < 1) {
      _hasTranslationInertia = false;
      Log.i('$tag: Deactivated translation inertia');
    }

    if (_hasScaleInertia && (_zoom - _maxZoomStable) < 0.01) {
      _hasScaleInertia = false;
      Log.i('$tag: Deactivated scale inertia');
    }
  }

  void onUpdate(double dt) {
    if (_hasInertia) {
      _updateInertialTranslation(dt);
      _updateInertialScale(dt);
      _deactivateInertia();
    }
  }
}
