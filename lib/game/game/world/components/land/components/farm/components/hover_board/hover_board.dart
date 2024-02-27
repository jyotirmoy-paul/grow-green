import 'dart:async';

import 'package:flame/components.dart';

import '../../farm.dart';
import 'hover_board_controller.dart';

class HoverBoard extends PositionComponent {
  final HoverBoardController hoverBoardController;
  final Farm farm;

  HoverBoard({
    required this.farm,
  }) : hoverBoardController = HoverBoardController(
          farm: farm,
        );

  @override
  FutureOr<void> onLoad() async {
    final components = await hoverBoardController.initialize(
      add: add,
      remove: remove,
    );

    addAll(components);
  }
}
