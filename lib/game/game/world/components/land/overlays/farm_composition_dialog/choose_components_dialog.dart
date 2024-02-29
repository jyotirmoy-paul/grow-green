import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../widgets/dialog_container.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../utils/game_icons.dart';
import '../../../../../../utils/game_images.dart';
import '../../../../../enums/agroforestry_type.dart';
import '../../../../../enums/farm_system_type.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import '../../components/farm/asset/crop_asset.dart';
import '../../components/farm/asset/tree_asset.dart';
import '../../components/farm/components/crop/enums/crop_stage.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../components/farm/components/tree/enums/tree_stage.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/model/content.dart';
import '../../components/farm/model/farm_content.dart';
import '../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../farm_menu/farm_menu_helper.dart';
import '../system_selector_menu/enum/component_id.dart';
import 'choose_component_dialog.dart';
import 'widgets/menu_item_skeleton.dart';

/// TODO: Language
class ChooseComponentsDialog extends StatefulWidget {
  final bool isNotFunctioningFarm;
  final FarmContent farmContent;
  final double soilHealthPercentage;

  /// components that are can be edited
  final List<ComponentId> editableComponents;

  const ChooseComponentsDialog({
    super.key,
    required this.farmContent,
    required this.editableComponents,
    required this.isNotFunctioningFarm,
    required this.soilHealthPercentage,
  });

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
    final cropCost = MoneyModel(rupees: CostCalculator.seedCostFromContent(cropContent: cropContent));

    if (isCropEditable) {
      _totalCost += cropCost;
    }

