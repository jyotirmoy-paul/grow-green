import 'dart:async';

import '../../../../../../../services/log/log.dart';
import '../../../../../grow_green_game.dart';
import '../../../../../services/game_services/monetary/enums/transaction_type.dart';
import '../../../../../services/game_services/time/time_service.dart';
import '../redeem/redeem_service.dart';
import 'models/achievements_model.dart';
import 'current_data_fetcher.dart';
import 'models/challenges_model.dart';
import 'models/offer.dart';

class AchievementsService {
  static const tag = 'AchievementsService';

  final GrowGreenGame game;
  AchievementsModel achievementsModel = AchievementsModel.defaultAchievements;
  ChallengesModel challengesModel = ChallengesModel.defaultChallenges;

  AchievementsService({required this.game});

  // stream of unclaimed achievements and challenges
  final StreamController<int> _unclaimedStream = StreamController.broadcast();
  Stream<int> get unclaimedAchievementsStream => _unclaimedStream.stream;
  Future<void> initialize() async {
    try {
      achievementsModel = await game.gameController.gameDatastore.getAchievements();
      challengesModel = await game.gameController.gameDatastore.getChallenges();

      TimeService().dateTimeStream.listen(onTick);
    } catch (e) {
      Log.e('$tag: $e');
    }
  }

  void onTick(DateTime dateTime) {
    _updateAchievements();
    _updateChallenges();
    _unclaimedStream.add(achievementsModel.numberOfUnclaimedAchievements + challengesModel.numberOfUnclaimedChallenges);
  }

  void _updateAchievements() {
    for (final achievementType in AchievementType.values) {
      _updateAchievement(achievementType);
    }
  }

  void _updateChallenges() {
    final currentDataFetcher = CurrentDataFetcher(game: game);
    final avgSoilHealth = currentDataFetcher.avgSoilHealth;
    final landsBought = currentDataFetcher.landsBought;
    final timePassed = currentDataFetcher.totalTimePassed;
    final bankBalance = currentDataFetcher.bankBalance;

    final updatedChallenges = challengesModel.challenges.map((challenge) {
      if (challenge.isAchieved) return challenge;
      final isSoilHealthAchieved = challenge.avgSoilHealth <= avgSoilHealth;
      final isLandsAchieved = challenge.landsBought <= landsBought;
      final isTimeAchieved = challenge.timePassedInYears <= (timePassed.inDays / 365);
      final isBankBalanceAchieved = challenge.bankBalance <= bankBalance.value;

      if (isSoilHealthAchieved && isLandsAchieved && isTimeAchieved && isBankBalanceAchieved) {
        return challenge.copyWith(isAchieved: true);
      } else {
        return challenge;
      }
    }).toList();

    challengesModel = challengesModel.copyWith(challenges: updatedChallenges);
  }

  void _updateAchievement(AchievementType achievementType) async {
    final currentDataValue = CurrentDataFetcher(game: game).currentCheckpointValue(achievementType);

    // update all the smaller checkpoints to isAchieved = true
    final checkpoints = achievementsModel
        .checkpoints(achievementType)
        .map((checkpoint) => checkpoint.copyWith(isAchieved: checkpoint.value <= currentDataValue))
        .toList();

    achievementsModel.updateCheckpoints(achievementType, checkpoints);
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

  Future<void> claimCheckpoint(CheckPointModel checkpoint) async {
    game.monetaryService.transact(transactionType: TransactionType.credit, value: checkpoint.offer.money);
    final newCheckpoints = achievementsModel
        .checkpoints(checkpoint.achievementType)
        .map((e) => e.copyWith(isClaimed: e.isClaimed ? true : e.value == checkpoint.value))
        .toList();

    achievementsModel.updateCheckpoints(checkpoint.achievementType, newCheckpoints);

    await game.gameController.gameDatastore.updateAchievements(achievementsModel);
  }

  Future<void> claimChallenge(ChallengeModel checkpoint) async {
    await RedeemService(game: game).redeemCode(checkpoint.offer.code);
    final newCheckpoints = challengesModel.challenges
        .map((e) => e.copyWith(isClaimed: e.isClaimed ? true : e.bankBalance == checkpoint.bankBalance))
        .toList();

    challengesModel = challengesModel.copyWith(challenges: newCheckpoints);
    await game.gameController.gameDatastore.updateChallenges(challengesModel);
  }
}
