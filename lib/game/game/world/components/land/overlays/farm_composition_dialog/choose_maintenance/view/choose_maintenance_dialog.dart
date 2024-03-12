import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../../utils/app_colors.dart';
import '../../../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../../../utils/text_styles.dart';
import '../../../../../../../../../utils/utils.dart';
import '../../../../../../../../../widgets/button_animator.dart';
import '../../../../../../../../../widgets/dialog_container.dart';
import '../../../../../../../../../widgets/game_button.dart';
import '../../../../../../../../utils/game_assets.dart';
import '../../../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../../components/farm/asset/crop_asset.dart';
import '../../../../components/farm/asset/tree_asset.dart';
import '../../../../components/farm/components/crop/enums/crop_type.dart';
import '../../../../components/farm/components/system/enum/growable.dart';
import '../../../../components/farm/components/system/real_life/calculators/crops/base_crop.dart';
import '../../../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../../../components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../../../components/farm/components/system/real_life/utils/soil_health_calculator.dart';
import '../../../../components/farm/components/tree/enums/tree_type.dart';
import '../../../../components/farm/farm_controller.dart';
import '../../../../components/farm/model/content.dart';
import '../../../../components/farm/model/farm_content.dart';
import '../../../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../../../farm_menu/farm_menu_helper.dart';
import '../../../system_selector_menu/enum/component_id.dart';
import '../../choose_component_dialog.dart';
import '../../widgets/menu_image.dart';
import '../../widgets/menu_item_flip_skeleton.dart';
import '../../widgets/soil_health_effect.dart';
import '../../widgets/system_item_widget.dart';
import '../logic/support_config.dart';

class ChooseMaintenanceDialog extends StatefulWidget {
  final FarmContent farmContent;
  final FarmController farmController;
  final double soilHealthPercentage;
  final MoneyModel startingDebit;

  final bool isCropSupportPresent;
  final bool isTreeSupportPresent;

  /// components that are can be edited
  ChooseMaintenanceDialog({
    super.key,
    required this.farmContent,
    required this.farmController,
    required this.startingDebit,
  })  : soilHealthPercentage = farmController.soilHealthPercentage,
        isCropSupportPresent = farmContent.cropSupportConfig != null,
        isTreeSupportPresent = farmContent.treeSupportConfig != null;

  @override
  State<ChooseMaintenanceDialog> createState() => _ChooseMaintenanceDialogState();
}

class _ChooseMaintenanceDialogState extends State<ChooseMaintenanceDialog> {
  late FarmContent _currentFarmContent;
  final children = <_ComponentsModel>[];
  bool isHidden = false;

  @override
  void initState() {
    super.initState();
    _currentFarmContent = widget.farmContent;
    _addChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /// body
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(20.s),
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            separatorBuilder: (_, index) {
              if (index == 1) {
                return VerticalDivider(
                  thickness: 2.s,
                  width: 60.s,
                  indent: 100.s,
                  endIndent: 100.s,
                );
              }

              return Gap(20.s);
            },
            itemBuilder: (context, index) {
              final model = children[index];

              final child = Opacity(
                opacity: _opacity(model),
                child: MenuItemFlipSkeleton(
                  width: 400.s,
                  bgColor: model.color ?? Colors.red.darken(0.3),
                  header: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MenuImage(
                        imageAssetPath: model.upperImage,
                        dimension: 50.s,
                        shape: BoxShape.circle,
                      ),
                      Text(
                        model.headerText,
                        style: TextStyles.s28,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// image
                      MenuImage(
                        imageAssetPath: model.image,
                        dimension: 160.s,
                      ),

                      /// description
                      if (model.descriptionText != null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.s, vertical: 10.s),
                          child: Text(
                            model.descriptionText!,
                            style: TextStyles.s28,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (model.descriptionWidget != null) model.descriptionWidget!,
                    ],
                  ),
                  footer: model.footerWidget ??
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 8.s),
                        child: Center(
                          /// button
                          child: GameButton.text(
                            color: Colors.white12,
                            text: "CHANGE",
                            onTap: () {
                              onComponentTap(model);
                            },
                          ),
                        ),
                      ),
                ),
              );

              if (model.isComponentEditable) {
                return ButtonAnimator(
                  child: child,
                  onPressed: () {
                    onComponentTap(model);
                  },
                );
              }

