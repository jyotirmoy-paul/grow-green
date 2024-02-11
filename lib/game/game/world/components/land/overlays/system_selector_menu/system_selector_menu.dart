import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/farm/enum/farm_state.dart';
import 'bloc/system_selector_menu_bloc.dart';
import 'widgets/menu_child_widget.dart';
import 'widgets/menu_parent_widget.dart';
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
  late double _parentWidgetDiameter;
  late double _childWidgetDiameter;
  late double _childFinalRadius;
  late Offset _center;

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
      duration: const Duration(milliseconds: 280),
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
    _radialAnimationController.forward();
  }

  void _onClose() async {
    /// reset radial animation
    _radialAnimationController.reset();

    /// animate out
    await _appearanceAnimationController.animateTo(0, duration: const Duration(milliseconds: 100));

    /// close overlay
    widget.game.overlays.remove(SystemSelectorMenu.overlayName);
  }

  void _init() {
    final farmState = widget.farm.farmController.currentFarmState;
    final systemSelectorMenuBloc = context.read<SystemSelectorMenuBloc>();

    systemSelectorMenuBloc.onCloseMenu = _onClose;

    switch (farmState) {
      case FarmState.notBought:
        throw Exception('$tag: _init(): System Selector Menu opened in invalid farm state: $farmState');

      case FarmState.notInitialized:
        return systemSelectorMenuBloc.add(const SystemSelectorMenuChildTapEvent(tappedIndex: 0));

      case FarmState.functioning:
        return systemSelectorMenuBloc.add(const SystemSelectorMenuViewComponentsEvent(editable: false));

      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
      case FarmState.notFunctioning:
        return systemSelectorMenuBloc.add(const SystemSelectorMenuViewComponentsEvent(editable: true));
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
    _radialAnimationController.dispose();

    super.dispose();
  }

  void _determineDimensions() {
    _size = MediaQuery.of(context).size;

    final shortestSize = _size.shortestSide;
    final availablesize = shortestSize * 0.80;

    _parentWidgetDiameter = availablesize * 0.4;
    _childWidgetDiameter = availablesize * 0.23;

    _childFinalRadius = _parentWidgetDiameter;

    _center = Offset(
      (_size.width / 2) - _childWidgetDiameter / 2,
      (_size.height / 2) - _childWidgetDiameter / 2,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _determineDimensions();
  }

  void _onBackTap() async {
    await _radialAnimationController.reverse();

    if (mounted) {
      context.read<SystemSelectorMenuBloc>().add(const SystemSelectorMenuBackEvent());
    }

    _radialAnimationController.forward();
  }

  void _onContinue() async {
    /// close children
    await _radialAnimationController.reverse();

    if (!mounted) return;

    context.read<SystemSelectorMenuBloc>().add(const SystemSelectorMenuContinueEvent());

    /// open children
    await _radialAnimationController.forward();
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

  void _onChildTap(int index) {
    context.read<SystemSelectorMenuBloc>().add(
          SystemSelectorMenuChildTapEvent(tappedIndex: index),
        );
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

          // small circle positioned according to animation
          Positioned.fill(
            child: BlocBuilder<SystemSelectorMenuBloc, SystemSelectorMenuState>(
              builder: (context, state) {
                final childModels = state.childModels;
                final n = childModels.length;

                return AnimatedBuilder(
                  animation: _radialAnimationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Stack(
                        children: List<Widget>.generate(
                          n,
                          (index) {
                            final position = _calculateAnimatedPosition(
                              animationValue: _radialAnimation.value,
                              itemCount: n,
                              itemIndex: index,
                              finalRadius: _childFinalRadius,
                              center: _center,
                            );

                            int selectedIndex = -1;

                            if (state is SystemSelectorMenuChooseSystem) {
                              selectedIndex = state.selectedIndex;
                            }

                            final isSelected = index == selectedIndex;

                            return Positioned(
                              left: position.dx,
                              top: position.dy,
                              width: _childWidgetDiameter,
                              height: _childWidgetDiameter,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Transform.scale(
                                    scale: 1.3,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      curve: Curves.easeOut,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected ? Colors.white : Colors.transparent,
                                          width: 5.0,
                                          strokeAlign: BorderSide.strokeAlignOutside,
                                        ),
                                        shape: BoxShape.circle,
                                        // shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  AnimatedScale(
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 280),
                                    scale: isSelected ? 1.2 : 1.0,
                                    child: MenuChildWidget(
                                      childModel: childModels[index],
                                      diameter: _childWidgetDiameter,
                                      onTap: () => _onChildTap(index),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // large central circle
          Align(
            child: BlocBuilder<SystemSelectorMenuBloc, SystemSelectorMenuState>(
              builder: (context, state) {
                return MenuParentWidget(
                  parentModel: state.parentModel,
                  diameter: _parentWidgetDiameter,
                );
              },
            ),
          ),

          /// back button
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(32.0),
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: IconButton(
                onPressed: _onBackTap,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
            ),
          ),

          /// continue button
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(32.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: InkWell(
                onTap: _onContinue,
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 32.0, letterSpacing: 3.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
