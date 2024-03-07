import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../components/farm/model/harvest_model.dart';

class HarvestRevenueDataPoint {
  final int year;
  final MoneyModel revenue;

  const HarvestRevenueDataPoint({
    required this.year,
    required this.revenue,
  });

  static List<HarvestRevenueDataPoint> generateRevenueDataPoint(List<HarvestModel> harvestModels) {
    final revenueMap = <int, MoneyModel>{};

    MoneyModel cumulativeRevenue = MoneyModel.zero();

    for (final model in harvestModels.reversed) {
      final year = model.dateOfHarvest.year;
      final revenue = model.revenue;
      cumulativeRevenue += revenue;
      revenueMap[year] = cumulativeRevenue;
    }

    final dataPoint = <HarvestRevenueDataPoint>[];

    /// populate data point list
    for (final it in revenueMap.entries) {
      dataPoint.add(
        HarvestRevenueDataPoint(year: it.key, revenue: it.value),
      );
    }

    /// sort as per year
    dataPoint.sort((a, b) => a.year.compareTo(b.year));

    return dataPoint;
  }
}
