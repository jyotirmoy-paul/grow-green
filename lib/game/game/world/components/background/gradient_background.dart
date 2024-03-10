import 'dart:ui';

import 'package:flame/components.dart';

import '../../../../utils/game_extensions.dart';
import '../../../../utils/game_utils.dart';
import '../../../services/priority/priority_engine.dart';

class GradientBackground extends PositionComponent {
  late final Paint backgroundPainter;
  late final Rect rect;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    priority = PriorityEngine.backgroundPriority;
    size = GameUtils().gameBackgroundSize;
    rect = Rect.fromLTWH(0, 0, size.x, size.y);
    anchor = Anchor.center;
    position = GameUtils().gameWorldSize.half();

    final gradient = Gradient.linear(
      Offset(size.x / 2, 0),
      Offset(size.x / 2, size.y),
      const [
        /// gradient 1
        Color(0xff1a2a6c),
        Color(0xfffdbb2d),

        /// gradient 2
        // Color(0xff0575E6),
        // Color(0xff00F260),

        /// gradient 3
        // Color(0xff283c86),
        // Color(0xff45a247),
      ],
    );

    backgroundPainter = Paint()..shader = gradient;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect, backgroundPainter);
  }
}
