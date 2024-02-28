import 'package:flutter/material.dart';

import '../../../../../../../widgets/dialog_container.dart';
import '../../../../../../utils/game_icons.dart';
import '../../../../../../utils/game_utils.dart';
import '../../components/farm/enum/farm_state.dart';
import '../../components/farm/farm.dart';
import '../farm_composition_dialog/farm_composition_dialog.dart';
import '../farm_history_dialog/farm_history_dialog.dart';
import '../purchase_farm_dialog/purchase_farm_dialog.dart';
import '../soil_health_dialog/soil_health_dialog.dart';
import 'enum/farm_menu_option.dart';
import 'model/farm_menu_model.dart';

/// TODO: Language
class FarmMenuHelper {
  static FarmMenuModel getFarmMenuModel(Farm farm) {
    return FarmMenuModel(title: _getTitle(farm), models: _getItemModels(farm));
  }

  static String _getTitle(Farm farm) {
    switch (farm.farmController.farmState) {
      case FarmState.notBought:
        return 'Purchase the Farm?';

      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
      case FarmState.treesAndCropsButCropsWaiting:
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
      case FarmState.functioning:
      case FarmState.functioningOnlyTrees:
      case FarmState.functioningOnlyCrops:
      case FarmState.notFunctioning:
        return [
          _getSoilHealth(farm),
          _getFarmComposition(farm),
          _getFarmHistory(farm),
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
      image: GameIcons.buyFarm,
      data: FarmMenuItemData(
        data: GameUtils.farmInitialPrice.formattedRupees,
        image: GameIcons.coin,
      ),
    );
  }

  /// soil health
  static FarmMenuItemModel _getSoilHealth(Farm farm) {
    return FarmMenuItemModel(
      text: 'Soil Health',
      option: FarmMenuOption.soilHealth,
      bgColor: Colors.amber,
      image: GameIcons.soilHealth,
      data: FarmMenuItemData(
        data: '${farm.farmController.soilHealthPercentage} %',
        image: null,
      ),
    );
  }

  /// farm composition
  static FarmMenuItemModel _getFarmComposition(Farm farm) {
    return const FarmMenuItemModel(
      text: 'Content',
      option: FarmMenuOption.composition,
      bgColor: Colors.blue,
      image: GameIcons.composition,
    );
  }

  /// farm history
  static FarmMenuItemModel _getFarmHistory(Farm farm) {
    return const FarmMenuItemModel(
      text: 'History',
      option: FarmMenuOption.history,
      bgColor: Colors.white,
      image: GameIcons.history,
    );
  }

  static String _titleFrom(FarmMenuOption menuOption) {
    switch (menuOption) {
      case FarmMenuOption.buyFarm:
        return 'Buy Farm?';

      case FarmMenuOption.soilHealth:
        return 'Soil Health';

      case FarmMenuOption.composition:
        return 'Composition';

      case FarmMenuOption.history:
        return 'History';
    }
  }

  static DialogType _dialogType(FarmMenuOption menuOption) {
    switch (menuOption) {
      case FarmMenuOption.buyFarm:
        return DialogType.small;

      case FarmMenuOption.soilHealth:
      case FarmMenuOption.composition:
      case FarmMenuOption.history:
        return DialogType.large;
    }
  }

  static Future<bool> onMenuItemTap({
    required FarmMenuOption menuOption,
    required BuildContext context,
    required Farm farm,
  }) async {
    final response = await showGeneralDialog(
      barrierLabel: 'Dialog for ${menuOption.name}',
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      context: context,
      transitionDuration: Duration.zero,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return DialogContainer(
          title: _titleFrom(menuOption),
          dialogType: _dialogType(menuOption),
          child: () {
            switch (menuOption) {
              case FarmMenuOption.buyFarm:
                return PurchaseFarmDialog(farm: farm);

              case FarmMenuOption.soilHealth:
                return SoilHealthDialog();

              case FarmMenuOption.composition:
                return FarmCompositionDialog();

              case FarmMenuOption.history:
                return FarmHistoryDialog();
            }
          }(),
        );
      },
    );

    if (response is bool) return response;
    return false;
  }
}
