import 'package:flame/components.dart';

import '../models/hover_board_model.dart';

abstract class HoverBoardItem extends PositionComponent {
  void updateData(HoverBoardModel model);
}
