import 'dart:math' as math;

import 'package:flutter/material.dart';

class SingleBounceCurve extends Curve {
  const SingleBounceCurve();

  @override
  double transform(double t) {
    return -4 * math.pow(t, 3) + 4 * math.pow(t, 2) + t;
  }
}
