import 'dart:async';

import '../../../../../../../routes/routes.dart';
import '../../../../../../../services/log/log.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../grow_green_game.dart';
import '../../../../../services/game_services/monetary/enums/transaction_type.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import '../../../../../services/game_services/time/time_service.dart';
import 'achievements_dialog.dart';
import 'achievements_model.dart';
import 'current_data_fetcher.dart';
import 'offer.dart';

class AchievementsService {
  static const tag = 'AchievementsService';

  final GrowGreenGame game;
  AchievementsModel achievementsModel = AchievementsModel.defaultAchievements;

  AchievementsService({required this.game});

  final StreamController<int> _unclaimedAchievementsStream = StreamController.broadcast();
  Stream<int> get unclaimedAchievementsStream => _unclaimedAchievementsStream.stream;
  Future<void> initialize() async {
    try {
      achievementsModel = await game.gameController.gameDatastore.getAchievements();
      TimeService().dateTimeStream.listen(onTick);
    } catch (e) {
      Log.e('$tag: $e');
    }
  }

  void onTick(DateTime dateTime) {
    _updateAchievements();
    _unclaimedAchievementsStream.add(achievementsModel.numberOfUnclaimedAchievements);
  }

  void _updateAchievements() {
    for (final achievementType in AchievementType.values) {
      _updateAchievement(achievementType);
    }
  }

  void _updateAchievement(AchievementType achievementType) async {
    final currentDataValue = CurrentDataFetcher(game: game).currentValue(achievementType);

    // update all the smaller checkpoints to isAchieved = true
    final checkpoints = achievementsModel
        .checkpoints(achievementType)
        .map((checkpoint) => checkpoint.copyWith(isAchieved: checkpoint.value <= currentDataValue))
        .toList();

    for (final checkpoint in checkpoints) {
      if (checkpoint.isAchieved) {
        Log.i("message: ${checkpoint.achievementType.name} Achievement Unlocked $checkpoint");
      }
    }

    achievementsModel.updateCheckpoints(achievementType, checkpoints);
  }

  void showNewSoilHealthAchievementNotification() {
    Utils.showNonAnimatedDialog(
      barrierLabel: "Achievements",
      context: Navigation.navigationKey.currentContext!,
      builder: (context) {
        return AchievementsDialog(
          achievementsService: this,
        );
      },
    );
  }

  void processOffer(Offer offer) async {
    if (offer is MoneyOffer) {
      final success = await game.monetaryService.transact(
        transactionType: TransactionType.credit,
        value: offer.money,
      );
      if (!success) {
        throw Exception("Error in processing Moneyoffer");
      }
    }
  }

  Future<void> claim(CheckPointModel checkpoint) async {
    game.monetaryService.transact(transactionType: TransactionType.credit, value: checkpoint.offer.money);
    final newCheckpoints = achievementsModel
        .checkpoints(checkpoint.achievementType)
        .map((e) => e.copyWith(isClaimed: e.isClaimed ? true : e.value == checkpoint.value))
        .toList();

    achievementsModel.updateCheckpoints(checkpoint.achievementType, newCheckpoints);

    await game.gameController.gameDatastore.updateAchievements(achievementsModel);
  }
}
