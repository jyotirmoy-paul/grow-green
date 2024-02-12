import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../system_selector_menu/model/component_selection_model.dart';
import '../../../../../enums/agroforestry_type.dart';
import '../../../../../models/farm_system.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/model/content.dart';
import '../../components/farm/model/fertilizer/fertilizer_type.dart';
import 'model/csm_item_model.dart';
import 'utils/triple_tween.dart';
import 'widget/component_item.dart';
import '../system_selector_menu/bloc/system_selector_menu_bloc.dart';
import '../../../../../../../utils/extensions/list_extensions.dart';

import '../../../../../grow_green_game.dart';
import '../system_selector_menu/enum/component_id.dart';

class ComponentSelectorMenu extends StatefulWidget {
  static const overlayName = 'component-selector-menu';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    return ComponentSelectorMenu(
      componentSelectionModel: game.gameController.overlayData.componentSelectionModel,
      game: game,
    );
  }

  final ComponentSelectionModel componentSelectionModel;
  final GrowGreenGame game;

  const ComponentSelectorMenu({
    super.key,
    required this.componentSelectionModel,
    required this.game,
  });

  @override
  State<ComponentSelectorMenu> createState() => _ComponentSelectorMenuState();
}

class _ComponentSelectorMenuState extends State<ComponentSelectorMenu> with SingleTickerProviderStateMixin {
  List<CsmItemModel> models = [];

  late ComponentId componentId;
  late int componentTappedIndex;

  /// populate children with options available for `componentId`
  void _populateChildren() {
    /// clear models
    models.clear();

    switch (componentId) {
      case ComponentId.crop:
        return models.addAll(
          CropType.values.map(
            (crop) {
              return CsmItemModel(name: crop.name, image: '');
            },
          ),
        );

      case ComponentId.trees:
        return models.addAll(
          TreeType.values.map(
            (tree) {
              return CsmItemModel(name: tree.name, image: '');
            },
          ),
        );

      case ComponentId.fertilizer:
        return models.addAll(
          FertilizerType.values.map(
            (fertilizer) {
              return CsmItemModel(name: fertilizer.name, image: '');
            },
          ),
        );

      case ComponentId.agroforestryLayout:
        return models.addAll(
          AgroforestryType.values.map(
            (agroforestry) {
              return CsmItemModel(name: agroforestry.name, image: '');
            },
          ),
        );

      case ComponentId.none:
        return;
    }
  }

  /// animation controllers
  late final AnimationController _animationController;

  /// animations
  late final Animation<double> _opacityAnimation;
  // late final Animation<double> _offsetAnimation;
  final List<Animation<double>> _offsetAnimations = [];

  /// TODO: fix the animation!
  void _initOffsetAnimations() {
    /// clear animations
    _offsetAnimations.clear();

    for (int i = models.length; i > 0; i--) {
      _offsetAnimations.add(
        TripleTween(
          begin: i * 50.0,
          end: 0.0,
          middle: -15.0,
          middlePoint: 0.7,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.linear,
          ),
        ),
      );
    }
  }

  void _initAnimationControllers() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _initOffsetAnimations();

    /// drive animation
    _animationController.forward();
  }

  void _componentSelectionListener() async {
    /// stop process if component id is none
    if (widget.componentSelectionModel.componentId == ComponentId.none) {
      return _closeMenu();
    }

    /// component selection model is updated
    await _animationController.reverse();

    if (mounted) {
      setState(() {
        /// update component id & tapped index
        componentId = widget.componentSelectionModel.componentId;
        componentTappedIndex = widget.componentSelectionModel.componentTappedIndex;

        /// rebuild child & animations
        _populateChildren();
        _initOffsetAnimations();
      });
    }

    _animationController.forward();
  }

  void _initComponentSelectionListener() {
    widget.componentSelectionModel.addListener(_componentSelectionListener);
  }

  void _initComponent() {
    componentId = widget.componentSelectionModel.componentId;
    componentTappedIndex = widget.componentSelectionModel.componentTappedIndex;
  }

  @override
  void initState() {
    super.initState();

    _initComponent();

    _populateChildren();
    _initAnimationControllers();

    _initComponentSelectionListener();
  }

  @override
  void dispose() {
    widget.componentSelectionModel.removeListener(_componentSelectionListener);

    super.dispose();
  }

  void _closeMenu() async {
    await _animationController.reverse();
    widget.game.overlays.remove(ComponentSelectorMenu.overlayName);
  }

  void _onChildTap(int index) {
    final systemSelectorMenuBloc = context.read<SystemSelectorMenuBloc>();

    switch (componentId) {
      case ComponentId.crop:
        final crop = CropType.values[index];

        /// TODO: quantity can be fetched from a static database with type
        systemSelectorMenuBloc.add(
          SystemSelectorMenuChooseCropsEvent(
            crop: Content<CropType>(
              type: crop,
              quantity: 100,
            ),
          ),
        );
        break;

      case ComponentId.trees:
        final treeTappedIndex = componentTappedIndex;
        final tree = TreeType.values[index];

        final treesList =
            ((systemSelectorMenuBloc.state as SystemSelectorMenuChooseComponent).farmSystem as AgroforestrySystem)
                .trees;
        final newTreeList = List<Content<TreeType>>.from(treesList);

        /// TODO: fetch quantity required from a static database
        newTreeList[treeTappedIndex] = Content<TreeType>(
          type: tree,
          quantity: 100,
        );

        systemSelectorMenuBloc.add(
          SystemSelectorMenuChooseTreesEvent(
            trees: newTreeList,
          ),
        );
        break;

      case ComponentId.fertilizer:
        final fertilizer = FertilizerType.values[index];

        /// TODO: quantity can be fetched from a static database with type
        systemSelectorMenuBloc.add(
          SystemSelectorMenuChooseFertilizerEvent(
            fertilizer: Content<FertilizerType>(
              type: fertilizer,
              quantity: 100,
            ),
          ),
        );
        break;

      case ComponentId.agroforestryLayout:
        final agroforestrySystem = AgroforestryType.values[index];
        systemSelectorMenuBloc.add(
          SystemSelectorMenuChooseAgroforestrySystemEvent(
            agroforestryType: agroforestrySystem,
          ),
        );
        break;

      case ComponentId.none:
        break;
    }

    /// close
    _closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.0, 0.6),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// title
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Choose your ${componentId.name}',
                style: const TextStyle(
                  fontSize: 32.0,
                ),
              ),
            ),

            const Gap(32.0),

            /// children
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(
                models.length,
                (index) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0.0, max(_offsetAnimations[index].value, -28)),
                        child: Opacity(
                          opacity: _opacityAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: ComponentItem(
                      itemModel: models[index],
                      onTap: () => _onChildTap(index),
                    ),
                  );
                },
              ).addSeparator(const Gap(32.0)),
            ),
          ],
        ),
      ),
    );
  }
}
