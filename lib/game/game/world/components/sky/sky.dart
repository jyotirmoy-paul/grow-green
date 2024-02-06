import 'dart:async';

import 'package:flame/components.dart';

import 'sky_controller.dart';

class Sky extends PositionComponent {
  final skyController = SkyController();

  @override
  FutureOr<void> onLoad() async {
    final components = await skyController.initialize();
    addAll(components);
  }
}
