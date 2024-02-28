import 'package:flutter/material.dart';

import 'farm_menu_model.dart';

class AnimatableFarmMenuModel {
  final AnimationController controller;
  final Animation<Offset> offsetAnimation;
  final FarmMenuModel model;

  AnimatableFarmMenuModel({
    required this.model,
    required this.controller,
    required this.offsetAnimation,
  });
}
