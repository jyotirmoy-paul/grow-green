import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../l10n/l10n.dart';
import '../../../../../../../services/log/log.dart';
import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../widgets/button_animator.dart';
import '../../../../../../../widgets/dialog_container.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../utils/game_assets.dart';
import '../../../../../enums/agroforestry_type.dart';
import '../../../../../enums/farm_system_type.dart';
import '../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import '../../components/farm/asset/crop_asset.dart';
import '../../components/farm/asset/tree_asset.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/system/enum/growable.dart';
import '../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/enum/farm_state.dart';
import '../../components/farm/farm_controller.dart';
import '../../components/farm/model/content.dart';
import '../../components/farm/model/farm_content.dart';
import '../farm_menu/farm_menu_helper.dart';
import '../system_selector_menu/enum/component_id.dart';
import 'choose_component_dialog.dart';
import 'choose_maintenance/view/choose_maintenance_dialog.dart';
import 'widgets/menu_image.dart';
import 'widgets/menu_item_flip_skeleton.dart';
import 'widgets/sell_tree_widget.dart';

class ChooseComponentsDialog extends StatefulWidget {
  final FarmContent farmContent;
  final FarmController farmController;
  final bool isNotFunctioningFarm;
  final double soilHealthPercentage;

  /// components that are can be edited
  final List<ComponentId> editableComponents;

  ChooseComponentsDialog({
    super.key,
    required this.farmContent,
    required this.editableComponents,
    required this.farmController,
  })  : isNotFunctioningFarm = farmController.farmState == FarmState.notFunctioning,
        soilHealthPercentage = farmController.soilHealthPercentage;

  @override
  State<ChooseComponentsDialog> createState() => _ChooseComponentsDialogState();
}

class _ChooseComponentsDialogState extends State<ChooseComponentsDialog> {
  static const tag = '_ChooseComponentsDialogState';

  final children = <_ComponentsModel>[];

  late FarmContent _currentFarmContent;
  MoneyModel _totalCost = MoneyModel.zero();

  /// crop
  _ComponentsModel forCrop(Content cropContent) {
    final cropType = cropContent.type as CropType;
    final isCropEditable = widget.editableComponents.contains(ComponentId.crop);
    final cropCost = MoneyModel(value: CostCalculator.seedCostFromContent(cropContent: cropContent));

    if (isCropEditable) {
      _totalCost += cropCost;
    }

    return _ComponentsModel(
      headerText: context.l10n.crop,
      image: CropAsset.menuRepresentativeOf(cropType),
      footerText: '',
      componentId: ComponentId.crop,
      isComponentEditable: isCropEditable,
      footerButtonText: context.l10n.change,
      descriptionText:
          "${cropType.growableName.toUpperCase()}\n${cropContent.qty.readableFormat} | ${cropCost.formattedValue} ",
      color: AppColors.cropMenuCardBg,
    );
  }

  /// no crop
  _ComponentsModel noCrop() {
    return _ComponentsModel(
      headerText: context.l10n.noCrop,
      image: GameAssets.addSeeds,
      footerText: '',
      componentId: ComponentId.crop,
      isComponentEditable: widget.editableComponents.contains(ComponentId.crop),
      footerButtonText: context.l10n.add,
      color: AppColors.cropMenuCardBg,
    );
  }

  /// trees
  _ComponentsModel forTrees(Content treeContent) {
    final treeType = treeContent.type as TreeType;
    final treeCost = MoneyModel(value: CostCalculator.saplingCostFromContent(treeContent: treeContent));

    /// we will count trees in only in two cases
    /// 1. Either farm is non functional (this happens when we first time setup a farm system)
    /// 2. We come to this menu with no tree then have made a selection - so no tree initially
    final noTreesInitially = !widget.farmContent.hasTrees;
    final countTreeIn = widget.isNotFunctioningFarm || noTreesInitially;

    if (countTreeIn) {
      _totalCost += treeCost;
    }

    final qtyDescription =
        countTreeIn ? '${treeContent.qty.readableFormat} | ${treeCost.formattedValue}' : treeContent.qty.readableFormat;
    return _ComponentsModel(
      headerText: context.l10n.tree,
      image: TreeAsset.menuRepresentativeOf(treeType),
      footerText: "",
      componentId: ComponentId.trees,
      isComponentEditable: widget.editableComponents.contains(ComponentId.trees),
      footerButtonText: countTreeIn ? context.l10n.change : context.l10n.remove,
      buttonColor: countTreeIn ? null : Colors.red,
      descriptionText: "${treeType.growableName.toUpperCase()}\n$qtyDescription",
      color: AppColors.treeMenuCardBg,
    );
  }

