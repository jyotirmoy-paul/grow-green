import '../../../../../../../services/log/log.dart';
import '../../../../../grow_green_game.dart';
import '../../components/farm/enum/farm_state.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'achievements_model.dart';

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

    for (final farm in purchasedFarms) {
      Log.d("message: farm: ${farm.farmId} ${farm.farmController.soilHealthPercentage}");
    }
    final soilHealths = purchasedFarms.map((farm) => farm.farmController.soilHealthPercentage).toList();
    return soilHealths.average;
  }

  double currentValue(AchievementType achievementType) {
    switch (achievementType) {
      case AchievementType.soilHealth:
        return avgSoilHealth;
      case AchievementType.lands:
        return landsBought;
    }
  }

  int get totalLandsAvailable {
    final farms = game.gameController.world.worldController.land.landController.farms;
    return farms.length;
  }
}
