import 'package:flutter/material.dart';

import 'extensions/num_extensions.dart';

abstract class Utils {
  static Color darkenColor(Color color, [double amount = 0.30]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lightenColor(Color color, [double amount = 0.30]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static List<BoxShadow> get tappableOutlineShadows => [
        BoxShadow(
          color: Colors.black,
          spreadRadius: 2.s,
          offset: Offset(3.s, 3.s),
        ),
      ];

  static List<BoxShadow> generalOutlineShadows = [
    BoxShadow(
      color: Colors.black,
      spreadRadius: 4.s,
      offset: Offset(0.0, 1.s),
    ),
  ];
}
