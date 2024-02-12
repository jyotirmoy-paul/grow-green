import 'package:flutter/material.dart';

class TripleTween extends Tween<double> {
  final double middle;
  final double middlePoint; // A value between 0.0 and 1.0 to indicate where the middle occurs

  TripleTween({
    required double begin,
    required double end,
    required this.middle,
    this.middlePoint = 0.5, // Default to halfway if not specified
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    if (t < middlePoint) {
      // Interpolate between begin and middle
      return begin! + (middle - begin!) * (t / middlePoint);
    } else {
      // Interpolate between middle and end
      double adjustedT = (t - middlePoint) / (1 - middlePoint);
      return middle + (end! - middle) * adjustedT;
    }
  }
}
