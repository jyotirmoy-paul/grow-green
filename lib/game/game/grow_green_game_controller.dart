import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart' hide Timer;
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '../../screens/game_screen/view/game_loading_screen.dart';
import '../../services/audio/audio_service.dart';
import '../../services/log/log.dart';
import '../utils/game_utils.dart';
import 'grow_green_game.dart';
import 'models/overlay_data.dart';
import 'services/datastore/game_datastore.dart';
import 'services/game_services/monetary/monetary_service.dart';
import 'world/components/land/overlays/achievement/achievements_service.dart';
import 'world/world/grow_green_world.dart';

class GrowGreenGameController {
  static const tag = 'GrowGreenGameController';

  GrowGreenGameController({
    required this.gameDatastore,
    required this.monetaryService,
  });

  final ValueNotifier<bool> isGameLoaded = ValueNotifier(false);
  final GameDatastore gameDatastore;
  final MonetaryService monetaryService;

  final OverlayData overlayData = OverlayData();

  late final GrowGreenGame game;
  late final CameraComponent camera;
  late final AchievementsService achievementsService;
  late final GrowGreenWorld world;

  late final double _minZoom;
  double get minZoom => _minZoom;

  late final Vector2 worldCenter;

  static const _maxZoomStable = GameUtils.maxZoom;
  static const _maxZoom = _maxZoomStable * 1.6;

  /// called from `grow_green_land_controller` after the world is loaded
  /// gets world's absolute center to adjust the camera zoom & position
  void onWorldLoad(Vector2 worldCenter) {
    this.worldCenter = worldCenter;
    final worldSize = GameUtils().gameWorldSize;

    _minZoom = camera.viewport.size.length / worldSize.length;

    camera.viewfinder
      ..anchor = Anchor.center
      ..position = worldCenter
      ..zoom = _minZoom; // start with _minZoom
  }

  /// initialize components of the game
  Future<List<Component>> initialize({required GrowGreenGame game}) async {
    this.game = game;

    /// display game loading screen
    game.overlays.add(GameLoadingScreen.overlayName);

    world = GrowGreenWorld();
    camera = CameraComponent(world: world);

    // initialize achievements service
    achievementsService = AchievementsService(game: game);

    /// initialize audio
    AudioService.init();

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
  set _position(Vector2 v) => camera.viewfinder.position = v;

  Vector2 _getClampedPosition(Vector2 position) {
    final zoomLevel = camera.viewfinder.zoom;

    final visibleWorldSize = camera.viewport.size / zoomLevel;
    final diffWorldSize = GameUtils().gameBackgroundSize - visibleWorldSize;

    /// image a rectangle in the center, which determines how much the camera's position can move
    /// and the idea is whenever the game world is zoomed in, the rectangle size grows
    /// (and that's exactly the value of diffWorldSize)
    final rectangle = Rectangle.fromCenter(center: worldCenter, size: diffWorldSize);

    final clampedX = position.x.clamp(rectangle.left, rectangle.right);
    final clampedY = position.y.clamp(rectangle.top, rectangle.bottom);

    return Vector2(clampedX, clampedY);
    // return clampedPosition;
    // final halfViewPortSize = camera.viewport.size.scaled(1 / _zoom).half().toSize();
    // final halfWorldSize = GameUtils().gameWorldSize.half().half().toSize();

    // final leftBoundary = worldCenter.x - halfWorldSize.width;
    // final rightBoundary = worldCenter.x + halfWorldSize.width;
    // final topBoundary = worldCenter.y - halfWorldSize.height;
    // final bottomBoundary = worldCenter.y + halfWorldSize.height;

    // final l = leftBoundary + halfViewPortSize.width;
    // final r = rightBoundary - halfViewPortSize.width;
    // final t = topBoundary + halfViewPortSize.height;
    // final b = bottomBoundary - halfViewPortSize.height;

    // final clampedX = position.x.clamp(l < r ? l : r, l > r ? l : r);
    // final clampedY = position.y.clamp(t < b ? t : b, t > b ? t : b);

    // return Vector2(clampedX, clampedY);
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

    /// handle movements
    final delta = info.delta.global.scaled(1 / _zoom);
    _position = _getClampedPosition(
      _position.translated(
        -delta.x,
        -delta.y,
      ),
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

  static const zoomPerScrollUnit = 0.04;
  Timer? _timer;

  void onScroll(PointerScrollInfo info) {
    _zoom = _zoom + info.scrollDelta.global.y.sign * zoomPerScrollUnit;
    _timer?.cancel();

    _timer = Timer(
      const Duration(milliseconds: 100),
      () {
        onScaleEnd(
          ScaleEndInfo.fromDetails(ScaleEndDetails()),
        );
      },
    );
  }

  /// inertia to continue translating even after user input is stopped
  void _updateInertialTranslation(double dt) {
    final adjustedVelocity = _stopScaleTranslationVelocity.scaled(dt * -1); // -1 for opposite direction
    _position = _getClampedPosition(
      _position.translated(
        adjustedVelocity.x,
        adjustedVelocity.y,
      ),
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
