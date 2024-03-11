import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

/// TODO: Language
class FarmMenuHelper {
  static const tag = 'FarmMenuHelper';

  static FarmMenuModel getFarmMenuModel(Farm farm) {
    return FarmMenuModel(title: _getTitle(farm), models: _getItemModels(farm));
  }

  static String _getTitle(Farm farm) {
    switch (farm.farmController.farmState) {
      case FarmState.notBought:
        return 'Purchase Farm?';

      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
      case FarmState.treesAndCropsButCropsWaiting:
      case FarmState.treesRemovedOnlyCropsWaiting:
        return 'Agroforestry Farm';

      case FarmState.onlyCropsWaiting:
        return 'Monoculture Farm';

      case FarmState.functioning:
        final hasTrees = (farm.farmController.farmContent?.hasTrees) == true;
        if (hasTrees) {
          return 'Agroforestry Farm';
        }

        return 'Monoculture Farm';

      case FarmState.notFunctioning:
        return 'Empty Farm';

      case FarmState.barren:
        return 'Wasted Land';
    }
  }

  static List<FarmMenuItemModel> _getItemModels(Farm farm) {
    switch (farm.farmController.farmState) {
      /// buy
      case FarmState.notBought:
        return [
          _getBuyModel(farm),
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
          _getSoilHealth(farm),
          _getFarmComposition(farm),
          _getFarmHistory(farm),
          _getFarmMaintenance(farm),
        ];

      /// soil health, farm history
      case FarmState.barren:
        return [
          _getSoilHealth(farm),
          _getFarmHistory(farm),
        ];
    }
  }

  /// buy
  static FarmMenuItemModel _getBuyModel(Farm farm) {
    return FarmMenuItemModel(
      text: 'Purchase',
      option: FarmMenuOption.buyFarm,
      bgColor: Colors.greenAccent,
      image: GameAssets.buyFarm,
      data: FarmMenuItemData(
        data: GameUtils.farmInitialPrice.formattedValue,
        image: GameAssets.coin,
      ),
    );
  }

  /// soil health
  static FarmMenuItemModel _getSoilHealth(Farm farm) {
    return const FarmMenuItemModel(
      text: 'Health',
      option: FarmMenuOption.soilHealth,
      bgColor: Colors.white,
      image: GameAssets.soilHealth,
    );
  }

  /// farm composition
  static FarmMenuItemModel _getFarmComposition(Farm farm) {
    return const FarmMenuItemModel(
      text: 'Content',
      option: FarmMenuOption.composition,
      bgColor: Colors.white,
      image: GameAssets.farmComposition,
    );
  }

  /// farm history
  static FarmMenuItemModel _getFarmHistory(Farm farm) {
    return const FarmMenuItemModel(
      text: 'History',
      option: FarmMenuOption.history,
      bgColor: Colors.white,
      image: GameAssets.clock,
    );
  }

  static _getFarmMaintenance(Farm farm) {
    return const FarmMenuItemModel(
      text: 'Maintain',
      option: FarmMenuOption.maintenance,
      bgColor: Colors.white,
      image: GameAssets.maintanence,
    );
  }

  static String getDialogTitleFromFarmState(FarmState farmState) {
    switch (farmState) {
      case FarmState.notFunctioning:
        return 'Choose a system';

      case FarmState.onlyCropsWaiting:
        return 'Monoculture Crops';

      case FarmState.treesAndCropsButCropsWaiting:
      case FarmState.treesRemovedOnlyCropsWaiting:
      case FarmState.functioning:
      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
        return 'Farm components';

      case FarmState.notBought:
      case FarmState.barren:
        throw Exception('$tag: getDialogTitleFromFarmState($farmState) invoked at wrong farm state!');
    }
  }

  static String _titleFrom({
    required FarmMenuOption menuOption,
    required FarmState farmState,
  }) {
    switch (menuOption) {
      case FarmMenuOption.buyFarm:
        return 'Buy Farm?';

      case FarmMenuOption.soilHealth:
        return 'Soil Health';

      case FarmMenuOption.composition:
        return getDialogTitleFromFarmState(farmState);

      case FarmMenuOption.maintenance:
        return 'Farm Maintenance';

      case FarmMenuOption.history:
        return 'Farm History';
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
      barrierLabel: 'Dialog for ${menuOption.name}',
      context: context,
      builder: (context) {
        return DialogContainer(
          title: _titleFrom(
            menuOption: menuOption,
            farmState: farm.farmController.farmState,
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
                  // return Center(
                  //   child: Text('Nothing in farm to maintain! Keep Farming!'),
                  // );
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
                          'Nothing for maintenance, keep farming!',
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
    Navigation.popToFirst();

    /// do the actual transaction
    final success = await farmController.game.monetaryService.transact(
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
