import 'package:flutter/material.dart';

import 'extensions/num_extensions.dart';

abstract class TextStyles {
  /// stylized text styles
  static final TextStyle s12 = TextStyle(
    color: Colors.white,
    fontSize: 12.s,
  );

  /// stylized text styles
  static TextStyle get s16 => TextStyle(
        color: Colors.white,
        fontSize: 16.s,
      );

  static final TextStyle s20 = TextStyle(
    color: Colors.white,
    fontSize: 20.s,
  );

  static final s32 = TextStyle(
    color: Colors.white,
    fontSize: 32.s,
    letterSpacing: 1.2.s,
  );

  static final s30 = TextStyle(
    color: Colors.white,
    fontSize: 30.s,
    letterSpacing: 1.s,
  );

  static final s28 = TextStyle(
    color: Colors.white,
    fontSize: 28.s,
    letterSpacing: 1.s,
  );

  static final s26 = TextStyle(
    color: Colors.white,
    fontSize: 26.s,
    letterSpacing: 1.s,
  );

  static final s25 = TextStyle(
    color: Colors.white,
    fontSize: 25.s,
  );

  static final s24 = TextStyle(
    color: Colors.white,
    fontSize: 24.s,
  );

  /// normal text styles
  static final n18 = TextStyle(
    color: Colors.black,
    fontSize: 18.s,
  );
}
