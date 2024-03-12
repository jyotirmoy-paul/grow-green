import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../l10n/l10n.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../services/log/log.dart';
import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../widgets/dialog_container.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../../utils/game_assets.dart';
import '../../../../../../utils/game_utils.dart';
import '../../../../../enums/farm_system_type.dart';
import '../../../../../enums/system_type.dart';
import '../../../../../models/farm_system.dart';
import '../../../../../overlays/notification_overlay/service/notification_helper.dart';
import '../../../../../services/game_services/monetary/enums/transaction_type.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import '../../components/farm/components/crop/enums/crop_type.dart';
import '../../components/farm/components/system/enum/growable.dart';
import '../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../components/farm/components/tree/enums/tree_type.dart';
import '../../components/farm/enum/farm_state.dart';
import '../../components/farm/farm.dart';
import '../../components/farm/farm_controller.dart';
import '../../components/farm/model/content.dart';
import '../../components/farm/model/farm_content.dart';
import '../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../farm_composition_dialog/choose_components_dialog.dart';
import '../farm_composition_dialog/choose_maintenance/logic/support_config.dart';
import '../farm_composition_dialog/choose_maintenance/logic/support_config_predictor.dart';
import '../farm_composition_dialog/choose_maintenance/view/choose_maintenance_dialog.dart';
import '../farm_composition_dialog/choose_system_dialog.dart';
import '../farm_history_dialog/farm_history_dialog.dart';
import '../purchase_farm_dialog/purchase_farm_dialog.dart';
import '../soil_health_dialog/soil_health_dialog.dart';
import '../system_selector_menu/enum/component_id.dart';
import 'enum/farm_menu_option.dart';
import 'farm_menu.dart';
import 'model/farm_menu_model.dart';

class FarmMenuHelper {
  static const tag = 'FarmMenuHelper';

  static FarmMenuModel getFarmMenuModel(Farm farm, BuildContext context) {
    return FarmMenuModel(
      title: _getTitle(farm, context),
      models: _getItemModels(farm, context),
    );
  }

  static String _getTitle(Farm farm, BuildContext context) {
    final isViewOnly = farm.game.isViewOnly;
    switch (farm.farmController.farmState) {
      case FarmState.notBought:
        return isViewOnly ? context.l10n.farmNotPurchased : context.l10n.purchaseFarm;

      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
      case FarmState.treesAndCropsButCropsWaiting:
      case FarmState.treesRemovedOnlyCropsWaiting:
        return context.l10n.agroforestryFarm;

      case FarmState.onlyCropsWaiting:
        return context.l10n.monocultureFarm;

      case FarmState.functioning:
        final hasTrees = (farm.farmController.farmContent?.hasTrees) == true;
        if (hasTrees) {
          return context.l10n.agroforestryFarm;
        }
        return context.l10n.monocultureFarm;

      case FarmState.notFunctioning:
        return context.l10n.emptyFarm;

      case FarmState.barren:
        return context.l10n.wastedLand;
    }
  }

  static List<FarmMenuItemModel> _getItemModels(Farm farm, BuildContext context) {
    if (farm.game.isViewOnly) {
      return _getItemModelsWhenViewing(farm, context);
    } else {
      return _getItemModelsWhenPlaying(farm, context);
    }
  }

  static List<FarmMenuItemModel> _getItemModelsWhenViewing(Farm farm, BuildContext context) {
    switch (farm.farmController.farmState) {
      case FarmState.notBought:
        return [];
      default:
        return [
          _getSoilHealth(farm, context),
          _getFarmHistory(farm, context),
        ];
    }
  }

  static List<FarmMenuItemModel> _getItemModelsWhenPlaying(Farm farm, BuildContext context) {
    switch (farm.farmController.farmState) {
      /// buy
      case FarmState.notBought:
        return [
          _getBuyModel(farm, context),
        ];

      /// soil health, farm composition, farm history
      case FarmState.onlyCropsWaiting:
      case FarmState.treesAndCropsButCropsWaiting:
      case FarmState.treesRemovedOnlyCropsWaiting:
      case FarmState.functioning:
      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
      case FarmState.notFunctioning:
        return [
          _getSoilHealth(farm, context),
          _getFarmComposition(farm, context),
          _getFarmHistory(farm, context),
          _getFarmMaintenance(farm, context),
        ];

      /// soil health, farm history
      case FarmState.barren:
        return [
          _getSoilHealth(farm, context),
          _getFarmHistory(farm, context),
        ];
    }
  }

