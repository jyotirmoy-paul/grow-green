import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../components/farm/components/system/enum/growable.dart';
import '../../../components/farm/model/harvest_model.dart';

/// class that merges multiple repetative harvest models into one
class MergedHarvestModel {
  final Growable growable;
  final int noOfMergedItems;
  final HarvestType harvestType;
  final double yield;

  /// total aggregated revenue for all merged items
  final MoneyModel totalRevenue;

  /// start date and end date would be same for noOfMergedItems = 1
  final DateTime startDate;
  final DateTime endDate;

  /// only useful for when trees are sold
  final int age;

  MergedHarvestModel({
    required this.growable,
    required this.noOfMergedItems,
    required this.harvestType,
    required this.yield,
    required this.totalRevenue,
    required this.startDate,
    required this.endDate,
    required this.age,
  });

  MergedHarvestModel copyWith({
    Growable? growable,
    int? noOfMergedItems,
    HarvestType? harvestType,
    double? yield,
    MoneyModel? totalRevenue,
    DateTime? startDate,
    DateTime? endDate,
    int? age,
  }) {
    return MergedHarvestModel(
      growable: growable ?? this.growable,
      noOfMergedItems: noOfMergedItems ?? this.noOfMergedItems,
      harvestType: harvestType ?? this.harvestType,
      yield: yield ?? this.yield,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      age: age ?? this.age,
    );
  }

  static List<MergedHarvestModel> generateMergedHarvestModelFrom(List<HarvestModel> harvestModels) {
    final mergedHarvestModels = <MergedHarvestModel>[];

    for (var i = 0; i < harvestModels.length; i++) {
      final currentModel = harvestModels[i];

      if (i == 0 ||
          currentModel.harvestType != harvestModels[i - 1].harvestType ||
          currentModel.growable != harvestModels[i - 1].growable) {
        mergedHarvestModels.add(
          MergedHarvestModel(
            growable: currentModel.growable,
            noOfMergedItems: 1,
            harvestType: currentModel.harvestType,
            yield: currentModel.yield,
            totalRevenue: currentModel.revenue,
            startDate: currentModel.dateOfHarvest,
            endDate: currentModel.dateOfHarvest,
            age: currentModel.ageInDaysAtHarvest,
          ),
        );
      } else {
        final previousMergedModel = mergedHarvestModels.removeLast();

        mergedHarvestModels.add(
          previousMergedModel.copyWith(
            noOfMergedItems: previousMergedModel.noOfMergedItems + 1,
            totalRevenue: previousMergedModel.totalRevenue + currentModel.revenue,
            endDate: currentModel.dateOfHarvest,
          ),
        );
      }
    }

    return mergedHarvestModels;
  }
}
