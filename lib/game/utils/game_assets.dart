import '../game/enums/agroforestry_type.dart';
import '../game/enums/farm_system_type.dart';
import '../game/enums/system_type.dart';
import '../game/world/components/land/components/farm/model/fertilizer/fertilizer_type.dart';

abstract class GameAssets {
  static const _base = 'assets/game_assets';

  /// general
  static const coin = '$_base/coin.png';
  static const minus = '$_base/minus_circle.png';
  static const plus = '$_base/plus_circle.png';
  static const positiveTriangle = '$_base/positive_triangle.png';
  static const negativeTriangle = '$_base/negative_triangle.png';

  /// fertilizers
  static String getFertilizerAssetFor(FertilizerType fertilizerType) {
    return switch (fertilizerType) {
      FertilizerType.organic => organicFertilizer,
      FertilizerType.chemical => chemicalFertilizer,
    };
  }

  static const chemicalFertilizer = '$_base/chemical_fertilizer.png';
  static const addChemicalFertilizer = '$_base/add_chemical_fertilizer.png';

  static const organicFertilizer = '$_base/organic_fertilizer.png';
  static const addOrganicFertilizer = '$_base/add_organic_fertilizer.png';

  /// crop seeds
  static const seeds = '$_base/seeds.png';
  static const addSeeds = '$_base/add_seeds.png';

  /// saplings
  static const sapling = '$_base/sapling.png';
  static const addSapling = '$_base/add_sapling.png';

  /// farm menu
  static const soilHealth = '$_base/soil_health.png';
  static const farmHistory = '$_base/farm_history.png';
  static const farmContent = '$_base/farm_content.png';
  static const farmMaintanence = '$_base/farm_maintanence.png';

  /// layouts
  static String getLayoutRepresentationFor(SystemType systemType) {
    if (systemType == FarmSystemType.monoculture) return monoculturePlantation;
    return switch (systemType as AgroforestryType) {
      AgroforestryType.alley => alleyPlanation,
      AgroforestryType.boundary => boundaryPlantation,
      AgroforestryType.block => blockPlantation,
    };
  }

  static const alleyPlanation = '$_base/alley.png';
  static const blockPlantation = '$_base/block.png';
  static const boundaryPlantation = '$_base/boundary.png';
  static const monoculturePlantation = '$_base/monoculture.png';

  static const itSeemsEmptyHere = '$_base/boundary.png';

  /// dialogs
  static const coinsPile = '$_base/coins_pile.png';
  static const buyFarm = '$_base/buy_farm.png';
  static const cutTree = '$_base/cut_tree.png';

  /// game stat
  static const achievements = '$_base/achievements.png';
  static const calender = '$_base/calender.png';
  static const temperature = '$_base/temperature.png';

  static const confettiLottie = '$_base/confetti.json';

  static const background = '$_base/background.jpg';
}
