import 'dart:math' as math;

import '../../../../../../../utils/game_utils.dart';
import '../../../../../../enums/system_type.dart';
import '../../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../../../components/farm/model/soil_health_model.dart';
import '../enum/soil_health_movement.dart';

class MergedSoilHealthModel {
  final SoilHealthMovement soilHealthMovement;
  final int year;
  final double soilHealth;

  /// a contributor can be a good or bad contributor
  final List<SoilHealthContributor> contributors;

  MergedSoilHealthModel({
    required this.soilHealthMovement,
    required this.year,
    required this.soilHealth,
    required this.contributors,
  });

  static (double, double) minMaxSoilHealth(List<MergedSoilHealthModel> mergedSoilHealthData) {
    double min = double.infinity;
    double max = double.negativeInfinity;

    for (final d in mergedSoilHealthData) {
      min = math.min(d.soilHealth, min);
      max = math.max(d.soilHealth, max);
    }

    return (min, max);
  }

  static List<MergedSoilHealthModel> generateMergedSoilHealthModel(List<SoilHealthModel> soilHealthModels) {
    /// sort
    soilHealthModels.sort((a, b) => a.recordedOnDate.compareTo(b.recordedOnDate));

    final soilHealthModelsMap = <int, List<SoilHealthModel>>{};

    /// segregate data as per record year
    for (final model in soilHealthModels) {
      final key = model.recordedOnDate.year;

      if (soilHealthModelsMap.containsKey(key)) {
        soilHealthModelsMap[key]!.add(model);
      } else {
        soilHealthModelsMap[key] = [model];
      }
    }

    final data = <MergedSoilHealthModel>[];
    double lastYearSoilHealth = GameUtils.startingSoilHealthInPercentage;

    for (final it in soilHealthModelsMap.entries) {
      double averageSoilHealthForYear = 0.0;
      final contributors = <SoilHealthContributor>[];

      for (final soilHealth in it.value) {
        averageSoilHealthForYear += soilHealth.currentSoilHealth;
        contributors.add(
          SoilHealthContributor(
            systemType: soilHealth.systemType,
            fertilizerType: soilHealth.fertilizerType,
            areTreesPresent: soilHealth.areTreesPresent,
          ),
        );
      }

      averageSoilHealthForYear /= it.value.length;

      final soilHealthMovement =
          averageSoilHealthForYear > lastYearSoilHealth ? SoilHealthMovement.up : SoilHealthMovement.down;

      lastYearSoilHealth = averageSoilHealthForYear;

      data.add(
        MergedSoilHealthModel(
          soilHealthMovement: soilHealthMovement,
          year: it.key,
          soilHealth: averageSoilHealthForYear,
          contributors: contributors,
        ),
      );
    }

    data.sort((a, b) => b.year.compareTo(a.year));

    return data;
  }
}

class SoilHealthContributor {
  final SystemType systemType;
  final FertilizerType? fertilizerType;
  final bool areTreesPresent;

  SoilHealthContributor({
    required this.systemType,
    required this.fertilizerType,
    required this.areTreesPresent,
  });
}
