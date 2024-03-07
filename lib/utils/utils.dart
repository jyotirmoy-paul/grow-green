import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'extensions/num_extensions.dart';

abstract class Utils {
  static final monthYearDateFormat = DateFormat('MMM, yyyy');
  static final monthDateFormat = DateFormat('MMMM');

  static Future<T?> showNonAnimatedDialog<T extends Object?>({
    required String barrierLabel,
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) {
    return showGeneralDialog<T>(
      barrierLabel: barrierLabel,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      context: context,
      transitionDuration: Duration.zero,
      transitionBuilder: (_, __, ___, child) {
        return child;
      },
      pageBuilder: (context, _, __) {
        return builder(context);
      },
    );
  }

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
