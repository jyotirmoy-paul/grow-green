import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../../../../../../../utils/app_colors.dart';
import '../../../../../../../../../../../utils/text_styles.dart';
import 'age_revenue_tree.dart';

class AgeTag extends StatelessWidget {
  final String? title;
  final Size size;
  final TopImageFooterShape shape;
  const AgeTag({
    super.key,
    this.title,
    required this.size,
    required this.shape,
  });

  Widget get _buildRhombus {
    final rhomBusWidth = min(size.width, size.height * 1.5);
    final rhombusSize = Size(rhomBusWidth, size.height);
    return CustomPaint(
      painter: _RhombusPainter(),
      size: rhombusSize,
    );
  }

  Widget get _buildCircle {
    final circleSize = Size.square(size.shortestSide);
    return Container(
      width: circleSize.width,
      height: circleSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget get _buildShape {
    switch (shape) {
      case TopImageFooterShape.rhombus:
        return _buildRhombus;
      case TopImageFooterShape.circle:
        return _buildCircle;
    }
  }

  Widget get _buildTitle {
    return Text(
      title ?? '·',
      style: TextStyles.s28.copyWith(
        color: AppColors.brown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildShape,
          _buildTitle,
        ],
      ),
    );
  }
}

class _RhombusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0) // Top center
      ..lineTo(0, size.height / 2) // Left middle
      ..lineTo(size.width / 2, size.height) // Bottom center
      ..lineTo(size.width, size.height / 2) // Right middle
      ..close(); // Connects the path back to the starting point

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
