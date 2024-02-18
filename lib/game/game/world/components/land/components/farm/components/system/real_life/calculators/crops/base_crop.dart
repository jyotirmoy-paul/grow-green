import '../../../../../../../../utils/month.dart';
import '../../../../crop/enums/crop_stage.dart';
import '../../../../crop/enums/crop_type.dart';
import 'crop_market.dart';
import 'types/bajra.dart';
import 'types/banana.dart';
import 'types/groundnut.dart';
import 'types/maize.dart';
import 'types/pepper.dart';
import 'types/wheat.dart';
import '../../../model/harvest_period.dart';
import '../../../model/qty.dart';

abstract class BaseCropCalculator {
  BaseCropCalculator();

  CropType cropType();
  double getYieldKgPerSquareM();
  Qty getSeedsRequiredPerHacter();
  List<HarvestPeriod> harvestData();

  // Age is calculated including sowing month and excluding harvest month
  int get maxAgeInMonths;

  int getSellingPricePerKg() => CropMarket.pricePerQty(cropType());

  bool canSow(Month month) {
    return harvestData().any((period) => period.sowMonth == month);
  }

  bool canHarvest(int cropAgeInDays) {
    int cropAgeInMonths = cropAgeInDays ~/ 30;
    return cropAgeInMonths == maxAgeInMonths;
  }

  CropStage getCropStage(int cropAgeInDays) {
    int cropAgeInMonths = cropAgeInDays ~/ 30;
    int percentageGrowth = (cropAgeInMonths / maxAgeInMonths * 100).round();

    switch (percentageGrowth) {
      case < 10:
        return CropStage.sowing;
      case < 30:
        return CropStage.seedling;
      case < 80:
        return CropStage.flowering;
      case < 100:
        return CropStage.maturiy;
    }

    return CropStage.flowering;
  }

  factory BaseCropCalculator.fromCropType(CropType cropType) {
    switch (cropType) {
      case CropType.bajra:
        return BajraCropCalculator();

      case CropType.pepper:
        return PepperCropCalculator();

      case CropType.wheat:
        return WheatCropCalculator();

      case CropType.groundnut:
        return GroundnutCropCalculator();

      case CropType.banana:
        return BananaCropCalculator();

      case CropType.maize:
        return MaizeCropCalculator();
    }
  }
}