  _ComponentsModel noTree() {
    return _ComponentsModel(
      headerText: context.l10n.noTree,
      image: GameAssets.addSapling,
      footerText: '',
      componentId: ComponentId.trees,
      isComponentEditable: widget.editableComponents.contains(ComponentId.trees),
      footerButtonText: context.l10n.add,
      buttonColor: Colors.green,
    );
  }

  void _calculateDataFor(FarmContent farmContent) {
    /// clearn up
    children.clear();
    _totalCost = MoneyModel.zero();

    final isAgroforestry = farmContent.systemType != FarmSystemType.monoculture;

    /// crop
    if (farmContent.hasCrop) {
      children.add(
        forCrop(farmContent.crop!),
      );
    } else {
      /// add no crop widget
      children.add(noCrop());
    }

    /// trees
    if (farmContent.hasTrees) {
      children.add(forTrees(farmContent.tree!));
    } else if (isAgroforestry) {
      /// if agroforestry system has no tree, add noTree
      children.add(noTree());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// calculate data for initial farm content
    _calculateDataFor(widget.farmContent);
    _currentFarmContent = widget.farmContent;
  }

  void processNewComponent({
    required ComponentId componentId,
    required int index,
  }) {
    switch (componentId) {
      case ComponentId.crop:
        final newCrop = CropType.values[index];

        /// process new crop selection
        _currentFarmContent = _currentFarmContent.copyWith(
          crop: FarmMenuHelper.getCropContent(
            cropType: newCrop,
            systemType: _currentFarmContent.systemType,
          ),
        );

        break;

      case ComponentId.trees:
        final tree = TreeType.values[index];

        /// process new tree selection
        _currentFarmContent = _currentFarmContent.copyWith(
          tree: FarmMenuHelper.getTreeContent(
            treeType: tree,
            systemType: _currentFarmContent.systemType,
          ),
        );

        break;

      case ComponentId.fertilizer:
        break;
      case ComponentId.agroforestryLayout:
        final agroforestrySystem = AgroforestryType.values[index];

        /// process new agroforestry system selection
        _currentFarmContent = _currentFarmContent.copyWith(
          systemType: agroforestrySystem,
        );

        break;

      default:
        break;
    }

    /// calculate all data for new farm content
    setState(() {
      _calculateDataFor(_currentFarmContent);
    });
  }

  bool isHidden = false;

  /// handle sell tree case
  void _sellTree() {
    Log.i('$tag: _sellTree invoked');

    Utils.showNonAnimatedDialog(
      barrierLabel: context.l10n.sellTreeDialog,
      context: context,
      builder: (context) {
        return DialogContainer(
          title: context.l10n.sellTree,
          dialogType: DialogType.medium,
          child: SellTreeWidget(farmController: widget.farmController),
        );
      },
    );
  }

  /// show notfication to user, about why an action is not allowed
  void nonEditableComponentTap(ComponentId componentId) {
    switch (componentId) {
      case ComponentId.crop:
        return;

      case ComponentId.trees:
        return;

      case ComponentId.fertilizer:
        return;

      case ComponentId.agroforestryLayout:
      case ComponentId.maintenance:
        return;
    }
  }

  /// this method is only allowed for items which can be edited
  void onComponentTap(ComponentId componentId) async {
    if (componentId == ComponentId.trees && widget.farmContent.hasTrees && !widget.isNotFunctioningFarm) {
      /// we came into this menu with a functional tree and this is not a non functioning farm, so sell tree is allowed
      return _sellTree();
    }

    setState(() {
      isHidden = true;
    });

    final newComponentIndex = await Utils.showNonAnimatedDialog(
      barrierLabel: context.l10n.chooseComponentsDialog,
      context: context,
      builder: (context) {
        return DialogContainer(
          dialogType: DialogType.large,
          title: () {
            switch (componentId) {
              case ComponentId.crop:
                return context.l10n.chooseCrop;

              case ComponentId.trees:
                return context.l10n.chooseTree;

              case ComponentId.fertilizer:
                return context.l10n.chooseFertilizer;

              case ComponentId.agroforestryLayout:
                return context.l10n.chooseAgroforestryLayout;

              default:
                throw Exception('$tag: onComponentTap($componentId) invoked with wrong componentId');
            }
          }(),
          child: ChooseComponentDialog(componentId: componentId),
        );
      },
    );

    if (mounted) {
      setState(() {
        isHidden = false;
      });
    }

    /// if dialog box was close, ignore
    if (newComponentIndex is! int) return;

    processNewComponent(
      componentId: componentId,
      index: newComponentIndex,
    );
  }

  void _onSelectTap() async {
    /// nothing is selected
    if (_totalCost.isZero()) {
      return NotificationHelper.nothingToBuy();
    }

    await Utils.showNonAnimatedDialog(
      barrierLabel: context.l10n.chooseComponentsDialog,
      context: context,
      builder: (context) {
        return DialogContainer(
          title: context.l10n.chooseMaintenance,
          dialogType: DialogType.large,
          child: ChooseMaintenanceDialog(
            farmContent: _currentFarmContent,
            farmController: widget.farmController,
            startingDebit: _totalCost,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isHidden) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /// body
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(20.s),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final model = children[index];

              return ButtonAnimator(
                onPressed: () {
                  if (model.isComponentEditable) return onComponentTap(model.componentId);
                  nonEditableComponentTap(model.componentId);
                },
                child: MenuItemFlipSkeleton(
                  width: 320.s,
                  bgColor: model.color ?? Colors.red.darken(0.3),
                  header: Center(
                    child: Text(
                      model.headerText,
                      style: TextStyles.s35,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  body: Column(
                    children: [
                      Gap(10.s),

                      /// image
                      MenuImage(
                        imageAssetPath: model.image,
                        dimension: 170.s,
                      ),

                      const Spacer(),

                      /// description
                      if (model.descriptionText != null)
                        Padding(
                          padding: EdgeInsets.only(top: 10.s, left: 2.s, right: 2.s),
                          child: Text(
                            model.descriptionText!,
                            style: TextStyles.s28,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                  footer: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.s, vertical: 12.s),
                    child: Center(
                      /// button
                      child: GameButton.text(
                        color: model.isComponentEditable ? (model.buttonColor ?? Colors.white12) : Colors.grey,
                        text: model.footerButtonText,
                        onTap: () {
                          if (model.isComponentEditable) return onComponentTap(model.componentId);
                          nonEditableComponentTap(model.componentId);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => Gap(20.s),
            itemCount: children.length,
          ),
        ),

        /// button
        Padding(
          padding: EdgeInsets.only(right: 16.s, bottom: 16.s),
          child: GameButton.textImage(
            key: ValueKey(_totalCost.formattedValue),
            text: context.l10n.continueFor(_totalCost.formattedValue),
            image: GameAssets.coin,
            bgColor: _totalCost.isZero() ? Colors.grey : Colors.green,
            onTap: _onSelectTap,
          ),
        ),
      ],
    );
  }
}

class _ComponentsModel {
  final String headerText;
  final String image;
  final String? descriptionText;
  final String footerText;
  final ComponentId componentId;
  final bool isComponentEditable;
  final String footerButtonText;
  final Color? color;
  final Color? buttonColor;

  _ComponentsModel({
    required this.headerText,
    required this.image,
    required this.footerText,
    required this.componentId,
    required this.isComponentEditable,
    required this.footerButtonText,
    this.descriptionText,
    this.color,
    this.buttonColor,
  });
}
