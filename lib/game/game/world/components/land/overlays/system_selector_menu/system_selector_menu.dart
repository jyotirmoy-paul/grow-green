import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/enum/farm_state.dart';
import 'package:growgreen/game/game/world/components/land/overlays/system_selector_menu/bloc/system_selector_menu_bloc.dart';
import '../../components/farm/farm.dart';

import '../../../../../../../screens/game_screen/cubit/game_overlay_cubit.dart';
import '../../../../../grow_green_game.dart';

class SystemSelectorMenu extends StatefulWidget {
  static const overlayName = 'system-selector-menu';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    final state = context.read<GameOverlayCubit>().state;
    if (state is! GameOverlaySystemSelector) {
      throw Exception('System Selector Menu builder was invoked with improper game overlay state: $state!');
    }

    return SystemSelectorMenu(game: game, farm: state.farm);
  }

  final Farm farm;
  final Game game;

  const SystemSelectorMenu({
    super.key,
    required this.game,
    required this.farm,
  });

  @override
  State<SystemSelectorMenu> createState() => _SystemSelectorMenuState();
}

class _SystemSelectorMenuState extends State<SystemSelectorMenu> with TickerProviderStateMixin {
  static const tag = '_SystemSelectorMenuState';

  static const _centerDiameter = 200.0;
  static const _childDiameter = _centerDiameter / 2;

  late AnimationController _appearanceAnimationController;
  late AnimationController _radialAnimationController;

  /// appearance animations
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _opacityAnimation;

  /// radial animations
  late Animation<double> _radialAnimation;
  late Animation<double> _rotationAnimation;

  late Size _size;

  int noOfChild = 4;

  void _initAnimationControllers() {
    /// appearance animation

    _appearanceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 190),
      vsync: this,
    );

    // background color
    _backgroundColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.black.withOpacity(0.3),
    ).animate(_appearanceAnimationController);

    // background blur
    _blurAnimation = Tween<double>(
      begin: 0.0,
      end: 5.0,
    ).animate(_appearanceAnimationController);

    // background opacity
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_appearanceAnimationController);

    /// radial animation
    _radialAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _radialAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _radialAnimationController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: -math.pi / 2, end: 0.0).animate(
      CurvedAnimation(parent: _radialAnimationController, curve: Curves.easeOut),
    );
  }

  void _doAnimations() async {
    _appearanceAnimationController.forward();
  }

  void _init() {
    final farmState = widget.farm.farmController.currentFarmState;
    final systemSelectorMenuBloc = context.read<SystemSelectorMenuBloc>();

    switch (farmState) {
      case FarmState.notBought:
        throw Exception('$tag: _init(): System Selector Menu opened in invalid farm state: $farmState');

      case FarmState.notInitialized:
        return systemSelectorMenuBloc.add(SystemSelectorMenuChooseSystemEvent());

      case FarmState.functioning:
        return systemSelectorMenuBloc.add(SystemSelectorMenuViewComponentsEvent());

      case FarmState.functioningOnlyTrees:
        return;
      case FarmState.functioningOnlyCrops:
        return;
      case FarmState.notFunctioning:
        return;
    }
  }

  @override
  void initState() {
    super.initState();

    _initAnimationControllers();
    _doAnimations();

    _init();
  }

  @override
  void dispose() {
    /// dispose animation controllers
    _appearanceAnimationController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _size = MediaQuery.of(context).size;
  }

  void _onClose() async {
    await _radialAnimationController.animateTo(0, duration: const Duration(milliseconds: 200));
    await _appearanceAnimationController.animateTo(0, duration: const Duration(milliseconds: 100));
    widget.game.overlays.remove(SystemSelectorMenu.overlayName);
  }

  Offset _calculateAnimatedPosition({
    required double animationValue,
    required int itemCount,
    required int itemIndex,
    required double finalRadius,
    required Offset center,
  }) {
    // Calculate the angle for the item.
    final double angleStep = (2 * math.pi) / itemCount;
    final double angle = angleStep * itemIndex;

    // Calculate the current radius. It starts from 0 and expands to finalRadius as the animation progresses.
    final double currentRadius = finalRadius * animationValue;

    // Calculate the current position using the current radius and the angle.
    final double x = center.dx + currentRadius * math.cos(angle);
    final double y = center.dy + currentRadius * math.sin(angle);

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appearanceAnimationController,
      builder: (context, child) {
        return Material(
          color: _backgroundColorAnimation.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _blurAnimation.value, sigmaY: _blurAnimation.value),
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // farm name
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                widget.farm.farmName,
                style: const TextStyle(color: Colors.white, fontSize: 32.0),
              ),
            ),
          ),

          // close button
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(32.0),
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: IconButton(
                onPressed: _onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
            ),
          ),

          // small circle positioned according to animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _radialAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Stack(
                    children: List<Widget>.generate(
                      noOfChild,
                      (index) {
                        final position = _calculateAnimatedPosition(
                          animationValue: _radialAnimation.value,
                          itemCount: noOfChild,
                          itemIndex: index,
                          finalRadius: _centerDiameter,
                          center: Offset(
                            (_size.width / 2) - _childDiameter / 2,
                            (_size.height / 2) - _childDiameter / 2,
                          ),
                        );
                        return Positioned(
                          left: position.dx,
                          top: position.dy,
                          child: Container(
                            width: _childDiameter,
                            height: _childDiameter,
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // large central circle
          Align(
            child: Container(
              width: _centerDiameter,
              height: _centerDiameter,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
