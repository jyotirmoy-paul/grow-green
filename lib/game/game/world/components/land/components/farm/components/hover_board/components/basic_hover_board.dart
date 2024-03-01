import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../services/log/log.dart';
import '../../../../../../../../../../utils/constants.dart';
import '../../../../../../../../grow_green_game.dart';
import '../../../animations/enums/game_animation_type.dart';
import '../../../animations/game_animation.dart';
import '../../../farm.dart';
import '../models/hover_board_model.dart';
import 'hover_board_item.dart';

class BasicHoverBoard extends HoverBoardItem with HasGameRef<GrowGreenGame> {
  static const imageSize = 70.0;
  static const textSize = 24.0;

  static const animationDuration = 2.0;
  static const maxScale = 1.15;

  static const endAnimationDuration = 2.5;

  final VoidCallback onTap;
  final Vector2 farmCenter;
  final BasicHoverBoardModel model;
  final Farm farm;
  final String tag;

  BasicHoverBoard({
    required this.model,
    required this.farmCenter,
    required this.onTap,
    required this.farm,
  }) : tag = 'BasicHoverBoard[${farm.farmId}]';

  /// components
  SpriteComponent? _imageComponent;
  TextComponent? _textComponent;

  /// utils
  GameAnimation? _imageOpacityAnimation;
  GameAnimation? _textOpacityAnimation;
  GameAnimation? _imageAnimation;
  Rectangle? _tappableRectangle;
  SpriteAnimation? _spriteAnimation;

  Future<void> _prepareAssetCollectionAnimation() async {
    final sprites = <Sprite>[];

    for (int i = 1; i <= 10; i++) {
      Sprite sprite = await Sprite.load('${model.animationPrefix}/$i.png');
      sprites.add(sprite);
    }

    _spriteAnimation = SpriteAnimation.spriteList(
      sprites,
      stepTime: endAnimationDuration / sprites.length,
      loop: false,
    );
  }

  TextPaint _getPaint({double withOpacity = 0.0}) {
    return TextPaint(
      style: TextStyle(
        fontFamily: kFontFamily,
        fontSize: textSize,
        color: Colors.white.withOpacity(withOpacity),
        backgroundColor: Colors.black.withOpacity(withOpacity),
      ),
    );
  }

  void _update(BasicHoverBoardModel model) {
    /// TODO: If needed, other components can be updated here as well

    /// update text
    _textComponent?.text = model.text;
  }

  Future<List<Component>> _prepare() async {
    farm.farmController.onFarmTap = _onTap;

    /// prepare animations
    await _prepareAssetCollectionAnimation();

    _imageAnimation = GameAnimation(
      totalDuration: animationDuration,
      maxValue: maxScale,
      repeat: true,
      type: GameAnimationType.breathing,
    );

    /// prepare components

    _imageComponent = SpriteComponent(
      sprite: Sprite(await game.images.load(model.image)),
      size: Vector2.all(imageSize),
      anchor: Anchor.bottomCenter,
      position: farmCenter,
    );

    const yTranslationOfText = imageSize * maxScale * 1.10;

    _textComponent = TextComponent(
      text: model.text,
      textRenderer: _getPaint(),
      position: farmCenter.translated(0, -yTranslationOfText),
      anchor: Anchor.bottomCenter,
    );

    _tappableRectangle = Rectangle.fromCenter(
      center: _imageComponent!.center,
      size: _imageComponent!.size,
    );

    return [_textComponent!, _imageComponent!];
  }

  @override
  FutureOr<void> onLoad() async {
    final components = await _prepare();
    addAll(components);

    return super.onLoad();
  }

  void _onTap() {
    /// deregister the callback
    farm.farmController.onFarmTap = null;

    final animationSprite = SpriteAnimationComponent(
      animation: _spriteAnimation,
      removeOnFinish: true,
      anchor: Anchor.bottomCenter,
      position: _imageComponent?.position,
      size: _imageComponent?.size,
      scale: Vector2.all(5.0),
    );

    add(animationSprite);

    _textOpacityAnimation = GameAnimation(
      totalDuration: endAnimationDuration,
      minValue: 0.0,
      maxValue: 1.0,
      type: GameAnimationType.breathing,
    );

    _imageOpacityAnimation = GameAnimation(
      totalDuration: endAnimationDuration,
      minValue: 0.0,
      maxValue: 1.0,
      type: GameAnimationType.easeOut,
      onComplete: () {
        removeFromParent();
      },
    );

    /// notify parent
    onTap();
  }

  @override
  void update(double dt) {
    super.update(dt);

    /// image breathing animation
    _imageAnimation?.update(dt);
    _imageComponent?.scale = Vector2.all(_imageAnimation?.value ?? 1.0);

    /// when user taps, animate everything to fade out
    if (_imageOpacityAnimation != null && _textOpacityAnimation != null) {
      final imgOpacityAnim = _imageOpacityAnimation!;
      final txtOpacityAnim = _textOpacityAnimation!;

      imgOpacityAnim.update(dt);
      txtOpacityAnim.update(dt);

      _imageComponent?.paint = Paint()..color = Colors.white.withOpacity(1 - imgOpacityAnim.value);

      final textComponentPosition = _textComponent?.position;
      if (textComponentPosition != null) {
        _textComponent?.position = textComponentPosition.translated(0, -30 * dt);
      }

      _textComponent?.textRenderer = _getPaint(withOpacity: txtOpacityAnim.value);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (debugMode && _tappableRectangle != null) {
      canvas.drawRect(
        _tappableRectangle!.toRect(),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0,
      );
    }
  }

  /// FIXME: There is a bug, if user taps on the farm just before updateData is invoked, the model will be will not be handled, until the next cycle
  /// This happens because the moement user taps on the farm, we start processing the user's payments & start the animation
  /// Not a critical bug, so ignoring it for now
  @override
  void updateData(HoverBoardModel model) {
    Log.d('$tag: updateData($model) invoked, let\'s update the basic hover data');

    if (model is BasicHoverBoardModel) {
      _update(model);
    } else {
      throw Exception('$tag: updateData($model) invoked with wrong model');
    }
  }
}
