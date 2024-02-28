import 'package:flutter/material.dart';

import 'extensions/num_extensions.dart';

abstract class TextStyles {
  static List<Shadow> _shadows(double fontSize) => [
        Shadow(
          color: Colors.black,
          offset: Offset(0, (5 * fontSize) / 32),
          blurRadius: 0.0,
        ),
        Shadow(
          color: Colors.black,
          offset: Offset((2 * fontSize) / 32, (5 * fontSize) / 32),
          blurRadius: 0.0,
        ),
        Shadow(
          color: Colors.black,
          offset: Offset(-(2 * fontSize) / 32, (5 * fontSize) / 32),
          blurRadius: 0.0,
        ),
        Shadow(
          color: Colors.black,
          offset: Offset(0, (-2 * fontSize) / 32),
          blurRadius: 0.0,
        ),
        Shadow(
          color: Colors.black,
          offset: Offset((2 * fontSize) / 32, 0),
          blurRadius: 0.0,
        ),
        Shadow(
          color: Colors.black,
          offset: Offset(-(2 * fontSize) / 32, 0),
          blurRadius: 0.0,
        ),
      ];

  static TextStyle get s5 => TextStyle(
        color: Colors.white,
        fontSize: 12.s,
        shadows: _shadows(12.s),
      );

  static final TextStyle s20 = TextStyle(
    color: Colors.white,
    fontSize: 20.s,
    shadows: _shadows(20.s),
  );

  static final s32 = TextStyle(
    color: Colors.white,
    fontSize: 32.s,
    shadows: _shadows(32.s),
  );
}
