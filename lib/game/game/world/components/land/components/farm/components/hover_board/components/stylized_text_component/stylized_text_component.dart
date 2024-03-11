import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../../utils/text_styles.dart';

class StylizedTextComponent extends PositionComponent {
  final String text;
  final double strokeWidth;
  final TextStyle textStyle;
  final double initialOpacity;

  StylizedTextComponent({
    required this.text,
    this.strokeWidth = 6.0,
    this.initialOpacity = 1.0,
  }) : textStyle = TextStyles.n26;

  TextComponent? _text;
  TextComponent? _shadowText;

  void updateText(String text) {
    _text?.text = text;
    _shadowText?.text = text;
  }

  void setTextOpacity(double opacity) {
    _text?.textRenderer = _getPaint(opacity);
    _shadowText?.textRenderer = _getBackgroundPaint(opacity);
  }

  TextPaint _getPaint(double opacity) {
    return TextPaint(
      style: textStyle.copyWith(
        color: textStyle.color?.withOpacity(opacity),
      ),
    );
  }

  TextPaint _getBackgroundPaint(double opacity) {
    return TextPaint(
      style: textStyle.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = strokeWidth
          ..color = Colors.black.withOpacity(opacity),
      ),
    );
  }

  @override
  FutureOr<void> onLoad() {
    _text = TextComponent(
      text: text,
      textRenderer: _getPaint(initialOpacity),
      priority: 1,
    );

    _shadowText = TextComponent(
      text: text,
      textRenderer: _getBackgroundPaint(initialOpacity),
      priority: 0,
      position: Vector2(0, 1.5),
    );

    size = _text!.size;

    addAll([_shadowText!, _text!]);

    return super.onLoad();
  }
}
