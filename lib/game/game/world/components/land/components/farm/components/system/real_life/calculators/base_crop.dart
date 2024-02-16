import 'package:growgreen/game/game/world/components/land/components/farm/components/system/real_life/calculators/crop_market.dart';

import '../../../../../../../utils/month.dart';
import 'crops/bajra.dart';
import 'crops/banana.dart';
import 'crops/groundnut.dart';
import 'crops/maize.dart';
import 'crops/pepper.dart';
import 'crops/wheat.dart';
import 'qty.dart';
import 'harvest_period.dart';
import '../../../crop/enums/crop_type.dart';

abstract class BaseCropCalculator {
  CropType cropType();
  double getYieldKgPerSquareM();
  Qty getSeedsRequiredPerHacter();
  List<HarvestPeriod> harvestData();
  int getSellingPricePerKg() => CropMarket.pricePerQty(cropType());

  bool canSow(Month month) {
    return harvestData().any((period) => period.sowMonth == month);
  }

  bool canHarvest(Month month) {
    return harvestData().any((period) => period.harvestMonth == month);
  }

  static BaseCropCalculator fromCropType(CropType cropType) {
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
      default:
        throw Exception('Crop type not found');
    }
  }
}
