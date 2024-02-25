import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../farm.dart';
import 'components/basic_hover_board.dart';
import 'components/hover_board_item.dart';
import 'components/timer_hover_board/timer_hover_board.dart';
import 'enum/hover_board_type.dart';
import 'models/hover_board_model.dart';

class HoverBoardController {
  static const tag = 'HoverBoardController';

  final Farm farm;
  final Vector2 farmCenter;

  HoverBoardController({
    required this.farm,
  }) : farmCenter = farm.size.half();

  late void Function(Component) add;
  late void Function(Component) remove;

  final Map<HoverBoardType, HoverBoardItem> _hoverBoards = {};
  bool get isShowing => _hoverBoards.isNotEmpty;

  Future<List<Component>> initialize({
    required void Function(Component) add,
    required void Function(Component) remove,
  }) async {
    this.add = add;
    this.remove = remove;

    return const [];
  }

  void addHoverBoard({
    required HoverBoardType type,
    required HoverBoardModel model,
    required VoidCallback onTap,
  }) {
    Log.i('$tag: invoked addHoverBoard(type: $type, model: $model)');

    /// check if a hover board of type already exists
    if (_hoverBoards.containsKey(type)) {
      final hoverBoard = _hoverBoards[type];

      if (hoverBoard!.isMounted) {
        Log.d('$tag: $type hover board already exist, update method will be invoked!');
        _hoverBoards[type]!.updateData(model);
        return;
      } else {
        _hoverBoards.remove(type);
      }
    }

    /// if not, create a branch new hover board and add it
    final hoverBoardModel = model;
    late HoverBoardItem hoverBoardItem;

    if (hoverBoardModel is BasicHoverBoardModel) {
      /// basic hover board
      hoverBoardItem = BasicHoverBoard(
        model: hoverBoardModel,
        farmCenter: farmCenter,
        onTap: onTap,
        farm: farm,
      );
    } else if (hoverBoardModel is TimerHoverBoardModel) {
      /// timer hover board
      hoverBoardItem = TimerHoverBoard(
        model: hoverBoardModel,
        farm: farm,
        farmCenter: farmCenter,
      );
    }

    /// add the hoverboard item
    add(hoverBoardItem);
    _hoverBoards[type] = hoverBoardItem;
  }
}
