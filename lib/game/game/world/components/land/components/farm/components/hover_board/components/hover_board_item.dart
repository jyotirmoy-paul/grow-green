import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../services/log/log.dart';
import '../../../../../../../../../../utils/constants.dart';
import '../../../../../../../../grow_green_game.dart';
import '../../../animations/enums/game_animation_types.dart';
import '../../../animations/game_animation.dart';
import '../models/hover_board_model.dart';

class HoverBoardItem extends PositionComponent with HasGameRef<GrowGreenGame>, TapCallbacks {
  static const tag = 'HoverBoardItem';

  static const imageSize = 60.0;
  static const textSize = 24.0;

  /// basic hover settings
  static const animationDuration = 2.0;
  static const maxScale = 1.15;

  final VoidCallback onTap;
  final Vector2 farmCenter;
  final HoverBoardModel model;

  HoverBoardItem({
    required this.model,
    required this.farmCenter,
    required this.onTap,
  });

  GameAnimation? _animation;
  SpriteComponent? _basicHoverimageComponent;
  Rectangle? _hoverBoardItemRectangle;

  Future<List<Component>> _prepareBasicHoverBoard(BasicHoverBoardModel basicModel) async {
    /// prepare animation
    _animation = GameAnimation(
      totalDuration: animationDuration,
      maxScale: maxScale,
      repeat: true,
      types: GameAnimationTypes.breathing,
    );

    final customFont = TextPaint(
      style: const TextStyle(
        fontFamily: kFontFamily,
        fontSize: textSize,
        backgroundColor: Colors.black,
      ),
    );

    final imageComponent = SpriteComponent(
      sprite: Sprite(await game.images.load(basicModel.image)),
      size: Vector2.all(imageSize),
      anchor: Anchor.bottomCenter,
      position: farmCenter,
    );

    _basicHoverimageComponent = imageComponent;

    const yTranslationOfText = imageSize * maxScale * 1.10;

    final textComponent = TextComponent(
      text: basicModel.text,
      textRenderer: customFont,
      position: farmCenter.translated(0, -yTranslationOfText),
      anchor: Anchor.bottomCenter,
    );

    _hoverBoardItemRectangle = Rectangle.fromCenter(
      center: imageComponent.center,
      size: imageComponent.size,
    );

    return [
      textComponent,
      imageComponent,
    ];
  }

  Future<List<Component>> _prepareTimerHoverBoard(TimerHoverBoardModel timerModel) async {
    return [];
  }

  Future<List<Component>> _prepareHoverBoard() {
    final hm = model;

    if (hm is BasicHoverBoardModel) {
      return _prepareBasicHoverBoard(hm);
    } else if (hm is TimerHoverBoardModel) {
      return _prepareTimerHoverBoard(hm);
    }

    return Future.value(const []);
  }

  @override
  FutureOr<void> onLoad() async {
    final components = await _prepareHoverBoard();
    addAll(components);
  }

  @override
  void onTapUp(TapUpEvent event) {
    Log.d('$tag: onTapUp: $event');
    onTap();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_animation != null) {
      _animation!.update(dt);
      _basicHoverimageComponent?.scale = Vector2.all(_animation!.getCurrentScale());
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (debugMode && _hoverBoardItemRectangle != null) {
      canvas.drawRect(
        _hoverBoardItemRectangle!.toRect(),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0,
      );
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return _hoverBoardItemRectangle?.containsPoint(point) ?? false;
  }
}
