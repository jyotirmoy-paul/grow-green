import '../../../../../utils/month.dart';
import '../../../../components/farm/asset/crop_asset.dart';
import '../../../../components/farm/components/crop/enums/crop_stage.dart';
import '../../../../components/farm/components/crop/enums/crop_type.dart';
import '../../../../components/farm/components/system/real_life/calculators/crops/base_crop.dart';
import '../../../../components/farm/components/system/real_life/utils/cost_calculator.dart';

class CropRevenueDataFetcher {
  final CropType cropType;

  CropRevenueDataFetcher({required this.cropType});

  BaseCropCalculator get crop => BaseCropCalculator.fromCropType(cropType);

  List<String> get intervals {
    final sowMonths = crop.sowData().map((e) => e.sowMonth);

    // calculate harvest months
    final cropAge = crop.maxAgeInMonths;
    final harvestMonths = sowMonths.map((sowMonth) {
      final sowMonthIndex = sowMonth.index;
      final harvestMonthIndex = (sowMonthIndex + cropAge) % 12;
      return Month.values[harvestMonthIndex];
    });

    // Handle the case where the crop can be sown and harvested in any month
    final totalPeriods = sowMonths.length;
    if (totalPeriods == 12) return ["Any Month"];

    // Generate the periods
    final periods = <String>[];
    for (var i = 0; i < totalPeriods; i++) {
      final sowMonth = sowMonths.elementAt(i);
      final harvestMonth = harvestMonths.elementAt(i);
      periods.add("${sowMonth.name} - ${harvestMonth.name}");
    }
    return periods;
  }

  double get revenuePerKgSeedSown {
    final seedsRequriedPerSquareM = crop.getSeedsRequiredPerHacter().value / 10000;
    final yieldKgPerUnitSeedQty = crop.getYieldKgPerSquareM() / seedsRequriedPerSquareM;
    return yieldKgPerUnitSeedQty * crop.getSellingPricePerKg;
  }

  int get costPerSeed {
    final unitQty = crop.getSeedsRequiredPerHacter().copyWith(value: 1);
    return CostCalculator.seedCost(seedsRequired: unitQty, cropType: cropType);
  }

  String get germinationAssetPath => CropAsset.of(cropType).at(CropStage.germination);
  String get ripeAssetPath => CropAsset.of(cropType).at(CropStage.ripe);
}
