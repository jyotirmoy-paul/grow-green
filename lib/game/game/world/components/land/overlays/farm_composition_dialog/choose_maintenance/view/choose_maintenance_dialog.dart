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
import '../../../../../../../../../widgets/stylized_text.dart';
import '../../../../../../../../utils/game_icons.dart';
import '../../../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../../components/farm/asset/crop_asset.dart';
import '../../../../components/farm/asset/fertilizer_asset.dart';
import '../../../../components/farm/asset/tree_asset.dart';
import '../../../../components/farm/components/crop/enums/crop_type.dart';
import '../../../../components/farm/components/system/enum/growable.dart';
import '../../../../components/farm/components/system/real_life/calculators/crops/base_crop.dart';
import '../../../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../../../components/farm/components/system/real_life/utils/qty_calculator.dart';
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

  get _anyOneisEditable => children.any((element) => element.isComponentEditable);

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
          child: Padding(
            padding: EdgeInsets.all(16.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children.map(
                (model) {
                  return Opacity(
                    opacity: _opacity(model),
                    child: ButtonAnimator(
                      onPressed: () {
                        if (model.isComponentEditable) return onComponentTap(model);
                      },
                      child: SizedBox(
                        height: 400.s,
                        child: MenuItemFlipSkeleton(
                          width: 200.s,
                          bgColor: model.color ?? Colors.red.darken(0.3),
                          header: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MenuImage(
                                imageAssetPath: model.upperImage,
                                dimension: 40.s,
                                shape: BoxShape.circle,
                              ),
                              StylizedText(
                                text: Text(
                                  model.headerText,
                                  style: TextStyles.s18,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                          body: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                /// image
                                MenuImage(
                                  imageAssetPath: model.image,
                                  dimension: 100.s,
                                ),

                                /// description
                                if (model.descriptionText != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.s, vertical: 10.s),
                                    child: StylizedText(
                                      text: Text(
                                        model.descriptionText!,
                                        style: TextStyles.s18,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          footer: model.footerWidget ??
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 8.s),
                                child: Center(
                                  /// button
                                  child: GameButton.text(
                                    color: Colors.white12,
                                    text: "CHANGE",
                                    textStyle: TextStyles.s14,
                                    onTap: () {
                                      onComponentTap(model);
                                    },
                                  ),
                                ),
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
        if (totalCost.value != 0)
          Padding(
            padding: EdgeInsets.only(
              right: 16.s,
              bottom: 16.s,
              top: 8.s,
            ),
            child: GameButton.textImage(
              key: ValueKey(totalCost.formattedValue),
              text: 'Total ₹ ${totalCost.formattedValue}',
              image: GameIcons.coin,
              bgColor: totalCost.isZero() ? Colors.grey : Colors.green,
              onTap: _onPurchaseTap,
            ),
          ),

        Row(
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
                    style: TextStyles.s28.copyWith(
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
              image: GameIcons.coin,
              bgColor: totalCost.isZero() ? Colors.grey : Colors.green,
              onTap: _onPurchaseTap,
            ),
          ],
        ),
      ],
    );
  }

  double _opacity(_ComponentsModel model) => _anyOneisEditable ? (model.isComponentEditable ? 1 : 0.5) : 1;

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

    final fertilizerAsset = FertilizerAsset.fromType(fertilizerType);

    final fertilizerCost = CostCalculator.getFertilizerCost(
      qty: fertilizerQty,
      type: fertilizerType,
    );

    final isEditable = isCrop ? !widget.isCropSupportPresent : !widget.isTreeSupportPresent;

    return _ComponentsModel(
      headerText: "Fertilizer",
      upperImage: upperImageAsset,
      image: fertilizerAsset,
      descriptionText: "$fertilizerCost ₹ | ${fertilizerQty.readableFormat} ",
      componentId: ComponentId.fertilizer,
      isComponentEditable: isEditable,
      color: AppColors.kFertilizerMenuCardBg,
      footerWidget: isEditable ? null : const SizedBox.shrink(),
      growableType: isCrop ? GrowableType.crop : GrowableType.tree,
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
      rightText: "₹ $maintenanceCost",
      textStyle: TextStyles.s18,
    );
    final isEditable = isCrop ? !widget.isCropSupportPresent : !widget.isTreeSupportPresent;

    return _ComponentsModel(
      headerText: "Maintenance",
      upperImage: upperImageAsset,
      image: 'assets/images/icons/maintenance.png',
      descriptionText: '',
      componentId: ComponentId.maintenance,
      isComponentEditable: isEditable,
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
    );
    final fertilizerContent = QtyCalculator.getFertilizerQtyRequiredFromTime(
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
    );
    final fertilizerContent = QtyCalculator.getFertilizerQtyRequiredFromTime(
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
  });
}