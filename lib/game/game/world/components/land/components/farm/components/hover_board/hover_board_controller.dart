import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/game_extensions.dart';
import '../../farm.dart';
import 'components/hover_board_item.dart';
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

  /// TODO: Need to handle multiple hoverboard effectively
  void addHoverBoard({
    required HoverBoardType type,
    required HoverBoardModel model,
    required VoidCallback onTap,
  }) {
    Log.i('$tag: invoked addHoverBoard(type: $type, model: $model)');

    if (_hoverBoards.containsKey(type)) {
      Log.w('$tag: existing hoverboard of type $type will be replaced!');

      final existingItem = _hoverBoards.remove(type)!;
      remove(existingItem);
    }

    final item = HoverBoardItem(
      model: model,
      farmCenter: farmCenter,
      onTap: onTap,
    );

    /// add
    add(item);
    _hoverBoards[type] = item;
  }

  void removeHoverBoard({
    required HoverBoardType type,
  }) {
    Log.i('$tag: invoked removeHoverBoard(type: $type)');

    if (!_hoverBoards.containsKey(type)) {
      throw Exception('$tag: cannot remove an inactive hoverboard, $type is not active');
    }

    final item = _hoverBoards.remove(type)!;
    remove(item);
  }
}
