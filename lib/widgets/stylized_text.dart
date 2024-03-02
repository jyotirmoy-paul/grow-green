import 'package:flutter/material.dart';

import '../utils/extensions/num_extensions.dart';

class StylizedText extends StatelessWidget {
  final Text text;
  final double? strokeWidth;

  const StylizedText({
    super.key,
    required this.text,
    this.strokeWidth,
  });

  double get magicNumber {
    if (strokeWidth != null) return strokeWidth!;
    final fontSize = text.style?.fontSize ?? 18.s;
    return fontSize / 5;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        textDirection: text.textDirection,
        children: [
          /// translate stroke
          Transform.translate(
            offset: Offset(0, magicNumber * 0.2),
            child: _ShadowedText(
              key: const ValueKey('shadowed-text'),
              text: text.data,
              textStyle: text.style,
              textAlign: text.textAlign,
              strokeWidth: magicNumber,
            ),
          ),

          /// actual text
          text,
        ],
      ),
    );
  }
}

class _ShadowedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final double strokeWidth;

  const _ShadowedText({
    super.key,
    this.strokeWidth = 1.0,
    String? text,
    TextStyle? textStyle,
    TextAlign? textAlign,
  })  : text = text ?? '',
        textAlign = TextAlign.center,
        textStyle = textStyle ?? const TextStyle();

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle.copyWith(
        color: null,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = strokeWidth
          ..color = const Color(0xff402B3A),
      ),
      textAlign: textAlign,
    );
  }
}
