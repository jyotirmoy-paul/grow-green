import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

abstract class AppColors {
  static var kTreeMenuCardBg = Colors.blue.darken(0.5);
  static var kCropMenuCardBg = Colors.red.darken(0.3);
  static var kSystemMenuCardBg = Colors.green.darken(0.2);
  static var kFertilizerMenuCardBg = Colors.indigo.darken(0.3);

  static const textBackgroundColor = Color(0xff402B3A);
  static const white50 = Color(0x80ffffff);
  static const treeMenuCardBg = Color(0xff522e92);
  static const cropMenuCardBg = Color(0xffab2f26);
  static const fertilizerMenuCardBg = Color(0xff435861);

  static const farmHistoryThemeColor = Color(0xff474F7A);

  static const brown = Color(0xff503C3C);
  static const positive = Color(0xff508D69);
  static const negative = Color(0xffD04848);
  static const soilHealthPositiveGraphGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      positive,
      Color(0x44508D69),
    ],
  );
  static const soilHealthNegativeGraphGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      negative,
      Color(0x44D04848),
    ],
  );

  static const farmRevenueGraphGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.lightGreen,
      Color(0x668bc34a),
    ],
  );

  static const gameBackgroundGradientColors = [
    /// gradient 1
    Color(0xff1a2a6c),
    Color(0xfffdbb2d),

    /// gradient 2
    // Color(0xff0575E6),
    // Color(0xff00F260),

    /// gradient 3
    // Color(0xff283c86),
    // Color(0xff45a247),
  ];
}
