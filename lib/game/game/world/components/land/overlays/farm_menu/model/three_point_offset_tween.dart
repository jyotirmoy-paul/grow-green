import 'package:flutter/material.dart';

class ThreePointOffsetTween extends Tween<Offset> {
  final double midPoint;
  final Offset x;
  final Offset i;
  final Offset y;

  ThreePointOffsetTween({
    this.midPoint = 0.5,
    required this.x,
    required this.i,
    required this.y,
  })  : assert(midPoint > 0 && midPoint < 1),
        super(begin: x, end: y);

  @override
  Offset lerp(double t) {
    if (t < midPoint) {
      return Offset.lerp(x, i, t / midPoint)!;
    } else {
      return Offset.lerp(i, y, (t - midPoint) / (1 - midPoint))!;
    }
  }
}
