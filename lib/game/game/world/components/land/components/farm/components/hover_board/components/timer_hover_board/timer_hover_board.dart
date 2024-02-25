import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../../services/log/log.dart';
import '../../../../../../../../../../../utils/constants.dart';
import '../../../../../../../../../grow_green_game.dart';
import '../../../../../../../../../services/game_services/time/time_aware.dart';
import '../../../../farm.dart';
import '../../models/hover_board_model.dart';
import '../hover_board_item.dart';
import 'progress_bar.dart';

class TimerHoverBoard extends HoverBoardItem with HasGameRef<GrowGreenGame>, TimeAware {
  final TimerHoverBoardModel model;
  final Farm farm;
  final Vector2 farmCenter;
  final String tag;

  TimerHoverBoard({
    required this.model,
    required this.farm,
    required this.farmCenter,
  }) : tag = 'TimerHoverBoard[${farm.farmId}]';

  ProgressBar? _progressBar;
  bool _isDone = false;

  double getWaitPercentage(DateTime currentDateTime) {
    final daysLeft = model.futureDateTime.difference(currentDateTime).inDays;
    return 1 - (daysLeft / model.totalWaitDays);
  }

  /// FIXME: remove duplicate method
  TextPaint _getPaint() {
    return TextPaint(
      style: const TextStyle(
        fontFamily: kFontFamily,
        fontSize: 24.0,
        color: Colors.white,
        shadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(-2.0, -2.0),
            spreadRadius: 2.0,
          )
        ],
      ),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    final textComponent = TextComponent(
      text: model.text,
      textRenderer: _getPaint(),
      anchor: Anchor.bottomCenter,
      position: farmCenter.translated(0, -60.0),
    );

    final imageComponent = SpriteComponent(
      sprite: Sprite(await game.images.load(model.image)),
      size: Vector2.all(40.0),
      anchor: Anchor.bottomCenter,
      position: farmCenter.translated(0, -16.0),
    );

    /// create progress bar
    _progressBar = ProgressBar(
      progressFactor: getWaitPercentage(model.startDateTime),
    )..position = farmCenter;

    /// add all components
    addAll([
      textComponent,
      imageComponent,
      _progressBar!,
    ]);
  }

  void onDone() {
    _isDone = true;

    /// once progress factor crosses boundary, remove widget from parent
    removeFromParent();
  }

  @override
  void updateData(HoverBoardModel model) {}

  @override
  void onTimeChange(DateTime dateTime) {
    Log.d('$tag: onTimeChange: $dateTime');

    if (_isDone) return;

    final progressFactor = getWaitPercentage(dateTime);

    _progressBar?.progressFactor = progressFactor;

    if (progressFactor >= 1.0) {
      onDone();
    }
  }
}
