import 'package:flutter/material.dart';

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
        color: const Color(0xff3E3232),
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

  static TextStyle get s18 => TextStyle(
        color: Colors.white,
        fontSize: 18.s,
        letterSpacing: 1.1.s,
      );

  /// non scaled text styles
  static TextStyle get n20 => TextStyle(
        color: Colors.white,
        fontSize: 20,
      );
}
