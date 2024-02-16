import '../../../../../../../utils/month.dart';

class HarvestPeriod {
  final Month sowMonth;
  final Month harvestMonth;

  HarvestPeriod({required this.sowMonth, required this.harvestMonth});

  bool contains(Month month) {
    return (month >= sowMonth) && (month <= harvestMonth);
  }
}
