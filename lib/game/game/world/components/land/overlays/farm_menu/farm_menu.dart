import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/list_extensions.dart';
import '../../../../../grow_green_game.dart';
import '../../components/farm/farm.dart';
import '../system_selector_menu/model/farm_notifier.dart';
import 'enum/farm_menu_option.dart';
import 'model/animation_object.dart';
import 'model/farm_menu_model.dart';
import 'model/three_point_offset_tween.dart';

/// TODO: Language

class FarmMenu extends StatefulWidget {
  static const overlayName = 'farm-menu';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    return FarmMenu(
      game: game,
      farmNotifier: game.gameController.overlayData.farmNotifier,
    );
  }

  final FarmNotifier farmNotifier;
  final GrowGreenGame game;

  const FarmMenu({
    super.key,
    required this.game,
    required this.farmNotifier,
  });

  @override
  State<FarmMenu> createState() => _FarmMenuState();
}

class _FarmMenuState extends State<FarmMenu> with TickerProviderStateMixin {
  static const tag = '_FarmMenuState';

  late AnimationController _opacityAnimationController;
  late Animation<double> _opacityAnimation;
  final List<AnimatableFarmMenuModel> _farmModels = [];
  Farm? _currentFarm;

  Future<void> _doAnimation({bool reverse = false}) async {
    final futures = <Future>[];

    /// child animations
    for (final animation in _farmModels) {
      if (reverse) {
        futures.add(animation.controller.reverse());
      } else {
        futures.add(animation.controller.forward());
      }
    }

    futures.clear();

    /// opacity animation
    if (reverse) {
      futures.add(_opacityAnimationController.reverse());
    } else {
      futures.add(_opacityAnimationController.forward());
    }

    await Future.wait(futures);
  }

  Future<void> _reverseAnimation() async {
    return _doAnimation(reverse: true);
  }

  Future<void> _forwardAnimation() async {
    return _doAnimation();
  }

  void _closeMenu() async {
    await _reverseAnimation();
    widget.game.overlays.remove(FarmMenu.overlayName);
  }

  void _onFarmChange() async {
    final newFarm = widget.farmNotifier.farm;

    if (_currentFarm == newFarm) return;
    _currentFarm = newFarm;

    /// close menu if no farm is selected
    if (newFarm == null) {
      return _closeMenu();
    }

    /// else, a new farm is selected, let's handle that
    await _reverseAnimation();

    /// process new farm selection
    if (mounted) {
      setState(() {
        _populateNewChildren();
      });

      await _forwardAnimation();
    }
  }

  /// listens for changes in farmNotifier
  void _initListener() {
    widget.farmNotifier.addListener(_onFarmChange);
  }

  void _clearOldAnimationControllers() {
    /// dispose existing animation controllers
    for (final models in _farmModels) {
      models.controller.dispose();
    }

    /// clear the list
    _farmModels.clear();
  }

  void _initAnimationControllers(List<FarmMenuModel> farmModels) {
    _clearOldAnimationControllers();

    const animationDurationInMs = 200;
    const gapDurationInMs = 80;
    const offsetGap = 30.0;
    const jump = -20.0;

    /// offset animation
    for (int i = 0; i < farmModels.length; i++) {
      final ithForwardDurationInMs = animationDurationInMs + gapDurationInMs * (farmModels.length - 1 - i);
      final ithReverseDurationInMs = animationDurationInMs + gapDurationInMs * (i + 1);

      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: ithForwardDurationInMs),
        reverseDuration: Duration(milliseconds: ithReverseDurationInMs),
      );

      final offsetTween = ThreePointOffsetTween(
        x: Offset(0.0, (farmModels.length - i) * offsetGap),
        i: const Offset(0.0, jump),
        y: Offset.zero,
        midPoint: 0.8,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.linear,
          reverseCurve: Curves.linear,
        ),
      );

      _farmModels.add(
        AnimatableFarmMenuModel(
          model: farmModels[i],
          controller: controller,
          offsetAnimation: offsetTween,
        ),
      );
    }

    _opacityAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: animationDurationInMs),
      reverseDuration: const Duration(milliseconds: animationDurationInMs),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _opacityAnimationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  List<FarmMenuModel> _getChildren() {
    final models = <FarmMenuModel>[];

    for (int i = 0; i < 3; i++) {
      models.add(
        FarmMenuModel(
          option: FarmMenuOption.buyFarm,
          bgColor: Colors.red,
          image: '',
          data: FarmMenuData(
            data: 'Data: $i',
            image: '',
          ),
        ),
      );
    }

    return models;
  }

  void _populateNewChildren() {
    _initAnimationControllers(_getChildren());
  }

  /// populates children & initializes animation
  void _init() {
    _currentFarm = widget.farmNotifier.farm;
    assert(_currentFarm != null, '$tag: Farm Menu invoked with null farm!');

    _populateNewChildren();
    _forwardAnimation();
    _initListener();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    widget.farmNotifier.removeListener(_onFarmChange);

    for (final model in _farmModels) {
      model.controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.0, 0.7),
      child: Material(
        type: MaterialType.transparency,
        child: AnimatedBuilder(
          animation: _opacityAnimationController,
          builder: (_, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// title
              Text('Hi there, how are you doing!: ${_currentFarm?.farmId}'),

              const Gap(32.0),

              /// children
              Row(
                mainAxisSize: MainAxisSize.min,
                children: _farmModels
                    .map(
                      (fm) => AnimatedBuilder(
                        animation: fm.controller,
                        builder: (_, child) {
                          return Transform.translate(
                            offset: fm.offsetAnimation.value,
                            child: child,
                          );
                        },
                        child: Container(
                          color: Colors.red,
                          height: 100,
                          width: 100,
                          child: Text(fm.model.option.name + '\n ${fm.model.data?.data}'),
                        ),
                      ),
                    )
                    .addSeparator(const Gap(32.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
