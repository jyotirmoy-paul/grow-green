import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../grow_green_game.dart';

class Inventory extends StatelessWidget {
  static const _height = 140.0;

  static const overlayName = 'inventory';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: -_height, end: 0.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (_, animation, child) {
        return Positioned(
          bottom: animation,
          left: 0,
          right: 0,
          child: child!,
        );
      },
      child: const Inventory(),
    );
  }

  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        height: _height,
        child: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// heading
              Text(
                'Inventory',
                style: TextStyle(fontSize: 32.0),
              ),

              Gap(24.0),

              /// body
            ],
          ),
        ),
      ),
    );
  }
}
