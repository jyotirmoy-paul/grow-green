import '../../../../../services/game_services/monetary/models/money_model.dart';
import 'achievements_model.dart';
import 'offer.dart';

class AchievementsCheckpoints {
  static const List<double> soilHealths = [1.5, 2, 3, 4, 5, 6];
  static const List<double> lands = [1, 2, 3, 4, 5, 6];

  final AchievementType achievementType;
  const AchievementsCheckpoints({required this.achievementType});
  List<double> get checkPointList {
    switch (achievementType) {
      case AchievementType.lands:
        return lands;
      case AchievementType.soilHealth:
        return soilHealths;
    }
  }

  Offer getOfferForCheckpoint(double checkPoint) {
    // TODO : Add offer based on previousSH
    final money = MoneyModel(value: 10000);
    return MoneyOffer(money: money);
  }
}
