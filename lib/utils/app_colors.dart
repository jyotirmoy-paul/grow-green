import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

abstract class AppColors {
  static var kTreeMenuCardBg = Colors.blue.darken(0.5);
  static var kCropMenuCardBg = Colors.red.darken(0.3);
  static var kSystemMenuCardBg = Colors.green.darken(0.2);
  static var kFertilizerMenuCardBg = Colors.indigo.darken(0.3);

  static const white50 = Color(0x80ffffff);
  static const treeMenuCardBg = Color(0xff522e92);
  static const cropMenuCardBg = Color(0xffab2f26);
  static const fertilizerMenuCardBg = Color(0xff435861);

  static const soilHealthPositiveColor = Color(0xff508D69);
  static const soilHealthNegativeColor = Color(0xffD04848);
  static const soilHealthPositiveGraphGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      soilHealthPositiveColor,
      Color(0x44508D69),
    ],
  );
  static const soilHealthNegativeGraphGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      soilHealthNegativeColor,
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
}
