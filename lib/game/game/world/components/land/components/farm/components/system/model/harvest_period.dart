import '../../../../../../utils/month.dart';

class HarvestPeriod {
  final Month sowMonth;

  HarvestPeriod({required this.sowMonth});

  bool contains(Month month) {
    return (month >= sowMonth);
  }
}
