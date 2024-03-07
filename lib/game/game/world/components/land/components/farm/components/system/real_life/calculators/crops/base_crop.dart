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

  List<HarvestPeriod> sowData();

  DateTime getNextSowDateFrom(DateTime currentDateTime) {
    final monthsDateTime = <DateTime>[];

    for (final month in sowData()) {
      final monthNumber = month.sowMonth.index + 1;

      DateTime monthDateTime;
      if (monthNumber < currentDateTime.month) {
        // If the month has already passed this year, use the next year
        monthDateTime = DateTime(currentDateTime.year + 1, monthNumber, 1);
      } else {
        // Else, use this year
        monthDateTime = DateTime(currentDateTime.year, monthNumber, 1);
      }

      monthsDateTime.add(monthDateTime);
    }

    return monthsDateTime.where((date) => date.isAfter(currentDateTime)).reduce(
          (a, b) => a.isBefore(b) ? a : b,
        );
  }

  // Age is calculated including sowing month and excluding harvest month
  int get maxAgeInMonths;

  int get getSellingPricePerKg => CropMarket.pricePerQty(cropType());

  bool canSow(Month month) {
    return sowData().any((period) => period.sowMonth == month);
  }

  bool canHarvest(int cropAgeInDays) {
    int cropAgeInMonths = cropAgeInDays ~/ 30;
    return cropAgeInMonths == maxAgeInMonths;
  }

  CropStage getCropStage(int cropAgeInDays) {
    final growthFactor = (cropAgeInDays / (maxAgeInMonths * 30));

    switch (growthFactor) {
      case < .1:
        return CropStage.germination;

      case < .3:
        return CropStage.sprouting;

      case < .8:
        return CropStage.flourishing;

      case <= 1.0:
        return CropStage.ripe;
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