  /// buy
  static FarmMenuItemModel _getBuyModel(Farm farm, BuildContext context) {
    return FarmMenuItemModel(
      text: context.l10n.purchase,
      option: FarmMenuOption.buyFarm,
      bgColor: Colors.white,
      image: GameAssets.buyFarm,
      data: FarmMenuItemData(
        data: GameUtils.farmInitialPrice.formattedValue,
        image: GameAssets.coin,
      ),
    );
  }

  /// buy

  /// soil health
  static FarmMenuItemModel _getSoilHealth(Farm farm, BuildContext context) {
    return FarmMenuItemModel(
      text: context.l10n.health,
      option: FarmMenuOption.soilHealth,
      bgColor: Colors.white,
      image: GameAssets.soilHealth,
    );
  }

  /// farm composition
  static FarmMenuItemModel _getFarmComposition(Farm farm, BuildContext context) {
    return FarmMenuItemModel(
      text: context.l10n.content,
      option: FarmMenuOption.composition,
      bgColor: Colors.white,
      image: GameAssets.farmContent,
    );
  }

  /// farm history
  static FarmMenuItemModel _getFarmHistory(Farm farm, BuildContext context) {
    return FarmMenuItemModel(
      text: context.l10n.history,
      option: FarmMenuOption.history,
      bgColor: Colors.white,
      image: GameAssets.farmHistory,
    );
  }

  static _getFarmMaintenance(Farm farm, BuildContext context) {
    return FarmMenuItemModel(
      text: context.l10n.maintain,
      option: FarmMenuOption.maintenance,
      bgColor: Colors.white,
      image: GameAssets.farmMaintanence,
    );
  }

  static String getDialogTitleFromFarmState(FarmState farmState, BuildContext context) {
    switch (farmState) {
      case FarmState.notFunctioning:
        return context.l10n.chooseASystem;

      case FarmState.onlyCropsWaiting:
        return context.l10n.monocultureCrops;

      case FarmState.treesAndCropsButCropsWaiting:
      case FarmState.treesRemovedOnlyCropsWaiting:
      case FarmState.functioning:
      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
        return context.l10n.farmComponents;

      case FarmState.notBought:
      case FarmState.barren:
        throw Exception('$tag: getDialogTitleFromFarmState($farmState) invoked at wrong farm state!');
    }
  }

  static String _titleFrom({
    required FarmMenuOption menuOption,
    required FarmState farmState,
    required BuildContext context,
  }) {
    switch (menuOption) {
      case FarmMenuOption.buyFarm:
        return context.l10n.buyFarm;

      case FarmMenuOption.soilHealth:
        return context.l10n.soilHealth;

      case FarmMenuOption.composition:
        return getDialogTitleFromFarmState(farmState, context);

      case FarmMenuOption.maintenance:
        return context.l10n.farmMaintenance;

      case FarmMenuOption.history:
        return context.l10n.farmHistory;
    }
  }

  static DialogType _dialogType(FarmMenuOption menuOption) {
    switch (menuOption) {
      case FarmMenuOption.buyFarm:
        return DialogType.small;

      case FarmMenuOption.soilHealth:
      case FarmMenuOption.composition:
      case FarmMenuOption.history:
      case FarmMenuOption.maintenance:
        return DialogType.large;
    }
  }

