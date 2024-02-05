import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import '../../../../../grow_green_game.dart';

class FarmController {
  late final GrowGreenGame game;
  late final String farmName;
  late final Rectangle farmRect;

  Future<List<Component>> initialize({
    required GrowGreenGame game,
    required String farmName,
    required Rectangle farmRect,
  }) async {
    this.game = game;
    this.farmName = farmName;
    this.farmRect = farmRect;

    return [];
  }

  TextPainter get textPainter => TextPainter(
        text: TextSpan(
          text: farmName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 64.0,
            backgroundColor: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
}
