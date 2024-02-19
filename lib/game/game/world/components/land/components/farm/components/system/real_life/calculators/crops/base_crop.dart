import 'dart:ffi';

import '../../../../../../../../../../../../services/log/log.dart';
import '../../../../../../../../utils/month.dart';
import '../../../../crop/enums/crop_stage.dart';
import '../../../../crop/enums/crop_type.dart';
import '../../../model/harvest_period.dart';
import '../../../model/qty.dart';
import 'crop_market.dart';
import 'types/bajra.dart';
import 'types/banana.dart';
import 'types/groundnut.dart';
import 'types/maize.dart';
import 'types/pepper.dart';
import 'types/wheat.dart';

abstract class BaseCropCalculator {
  static const tag = 'BaseCropCalculator';

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
    final growthFactor = (cropAgeInDays / (maxAgeInMonths * 30));

    switch (growthFactor) {
      case < .1:
        return CropStage.sowing;

      case < .3:
        return CropStage.seedling;

      case < .8:
        return CropStage.flowering;

      case < 1.0:
        return CropStage.maturity;
    }

    throw Exception('$tag: getCropStage: invalid growthFactor value: $growthFactor');
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
