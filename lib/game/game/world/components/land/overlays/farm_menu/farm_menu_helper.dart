import 'package:flutter/material.dart';

import '../../../../../../utils/game_utils.dart';
import '../../components/farm/enum/farm_state.dart';
import '../../components/farm/farm.dart';
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
      image: '',
      data: FarmMenuItemData(
        data: GameUtils.farmInitialPrice.formattedRupees,
        image: null,
      ),
    );
  }

  /// soil health
  static FarmMenuItemModel _getSoilHealth(Farm farm) {
    return FarmMenuItemModel(
      text: 'Soil Health',
      option: FarmMenuOption.soilHealth,
      bgColor: Colors.brown,
      image: '',
      data: FarmMenuItemData(
        data: '${farm.farmController.soilHealthPercentage} %',
        image: null,
      ),
    );
  }

  /// farm composition
  static FarmMenuItemModel _getFarmComposition(Farm farm) {
    return const FarmMenuItemModel(
      text: 'Composition',
      option: FarmMenuOption.composition,
      bgColor: Colors.white,
      image: '',
    );
  }

  /// farm history
  static FarmMenuItemModel _getFarmHistory(Farm farm) {
    return const FarmMenuItemModel(
      text: 'History',
      option: FarmMenuOption.history,
      bgColor: Colors.white,
      image: '',
    );
  }
}
