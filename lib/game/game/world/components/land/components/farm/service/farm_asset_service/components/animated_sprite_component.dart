import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../services/log/log.dart';

class CrossFadeSpriteComponent extends PositionComponent {
  final double animationDuration;
  Sprite currentSprite;
  double currentSpriteOpacity = 1.0;
  double nextSpriteOpacity = 0.0;
  bool isTransitioning = false;

  Sprite? nextSprite;
  ColorFilter? _colorFilter;

  CrossFadeSpriteComponent({
    required Sprite initialSprite,
    this.animationDuration = 1.0,
  }) : currentSprite = initialSprite;

  void changeSprite(Sprite newSprite) {
    nextSprite = newSprite;
    isTransitioning = true;
    nextSpriteOpacity = 0.0;
  }

  @override
  FutureOr<void> onLoad() {
    size = currentSprite.image.size;
    anchor = Anchor.topLeft;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isTransitioning) {
      currentSpriteOpacity -= dt * animationDuration;
      nextSpriteOpacity += dt * animationDuration;

      Log.i('doung something: cso: $currentSpriteOpacity nso: $nextSpriteOpacity');

      /// transition is complete
      if (nextSpriteOpacity >= 1.0) {
        currentSprite = nextSprite!;
        nextSprite = null;
        currentSpriteOpacity = 1.0;
        nextSpriteOpacity = 0.0;
        isTransitioning = false;
      }
    }
  }

  void setColorFilter(ColorFilter? colorFilter) {
    _colorFilter = colorFilter;
  }

  final _currentSpritePaint = Paint();
  final _nextSpritePaint = Paint();

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    currentSprite.render(
      canvas,
      size: size,
      overridePaint: _currentSpritePaint
        ..color = Colors.transparent.withOpacity(currentSpriteOpacity)
        ..colorFilter = _colorFilter,
    );

    nextSprite?.render(
      canvas,
      size: size,
      overridePaint: _nextSpritePaint..color = Colors.transparent.withOpacity(nextSpriteOpacity),
    );
  }
}