  static Future<bool> onMenuItemTap({
    required FarmMenuOption menuOption,
    required BuildContext context,
    required Farm farm,
  }) async {
    /// remove non visible elements
    farm.game.gameController.overlayData.farmNotifier.farm = null;
    farm.farmController.isFarmSelected = false;

    final response = await Utils.showNonAnimatedDialog(
      barrierLabel: context.l10n.dialogFor(menuOption.name),
      context: context,
      builder: (context) {
        return DialogContainer(
          title: _titleFrom(
            menuOption: menuOption,
            farmState: farm.farmController.farmState,
            context: context,
          ),
          dialogType: _dialogType(menuOption),
          child: () {
            switch (menuOption) {
              case FarmMenuOption.buyFarm:
                return PurchaseFarmDialog(farm: farm);

              case FarmMenuOption.soilHealth:
                return SoilHealthDialog(farm: farm);

              case FarmMenuOption.composition:
                final farmState = farm.farmController.farmState;

                if (farmState == FarmState.notFunctioning) {
                  return ChooseSystemDialog(farm: farm);
                }

                final farmContent = farm.farmController.farmContent;
                if (farmContent == null) {
                  throw Exception(
                    '$tag: onMenuItemTap() invoked with null farm content in $farmState state',
                  );
                }

                return ChooseComponentsDialog(
                  farmContent: farmContent,
                  editableComponents: getEditableComponentIdsAt(farmState),
                  farmController: farm.farmController,
                );

              case FarmMenuOption.history:
                return FarmHistoryDialog(farm: farm);

              case FarmMenuOption.maintenance:
                final farmState = farm.farmController.farmState;

                if (farmState == FarmState.notFunctioning) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        GameAssets.itSeemsEmptyHere,
                        height: 200.s,
                      ),
                      Gap(20.s),
                      StylizedText(
                        text: Text(
                          context.l10n.nothingForMaintenance,
                          style: TextStyles.s28,
                        ),
                      ),
                    ],
                  );
                }

                final farmContent = farm.farmController.farmContent;

                if (farmContent == null) {
                  throw Exception(
                    '$tag: onMenuItemTap() invoked with null farm content in $farmState state',
                  );
                }

                return ChooseMaintenanceDialog(
                  farmContent: farmContent,
                  farmController: farm.farmController,
                  startingDebit: MoneyModel.zero(),
                );
            }
          }(),
        );
      },
    );

    if (response == DialogEndType.close || response == null) {
      farm.game.gameController.overlayData.farmNotifier.farm = farm;
      farm.game.overlays.add(FarmMenu.overlayName);
      farm.farmController.isFarmSelected = true;
    }

    if (response is bool) return response;
    return false;
  }

  static List<ComponentId> getEditableComponentIdsAt(FarmState farmState) {
    switch (farmState) {
      case FarmState.notBought:
      case FarmState.notFunctioning:
      case FarmState.barren:
        throw Exception('$tag: getEditableComponentIdsAt($farmState) invoked at wrong farm state');

      case FarmState.onlyCropsWaiting:
        return const [];

      case FarmState.functioning:
      case FarmState.functioningOnlyCrops:
      case FarmState.treesAndCropsButCropsWaiting:
      case FarmState.treesRemovedOnlyCropsWaiting:
        return const [
          ComponentId.trees,
        ];

      case FarmState.functioningOnlyTrees:
        return const [
          ComponentId.crop,
          ComponentId.trees,
        ];
    }
  }

  static Content getCropContent({
    required CropType cropType,
    required SystemType systemType,
  }) {
    return Content(
      type: cropType,
      qty: QtyCalculator.getSeedQtyRequireFor(
        systemType: systemType,
        cropType: cropType,
      ),
    );
  }

  static SupportConfig getFertilizerConfig({
    required FertilizerType fertilizerType,
    required double soilHealthPercentage,
    required SystemType systemType,
    required Growable growable,
  }) {
    final fertilizerConfig = SupportConfigPredictor.predictFertilizerConfigForFarm(
      systemType: systemType,
      soilHealthPercentage: soilHealthPercentage,
      fertilizerType: fertilizerType,
      growable: growable,
    );
    final maintenanceConfig = SupportConfigPredictor.predictMaintenanceConfigForFarm(
      systemType: systemType,
      growable: growable,
      soilHealthPercentage: soilHealthPercentage,
    );

    return SupportConfig(
      fertilizerConfig: fertilizerConfig,
      maintenanceConfig: maintenanceConfig,
    );
  }

  static Content getTreeContent({
    required TreeType treeType,
    required SystemType systemType,
  }) {
    return Content(
      type: treeType,
      qty: QtyCalculator.getNumOfSaplingsFor(systemType),
    );
  }

  static FarmContent getFarmContentFromSystem({
    required FarmSystem farmSystem,
    required double soilHealthPercentage,
  }) {
    Content? crop;
    Content? tree;
    SupportConfig? cropSupportConfig;
    SupportConfig? treeSupportConfig;
    late SystemType systemType;

    if (farmSystem.farmSystemType == FarmSystemType.monoculture) {
      final system = farmSystem as MonocultureSystem;

      crop = getCropContent(
        cropType: system.crop,
        systemType: FarmSystemType.monoculture,
      );

      systemType = FarmSystemType.monoculture;
    } else {
      final system = farmSystem as AgroforestrySystem;

      crop = getCropContent(
        cropType: system.crop,
        systemType: system.agroforestryType,
      );

      tree = getTreeContent(treeType: system.tree, systemType: system.agroforestryType);

      systemType = system.agroforestryType;
    }

    return FarmContent(
      crop: crop,
      tree: tree,
      cropSupportConfig: cropSupportConfig,
      treeSupportConfig: treeSupportConfig,
      systemType: systemType,
    );
  }

  static void purchaseFarmContents({
    required FarmController farmController,
    required FarmContent farmContent,
    required MoneyModel totalCost,
  }) async {
    Log.d('$tag: purchaseFarmContents() invoked with farmContent: $farmContent, totalCost: $totalCost');

    final moneytaryService = farmController.game.monetaryService;

    final canAfford = moneytaryService.canAfford(totalCost);
    if (!canAfford) {
      NotificationHelper.cannotAffordFarmContents();
      return;
    }

    /// pop all dialogs
    Navigation.popUntil(RouteName.gameScreen);

    /// do the actual transaction
    final success = farmController.game.monetaryService.transact(
      transactionType: TransactionType.debit,
      value: totalCost,
    );

    if (success) {
      return farmController.updateFarmComposition(
        farmContent: farmContent,
      );
    }

    NotificationHelper.farmContentsPurchaseFailed();
  }

  static MoneyModel getPriceForFarmSystem({
    required FarmSystem farmSystem,
    required double soilHealthPercentage,
  }) {
    MoneyModel totalPrice = MoneyModel.zero();

    final system = farmSystem;
    if (system is AgroforestrySystem) {
      /// crops price
      final cropType = system.crop;
      totalPrice += MoneyModel(
        value: CostCalculator.seedCost(
          seedsRequired: QtyCalculator.getSeedQtyRequireFor(
            systemType: system.agroforestryType,
            cropType: cropType,
          ),
          cropType: cropType,
        ),
      );

      /// trees price
      totalPrice += MoneyModel(
        value: CostCalculator.saplingCost(
          saplingQty: QtyCalculator.getNumOfSaplingsFor(system.agroforestryType),
          treeType: system.tree,
        ),
      );
    }

    if (system is MonocultureSystem) {
      /// crops price
      final cropType = system.crop;
      totalPrice += MoneyModel(
        value: CostCalculator.seedCost(
          seedsRequired: QtyCalculator.getSeedQtyRequireFor(
            systemType: FarmSystemType.monoculture,
            cropType: cropType,
          ),
          cropType: cropType,
        ),
      );

      /// fertilizer price
      totalPrice += MoneyModel(
        value: CostCalculator.getFertilizerCost(
          qty: QtyCalculator.getFertilizerQtyRequiredFor(
            systemType: FarmSystemType.monoculture,
            soilHealthPercentage: soilHealthPercentage,
            cropType: cropType,
            fertilizerType: system.fertilizer,
            growableType: GrowableType.crop,
          ),
          type: system.fertilizer,
        ),
      );
    }

    return totalPrice;
  }
}
