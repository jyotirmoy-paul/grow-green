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
  int getSellingPricePerKg() => CropMarket.pricePerQty(cropType());

  bool canSow(Month month) {
    return harvestData().any((period) => period.sowMonth == month);
  }

  bool canHarvest(int cropAgeInDays) {
    /// TODO: Implement can harvest in crop age
    // return harvestData().any((period) => period.harvestMonth == month);
    return cropAgeInDays > 100;
  }

  CropStage getCropStage(int cropAgeInDays) {
    /// TODO: Implement crop stage functionality depending on crop age!
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
