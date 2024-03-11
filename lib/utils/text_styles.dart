import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'constants.dart';
import 'extensions/num_extensions.dart';

abstract class TextStyles {
  /// scaled text styles
  static TextStyle get s42 => TextStyle(
        color: Colors.white,
        fontSize: 42.s,
        letterSpacing: 1.6.s,
      );

  static TextStyle get s35 => TextStyle(
        color: Colors.white,
        fontSize: 35.s,
        letterSpacing: 1.s,
      );

  static TextStyle get s32 => TextStyle(
        color: Colors.white,
        fontSize: 32.s,
        letterSpacing: 1.s,
      );

  static TextStyle get s30 => TextStyle(
        color: Colors.white,
        fontSize: 30.s,
        letterSpacing: 1.s,
      );

  static TextStyle get s28 => TextStyle(
        color: Colors.white,
        fontSize: 28.s,
        letterSpacing: 1.s,
      );

  static TextStyle get s28brown => TextStyle(
        color: AppColors.brown,
        fontSize: 28.s,
        letterSpacing: 1.1,
        height: 1.2,
      );

  static TextStyle get s26 => TextStyle(
        color: Colors.white,
        fontSize: 26.s,
        letterSpacing: 1.s,
        height: 0.9,
      );

  static TextStyle get s25 => TextStyle(
        color: Colors.white,
        fontSize: 25.s,
      );

  static TextStyle get s24 => TextStyle(
        color: Colors.white,
        fontSize: 24.s,
      );

  static TextStyle get s23 => TextStyle(
        color: Colors.white,
        fontSize: 23.s,
        letterSpacing: 1.2.s,
      );

  static TextStyle get s20 => TextStyle(
        color: Colors.white,
        fontSize: 20.s,
        letterSpacing: 1.2.s,
      );

  static TextStyle get s18 => TextStyle(
        color: Colors.white,
        fontSize: 18.s,
        letterSpacing: 1.1.s,
      );

  static TextStyle get s16 => TextStyle(
        color: Colors.white,
        fontSize: 16.s,
      );

  static TextStyle get s14 => TextStyle(
        color: Colors.white,
        fontSize: 14.s,
        letterSpacing: 1.1.s,
      );

  static TextStyle get s15 => TextStyle(
        color: Colors.white,
        fontSize: 15.s,
        letterSpacing: 1.s,
      );

  /// non scaled text styles
  static TextStyle get n20 => TextStyle(
        fontFamily: kFontFamily,
        color: Colors.white,
        fontSize: 20,
      );

  static TextStyle get n26 => TextStyle(
        fontFamily: kFontFamily,
        color: Colors.white,
        fontSize: 26,
        letterSpacing: 1.2,
      );
}
