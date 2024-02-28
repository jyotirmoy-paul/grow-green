import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static final Responsive _instance = Responsive._();

  factory Responsive() {
    return _instance;
  }

  double _magicRatio = 1.0;

  void init({
    required BuildContext context,
    Size referSize = const Size(1194.0, 834.0), // ipad's resolution
    double referPixelRatio = 2.0, // ipad's pixel ratio
  }) {
    final currentSize = MediaQuery.of(context).size;
    final currentPixelDensity = MediaQuery.of(context).devicePixelRatio;
    final wRatio = currentSize.width / referSize.width;
    _magicRatio = (referPixelRatio * wRatio) / currentPixelDensity;
  }

  double get scaleFactor {
    return _magicRatio;
  }
}
