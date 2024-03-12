// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../../../../../grow_green_game.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../../../services/game_services/time/time_service.dart';
import '../../components/farm/enum/farm_state.dart';
import 'models/achievements_model.dart';

class CurrentDataFetcher {
  final GrowGreenGame game;

  CurrentDataFetcher({required this.game});

  double get landsBought {
    final farms = game.gameController.world.worldController.land.landController.farms;
    final totalFarms = farms.length;

    // non-purchased farms
    final nonPurchasedFarms = farms.where((farm) => farm.farmController.farmState == FarmState.notBought).toList();
    final totalNonPurchasedFarms = nonPurchasedFarms.length;

    return (totalFarms - totalNonPurchasedFarms).toDouble(); // purchased farms
  }

  double get avgSoilHealth {
    final farms = game.gameController.world.worldController.land.landController.farms;
    final purchasedFarms = farms.where((farm) => farm.farmController.farmState != FarmState.notBought).toList();
    if (purchasedFarms.isEmpty) return 0;
    final soilHealths = purchasedFarms.map((farm) => farm.farmController.soilHealthPercentage).toList();
    return soilHealths.average;
  }

  Duration get totalTimePassed {
    final startDate = game.gameController.world.worldController.land.landController.startTime;
    final currentDate = TimeService().currentDateTime;
    return currentDate.difference(startDate);
  }

  double currentCheckpointValue(AchievementType achievementType) {
    switch (achievementType) {
      case AchievementType.soilHealth:
        return avgSoilHealth;

      case AchievementType.lands:
        return landsBought;

      case AchievementType.challenge:
        return 0;
    }
  }

  int get totalLandsAvailable {
    final farms = game.gameController.world.worldController.land.landController.farms;
    return farms.length;
  }

  MoneyModel get bankBalance {
    return game.monetaryService.balance;
  }
}