              return child;
            },
          ),
        ),

        /// button
        Padding(
          padding: EdgeInsets.only(
            left: 16.s,
            right: 16.s,
            bottom: 16.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// show breakup of cost only if a total cost is available
              if (totalCost.value != 0 && widget.startingDebit.value != 0)
                Row(
                  children: [
                    Icon(
                      Icons.info_rounded,
                      size: 40.s,
                      color: Colors.orange,
                    ),

                    Gap(6.s),

                    /// price sum
                    Text(
                      '${widget.startingDebit.formattedValue} (Crops/Trees) + ${_calculateTotalSupportCost.formattedValue} (Maintainance)',
                      style: TextStyles.s25.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

              const Spacer(),

              /// button
              GameButton.textImage(
                key: ValueKey(totalCost.formattedValue),
                text: 'Buy for ${totalCost.formattedValue}',
                image: GameAssets.coin,
                bgColor: totalCost.isZero() ? Colors.grey : Colors.green,
                onTap: _onPurchaseTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get _anyOneisEditable => children.any((element) => element.isComponentEditable);

  double _opacity(_ComponentsModel model) {
    if (model.componentId == ComponentId.maintenance) return 1.0;
    if (_anyOneisEditable) return model.isComponentEditable ? 1 : 0.6;
    return 1.0;
  }

  MoneyModel get totalCost => widget.startingDebit + _calculateTotalSupportCost;
  void _onPurchaseTap() async {
    if (totalCost.isZero()) {
      return NotificationHelper.nothingToBuy();
    }

    FarmMenuHelper.purchaseFarmContents(
      farmController: widget.farmController,
      farmContent: _currentFarmContent,
      totalCost: totalCost,
    );
  }

  void _addChildren() {
    children.clear();
    // Crops
    _addCropComponents();
    // Trees
    _addTreeComponents();
  }

  void _addTreeComponents() {
    // if there is no tree , maintenance card is not added
    if (!_currentFarmContent.hasTrees) return;

    if (_currentFarmContent.treeSupportConfig == null) {
      final predictedSupportConfig = _generateTreeSupportConfig(_currentFarmContent);
      _currentFarmContent = _currentFarmContent.copyWith(treeSupportConfig: predictedSupportConfig);
    }

    children.add(buildMaintenanceComponent(isCrop: false));
    children.add(buildFertilizerComponent(isCrop: false));
  }

  _ComponentsModel buildFertilizerComponent({
    required bool isCrop,
  }) {
    final upperImageAsset = isCrop
        ? CropAsset.menuRepresentativeOf(_currentFarmContent.crop!.type as CropType)
        : TreeAsset.menuRepresentativeOf(_currentFarmContent.tree!.type as TreeType);
    final fertilizerType = isCrop
        ? _currentFarmContent.cropSupportConfig!.fertilizerConfig.type as FertilizerType
        : _currentFarmContent.treeSupportConfig!.fertilizerConfig.type as FertilizerType;
    final fertilizerQty = isCrop
        ? _currentFarmContent.cropSupportConfig!.fertilizerConfig.qty
        : _currentFarmContent.treeSupportConfig!.fertilizerConfig.qty;

    final fertilizerAsset = GameAssets.getFertilizerAssetFor(fertilizerType);

    final fertilizerCost = CostCalculator.getFertilizerCost(
      qty: fertilizerQty,
      type: fertilizerType,
    );

    final isEditable = isCrop ? !widget.isCropSupportPresent : !widget.isTreeSupportPresent;
    final supportConfig = isCrop ? _currentFarmContent.cropSupportConfig! : _currentFarmContent.treeSupportConfig!;
    final changePercentage = SoilHealthCalculator.fertilizerEffect(
      fertilizer: supportConfig.fertilizerConfig,
      soilHealthPercentage: widget.farmController.soilHealthPercentage,
    );
    final soilHealthEffect = SoilHealthEffect(
      changePercentage: changePercentage,
      changeDurationType: ChangeDurationType.perUse,
    );
    return _ComponentsModel(
      headerText: "Fertilizer",
      upperImage: upperImageAsset,
      image: fertilizerAsset,
      descriptionText: "${MoneyModel(value: fertilizerCost).formattedValue} | ${fertilizerQty.readableFormat} ",
      componentId: ComponentId.fertilizer,
      isComponentEditable: isEditable,
      color: AppColors.kFertilizerMenuCardBg,
      footerWidget: isEditable ? null : const SizedBox.shrink(),
      growableType: isCrop ? GrowableType.crop : GrowableType.tree,
      descriptionWidget: soilHealthEffect,
    );
  }

  _ComponentsModel buildMaintenanceComponent({
    required bool isCrop,
  }) {
    final upperImageAsset = isCrop
        ? CropAsset.menuRepresentativeOf(_currentFarmContent.crop!.type as CropType)
        : TreeAsset.menuRepresentativeOf(_currentFarmContent.tree!.type as TreeType);

    final maintenanceCost = isCrop
        ? CostCalculator.maintenanceCost(_currentFarmContent.cropSupportConfig!.maintenanceConfig)
        : CostCalculator.maintenanceCost(_currentFarmContent.treeSupportConfig!.maintenanceConfig);

    final footerWidget = MenuFooterTextRow(
      leftText: "Total",
      rightText: MoneyModel(value: maintenanceCost).formattedValue,
    );

    return _ComponentsModel(
      headerText: "Maintanence",
      upperImage: upperImageAsset,
      image: GameAssets.farmMaintanence,
      descriptionText: '',
      componentId: ComponentId.maintenance,
      isComponentEditable: false,
      color: Colors.green,
      footerWidget: footerWidget,
      growableType: isCrop ? GrowableType.crop : GrowableType.tree,
    );
  }

  void _addCropComponents() {
    // if there is no crop , maintenance card is not added
    if (!_currentFarmContent.hasCrop) return;

    // if crop support is present , no need to make it editable

    if (_currentFarmContent.cropSupportConfig == null) {
      final predictedSupportConfig = _generateCropSupportConfig(_currentFarmContent);
      _currentFarmContent = _currentFarmContent.copyWith(cropSupportConfig: predictedSupportConfig);
    }

    children.add(buildMaintenanceComponent(isCrop: true));
    children.add(buildFertilizerComponent(isCrop: true));
  }

  SupportConfig _generateCropSupportConfig(
    FarmContent farmContent, {
    FertilizerType recommendedFertilizerType = FertilizerType.organic,
  }) {
    final cropAge = BaseCropCalculator.fromCropType(farmContent.crop!.type as CropType).maxAgeInMonths;
    final maintenanceQty = QtyCalculator.maintenanceQtyFromTime(
      systemType: farmContent.systemType,
      growableType: GrowableType.crop,
      ageInMonths: cropAge,
      soilHealthPercentage: widget.soilHealthPercentage,
    );
    final fertilizerContent = QtyCalculator.getFertilizerUsedForGrowingGrowableForTime(
      soilHealthPercentage: widget.soilHealthPercentage,
      growableType: GrowableType.crop,
      systemType: farmContent.systemType,
      fertilizerType: recommendedFertilizerType,
      ageInMonths: cropAge,
    );

    final supportConfig = SupportConfig(
      maintenanceConfig: maintenanceQty,
      fertilizerConfig: Content(qty: fertilizerContent, type: recommendedFertilizerType),
    );

    return supportConfig;
  }

  SupportConfig _generateTreeSupportConfig(
    FarmContent farmContent, {
    FertilizerType recommendedFertilizerType = FertilizerType.organic,
  }) {
    const treeAge = 12;
    final maintenanceQty = QtyCalculator.maintenanceQtyFromTime(
      systemType: farmContent.systemType,
      growableType: GrowableType.tree,
      ageInMonths: treeAge,
      soilHealthPercentage: widget.soilHealthPercentage,
    );
    final fertilizerContent = QtyCalculator.getFertilizerUsedForGrowingGrowableForTime(
      soilHealthPercentage: widget.soilHealthPercentage,
      growableType: GrowableType.tree,
      systemType: farmContent.systemType,
      fertilizerType: recommendedFertilizerType,
      ageInMonths: treeAge,
    );

    final supportConfig = SupportConfig(
      maintenanceConfig: maintenanceQty,
      fertilizerConfig: Content(qty: fertilizerContent, type: recommendedFertilizerType),
    );

    return supportConfig;
  }

  void onComponentTap(_ComponentsModel component) async {
    if (component.componentId != ComponentId.fertilizer) return;
    if (!component.isComponentEditable) return;
    setState(() {
      isHidden = true;
    });

    final newComponentIndex = await Utils.showNonAnimatedDialog(
      barrierLabel: 'Choose component dialog',
      context: context,
      builder: (context) {
        return DialogContainer(
          dialogType: DialogType.large,
          title: 'Choose Fertilizer',
          child: ChooseComponentDialog(componentId: component.componentId),
        );
      },
    );

    /// if dialog box was close, ignore
    if (newComponentIndex is! int) return;

    processFertilizer(
      componentId: ComponentId.fertilizer,
      growableType: component.growableType,
      index: newComponentIndex,
    );
  }

  void processFertilizer({
    required ComponentId componentId,
    required GrowableType growableType,
    required int index,
  }) {
    final fertilizerType = FertilizerType.values[index];

    if (growableType == GrowableType.crop) {
      _currentFarmContent = _currentFarmContent.copyWith(
        cropSupportConfig: _generateCropSupportConfig(_currentFarmContent, recommendedFertilizerType: fertilizerType),
      );
    } else {
      _currentFarmContent = _currentFarmContent.copyWith(
        treeSupportConfig: _generateTreeSupportConfig(_currentFarmContent, recommendedFertilizerType: fertilizerType),
      );
    }
    setState(() {
      _addChildren();
    });
  }

  MoneyModel get _calculateTotalSupportCost {
    var totalCost = 0;
    if (!widget.isCropSupportPresent) {
      totalCost += _currentFarmContent.cropSupportConfig?.cost ?? 0;
    }

    if (!widget.isTreeSupportPresent) {
      totalCost += _currentFarmContent.treeSupportConfig?.cost ?? 0;
    }
    return MoneyModel(value: totalCost);
  }
}

class _ComponentsModel {
  final String headerText;
  final String upperImage;
  final String image;
  final String? descriptionText;
  final ComponentId componentId;
  final GrowableType growableType;
  final bool isComponentEditable;
  final Color? color;
  final Widget? footerWidget;
  final Widget? descriptionWidget;

  _ComponentsModel({
    required this.headerText,
    required this.upperImage,
    required this.image,
    required this.componentId,
    required this.isComponentEditable,
    required this.growableType,
    this.descriptionText,
    this.color,
    this.footerWidget,
    this.descriptionWidget,
  });
}
