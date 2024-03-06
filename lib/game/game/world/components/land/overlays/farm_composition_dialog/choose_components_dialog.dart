import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../../services/log/log.dart';
import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../widgets/button_animator.dart';
import '../../../../../../../widgets/dialog_container.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../../utils/game_icons.dart';
import '../../../../../../utils/game_images.dart';
import '../../../../../enums/agroforestry_type.dart';
import '../../../../../enums/farm_system_type.dart';
import '../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import '../../components/farm/asset/crop_asset.dart';
import '../../components/farm/asset/tree_asset.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/enum/farm_state.dart';
import '../../components/farm/farm_controller.dart';
import '../../components/farm/model/content.dart';
import '../../components/farm/model/farm_content.dart';
import '../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../farm_menu/farm_menu_helper.dart';
import '../system_selector_menu/enum/component_id.dart';
import 'choose_component_dialog.dart';
import 'widgets/menu_item_flip_skeleton.dart';
import 'widgets/sell_tree_widget.dart';
import 'widgets/system_item_widget.dart';

/// TODO: Language
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

  static const kChange = "CHANGE";
  static const kAdd = "ADD";
  static const kRemove = "REMOVE";

  /// crop
  _ComponentsModel forCrop(Content cropContent) {
    final cropType = cropContent.type as CropType;
    final isCropEditable = widget.editableComponents.contains(ComponentId.crop);
    final cropCost = MoneyModel(value: CostCalculator.seedCostFromContent(cropContent: cropContent));

    if (isCropEditable) {
      _totalCost += cropCost;
    }

    return _ComponentsModel(
      headerText: 'Crop',
      image: CropAsset.menuRepresentativeOf(cropType),
      footerText: '',
      componentId: ComponentId.crop,
      isComponentEditable: isCropEditable,
      footerButtonText: kChange,
      descriptionText:
          "${cropType.name.toUpperCase()}\n${cropContent.qty.readableFormat} | ₹ ${cropCost.formattedValue} ",
      color: AppColors.kCropMenuCardBg,
    );
  }

  /// no crop
  _ComponentsModel noCrop() {
    return _ComponentsModel(
      headerText: 'No Crop',
      image: GameImages.noCrop,
      footerText: '',
      componentId: ComponentId.crop,
      isComponentEditable: widget.editableComponents.contains(ComponentId.crop),
      footerButtonText: kAdd,
      color: AppColors.kCropMenuCardBg,
    );
  }

  /// trees
  List<_ComponentsModel> forTrees(List<Content> treeContents) {
    return treeContents.map(
      (treeContent) {
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

        final qtyDescription = countTreeIn
            ? '${treeContent.qty.readableFormat} | ₹ ${treeCost.formattedValue}'
            : treeContent.qty.readableFormat;
        return _ComponentsModel(
          headerText: 'Tree',
          image: TreeAsset.menuRepresentativeOf(treeType),
          footerText: "",
          componentId: ComponentId.trees,
          isComponentEditable: widget.editableComponents.contains(ComponentId.trees),
          footerButtonText: countTreeIn ? kChange : kRemove,
          buttonColor: countTreeIn ? null : Colors.red,
          descriptionText: "${treeType.name.toUpperCase()}\n$qtyDescription",
          color: AppColors.kTreeMenuCardBg,
        );
      },
    ).toList();
  }

  _ComponentsModel noTree() {
    return _ComponentsModel(
      headerText: 'No Tree',
      image: GameImages.noTree,
      footerText: '',
      componentId: ComponentId.trees,
      isComponentEditable: widget.editableComponents.contains(ComponentId.trees),
      footerButtonText: kAdd,
      buttonColor: Colors.green,
    );
  }

  /// fertilizer
  _ComponentsModel forFertilizer(Content fertilizerContent) {
    final fertilizerType = fertilizerContent.type as FertilizerType;
    final fertilizerCost = MoneyModel(
      value: CostCalculator.fertilizerCostFromContent(fertilizerContent: fertilizerContent),
    );

    _totalCost += fertilizerCost;

    return _ComponentsModel(
      headerText: 'Fertilizer',
      image: fertilizerType == FertilizerType.chemical ? GameImages.chemicalFertilizer : GameImages.organicFertilizer,
      footerText: fertilizerType.name.toUpperCase(),
      componentId: ComponentId.fertilizer,
      isComponentEditable: widget.editableComponents.contains(ComponentId.fertilizer),
      footerButtonText: kChange,
      descriptionText: '${fertilizerContent.qty.readableFormat} | ₹ ${fertilizerCost.formattedValue}',
      color: AppColors.kFertilizerMenuCardBg,
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
      children.addAll(forTrees(farmContent.trees!));
    } else if (isAgroforestry) {
      /// if agroforestry system has no tree, add noTree
      children.add(noTree());
    }

    /// fertilizer
    if (farmContent.fertilizer != null) {
      children.add(forFertilizer(farmContent.fertilizer!));
    }
  }

  @override
  void initState() {
    super.initState();

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
          trees: [
            FarmMenuHelper.getTreeContent(
              treeType: tree,
              systemType: _currentFarmContent.systemType,
            ),
          ],
        );

        break;

      case ComponentId.fertilizer:
        final fertilizer = FertilizerType.values[index];

        /// process new fertilizer selection
        _currentFarmContent = _currentFarmContent.copyWith(
          fertilizer: FarmMenuHelper.getFertilizerContent(
            fertilizerType: fertilizer,
            systemType: _currentFarmContent.systemType,
            soilHealthPercentage: widget.soilHealthPercentage,
            cropType: _currentFarmContent.crop!.type as CropType,
          ),
        );

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
      barrierLabel: 'Sell tree dialog',
      context: context,
      builder: (context) {
        return DialogContainer(
          title: 'Sell tree?',
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
        return NotificationHelper.agroforestrySystemTapNotAllowed();
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
      barrierLabel: 'Choose component dialog',
      context: context,
      builder: (context) {
        return DialogContainer(
          dialogType: DialogType.large,
          title: () {
            switch (componentId) {
              case ComponentId.crop:
                return 'Choose Crop';

              case ComponentId.trees:
                return 'Choose tree';

              case ComponentId.fertilizer:
                return 'Choose fertilizer';

              case ComponentId.agroforestryLayout:
                return 'Choose Agroforestry layout';

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

  void _onPurchaseTap() {
    /// nothing is selected
    if (_totalCost.isZero()) {
      return NotificationHelper.nothingToBuy();
    }

    FarmMenuHelper.purchaseFarmContents(
      farmController: widget.farmController,
      farmContent: _currentFarmContent,
      totalCost: _totalCost,
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
          child: Padding(
            padding: EdgeInsets.all(16.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children.map(
                (model) {
                  return ButtonAnimator(
                    onPressed: () {
                      if (model.isComponentEditable) return onComponentTap(model.componentId);
                      nonEditableComponentTap(model.componentId);
                    },
                    child: MenuItemFlipSkeleton(
                      width: 300.s,
                      bgColor: model.color ?? Colors.red.darken(0.3),
                      header: Center(
                        child: StylizedText(
                          text: Text(
                            model.headerText,
                            style: TextStyles.s35,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      body: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /// image
                            MenuImage(
                              imageAssetPath: model.image,
                              dimension: 130.s,
                            ),

                            /// description
                            if (model.descriptionText != null)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.s, vertical: 10.s),
                                child: StylizedText(
                                  text: Text(
                                    model.descriptionText!,
                                    style: TextStyles.s24,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
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
              ).toList(),
            ),
          ),
        ),

        /// button
        Padding(
          padding: EdgeInsets.only(
            right: 16.s,
            bottom: 16.s,
            top: 8.s,
          ),
          child: GameButton.textImage(
            key: ValueKey(_totalCost.formattedValue),
            text: 'Buy ₹ ${_totalCost.formattedValue}',
            image: GameIcons.coin,
            bgColor: _totalCost.isZero() ? Colors.grey : Colors.green,
            onTap: _onPurchaseTap,
          ),
        ),
      ],
    );
  }
}

class MenuImage extends StatelessWidget {
  final String imageAssetPath;
  final double? dimension;
  final double? blurRadius;
  final Color? blurColor;
  final BoxShape shape;
  const MenuImage({
    super.key,
    required this.imageAssetPath,
    this.dimension,
    this.blurRadius,
    this.blurColor,
    this.shape = BoxShape.rectangle,
  });

  double get _dimension => dimension ?? 150.s;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _dimension,
      height: _dimension,
      decoration: BoxDecoration(
        color: Colors.white12,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(20.s) : null,
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2.s,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: _dimension / 20,
            blurRadius: _dimension / 20,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      padding: EdgeInsets.all(_dimension * 0.1),
      child: Image.asset(
        imageAssetPath,
        height: _dimension,
        width: _dimension,
        fit: BoxFit.contain,
      ),
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