    return _ComponentsModel(
      headerText: 'Crop',
      image: 'assets/images/${CropAsset.of(cropType).at(CropStage.maturity)}',
      footerText: cropType.name.toUpperCase(),
      componentId: ComponentId.crop,
      isComponentEditable: isCropEditable,
      footerImage: GameIcons.edit,
      descriptionText: '${cropContent.qty.readableFormat} | ₹ ${cropCost.formattedRupees}',
    );
  }

  /// no crop
  _ComponentsModel noCrop() {
    return _ComponentsModel(
      headerText: 'Empty Crop',
      image: GameImages.noCrop,
      footerText: '',
      componentId: ComponentId.crop,
      isComponentEditable: widget.editableComponents.contains(ComponentId.crop),
      footerImage: GameIcons.edit,
    );
  }

  /// trees
  List<_ComponentsModel> forTrees(List<Content> treeContents) {
    return treeContents.map(
      (treeContent) {
        final treeType = treeContent.type as TreeType;
        final treeCost = MoneyModel(rupees: CostCalculator.saplingCostFromContent(treeContent: treeContent));

        _totalCost += treeCost;

        return _ComponentsModel(
          headerText: 'Tree',
          image: 'assets/images/${TreeAsset.of(treeType).at(TreeStage.giant)}',
          footerText: treeType.name.toUpperCase(),
          componentId: ComponentId.trees,
          isComponentEditable: widget.editableComponents.contains(ComponentId.trees),
          footerImage: widget.isNotFunctioningFarm ? GameIcons.edit : GameIcons.remove,
          buttonColor: widget.isNotFunctioningFarm ? null : Colors.red,
          descriptionText: '${treeContent.qty.readableFormat} | ₹ ${treeCost.formattedRupees}',
        );
      },
    ).toList();
  }

  _ComponentsModel noTree() {
    return _ComponentsModel(
      headerText: 'Empty Tree',
      image: GameImages.noTree,
      footerText: '',
      componentId: ComponentId.trees,
      isComponentEditable: widget.editableComponents.contains(ComponentId.crop),
      footerImage: GameIcons.edit,
    );
  }

  /// fertilizer
  _ComponentsModel forFertilizer(Content fertilizerContent) {
    final fertilizerType = fertilizerContent.type as FertilizerType;
    final fertilizerCost = MoneyModel(
      rupees: CostCalculator.fertilizerCostFromContent(fertilizerContent: fertilizerContent),
    );

    _totalCost += fertilizerCost;

    return _ComponentsModel(
      headerText: 'Fertilizer',
      image: fertilizerType == FertilizerType.chemical ? GameImages.chemicalFertilizer : GameImages.organicFertilizer,
      footerText: fertilizerType.name.toUpperCase(),
      componentId: ComponentId.fertilizer,
      isComponentEditable: widget.editableComponents.contains(ComponentId.fertilizer),
      footerImage: GameIcons.edit,
      descriptionText: '${fertilizerContent.qty.readableFormat} | ₹ ${fertilizerCost.formattedRupees}',
    );
  }

  /// system
  _ComponentsModel forAgroforestryType(AgroforestryType agroforestryType) {
    return _ComponentsModel(
      headerText: 'Agroforestry System',
      image: () {
        switch (agroforestryType) {
          case AgroforestryType.alley:
            return GameImages.alleyPlanation;
          case AgroforestryType.boundary:
            return GameImages.boundaryPlantation;
          case AgroforestryType.block:
            return GameImages.blockPlantation;
        }
      }(),
      footerText: agroforestryType.name.toUpperCase(),
      componentId: ComponentId.agroforestryLayout,
      isComponentEditable: widget.editableComponents.contains(ComponentId.agroforestryLayout),
      footerImage: GameIcons.edit,
      color: Colors.blueGrey,
    );
  }

  void _calculateDataFor(FarmContent farmContent) {
    /// clearn up
    children.clear();
    _totalCost = MoneyModel.zero();

    final isAgroforestry = farmContent.systemType != FarmSystemType.monoculture;

    /// system
    if (isAgroforestry) {
      children.add(
        forAgroforestryType(farmContent.systemType as AgroforestryType),
      );
    }

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
          trees: [
            FarmMenuHelper.getFertilizerContent(
              fertilizerType: fertilizer,
              systemType: _currentFarmContent.systemType,
              soilHealthPercentage: widget.soilHealthPercentage,
              cropType: _currentFarmContent.crop!.type as CropType,
            ),
          ],
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

  /// this method is only allowed for items which can be edited
  void onComponentTap(ComponentId componentId) async {
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

    if (mounted)
      setState(() {
        isHidden = false;
      });

    /// if dialog box was close, ignore
    if (newComponentIndex is! int) return;

    processNewComponent(
      componentId: componentId,
      index: newComponentIndex,
    );
  }

  void _onPurchaseTap() {
    FarmMenuHelper.purchaseFarmContents(
      farmSystem: _currentFarmContent,
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
          child: ListView.separated(
            padding: EdgeInsets.all(16.s),
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            itemBuilder: (_, index) {
              final model = children[index];

              return MenuItemSkeleton(
                width: 300.s,
                bgColor: model.isComponentEditable ? model.color ?? Colors.orange : Colors.blueGrey,
                header: Center(
                  child: Text(
                    model.headerText,
                    style: TextStyles.s28,
                    textAlign: TextAlign.center,
                  ),
                ),
                body: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    /// image
                    Image.asset(model.image),

                    /// description
                    if (model.descriptionText != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(8.s),
                          child: Text(
                            model.descriptionText!,
                            style: TextStyles.s26,
                          ),
                        ),
                      ),
                  ],
                ),
                footer: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 12.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// footer text
                      Text(
                        model.footerText,
                        style: TextStyles.s24,
                      ),

                      /// button
                      GameButton.image(
                        bgColor: model.isComponentEditable ? (model.buttonColor ?? Colors.blue) : Colors.grey,
                        image: model.footerImage,
                        onTap: () {
                          if (!model.isComponentEditable) return;
                          onComponentTap(model.componentId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => Gap(32.s),
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
            key: ValueKey(_totalCost.formattedRupees),
            text: 'Buy ₹ ${_totalCost.formattedRupees}',
            image: GameIcons.coin,
            bgColor: Colors.green,
            onTap: _onPurchaseTap,
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
  final String footerImage;
  final Color? color;
  final Color? buttonColor;

  _ComponentsModel({
    required this.headerText,
    required this.image,
    required this.footerText,
    required this.componentId,
    required this.isComponentEditable,
    required this.footerImage,
    this.descriptionText,
    this.color,
    this.buttonColor,
  });
}
