import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../grow_green_game.dart';
import '../../../../../../../../../services/game_services/time/time_aware.dart';
import '../../../../../../../../../services/game_services/time/time_service.dart';
import '../../../../farm.dart';
import '../../models/hover_board_model.dart';
import '../hover_board_item.dart';
import '../stylized_text_component/stylized_text_component.dart';
import 'progress_bar.dart';
import 'rounded_rectangle_component.dart';

class TimerHoverBoard extends HoverBoardItem with HasGameRef<GrowGreenGame>, TimeAware {
  static const imageScaleFactor = 1.28;

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
  StylizedTextComponent? _textComponent;
  bool _isDone = false;

  int _daysLeft = 0;
  String get _formattedDaysLeft => '${_daysLeft + 1} d';

  double getWaitPercentage(DateTime currentDateTime) {
    _daysLeft = model.futureDateTime.difference(currentDateTime).inDays;
    return 1 - (_daysLeft / model.totalWaitDays);
  }

  @override
  FutureOr<void> onLoad() async {
    final progressFactor = getWaitPercentage(TimeService().currentDateTime);

    _textComponent = StylizedTextComponent(
      text: _formattedDaysLeft,
    )
      ..anchor = Anchor.bottomCenter
      ..position = farmCenter;

    final imageComponent = SpriteComponent(
      sprite: Sprite(await game.images.load(model.image)),
      size: Vector2.all(35.0),
      anchor: Anchor.centerRight,
      position: farmCenter.translated(-60.0, 0.0),
    );

    final imageBackground = RoundedRectangleComponent(
      borderRadius: 4.0,
      color: Colors.black.withOpacity(0.3),
      position: imageComponent.position.translated(
        -imageComponent.width / 2,
        0,
      ),
      size: imageComponent.size,
    )
      ..anchor = Anchor.center
      ..scale = Vector2.all(imageScaleFactor);

    /// create progress bar
    _progressBar = ProgressBar(progressFactor: progressFactor, swapMinMaxColor: model.swapMinMaxColor)
      ..anchor = Anchor.center
      ..position = farmCenter;

    final descriptionTextComponent = StylizedTextComponent(text: model.text)
      ..anchor = Anchor.topCenter
      ..position = farmCenter.translated(0, imageComponent.height / 2);

    /// add all components
    addAll([
      imageBackground,
      imageComponent,
      _progressBar!,
      _textComponent!,
      descriptionTextComponent,
    ]);

    return super.onLoad();
  }

  void onDone() async {
    _isDone = true;

    await Future.delayed(Duration(milliseconds: 1000 ~/ TimeService().timePace));

    /// once progress factor crosses boundary, remove widget from parent
    removeFromParent();
  }

  @override
  void updateData(HoverBoardModel model) {}

  @override
  void onTimeChange(DateTime dateTime) {
    if (_isDone) return;

    final progressFactor = getWaitPercentage(dateTime);

    /// update
    _progressBar?.progressFactor = progressFactor;
    _textComponent?.updateText(_formattedDaysLeft);

    if (_daysLeft <= 0) {
      onDone();
    }
  }
}
