import 'package:gap/gap.dart';

import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/extensions/list_extensions.dart';
import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/dialog_container.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../../widgets/stylized_text.dart';
import 'GwalletService.dart';
import 'achievement_card.dart';
import 'achievements_service.dart';
import 'package:flutter/material.dart';

import 'challenge_card.dart';
import 'current_data_fetcher.dart';
import 'models/achievements_model.dart';

class AchievementsDialog extends StatefulWidget {
  final AchievementsService achievementsService;
  const AchievementsDialog({
    super.key,
    required this.achievementsService,
  });

  @override
  State<AchievementsDialog> createState() => _AchievementsDialogState();
}

class _AchievementsDialogState extends State<AchievementsDialog> {
  AchievementType _selectedAchievementType = AchievementType.soilHealth;
  bool get _isSoilHealthSelected => _selectedAchievementType == AchievementType.soilHealth;
  bool get _isLandsSelected => _selectedAchievementType == AchievementType.lands;
  static const unselectedColor = Colors.grey;
  static const landSelectedColor = Colors.deepPurple;
  static const soilHealthSelectedColor = Colors.green;

  Color get _selectedColor {
    switch (_selectedAchievementType) {
      case AchievementType.lands:
        return landSelectedColor;
      case AchievementType.soilHealth:
        return soilHealthSelectedColor;
      case AchievementType.challenge:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      title: "Achievement",
      dialogType: DialogType.medium,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.s),
        child: Column(
          children: [
            _headers,
            Expanded(child: cards),
            _checkpointDescription,
          ],
        ),
      ),
    );
  }

  Widget get _headers {
    return SizedBox(
      width: 700.s,
      height: 60.s,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GameButton.text(
              text: "Challenges",
              onTap: () => setState(() => _selectedAchievementType = AchievementType.challenge),
              color: _selectedAchievementType == AchievementType.challenge ? _selectedColor : unselectedColor,
              textStyle: TextStyles.s26,
            ),
          ),
          Gap(20.s),
          Expanded(
            child: GameButton.text(
              text: "Soil health",
              onTap: () => setState(() => _selectedAchievementType = AchievementType.soilHealth),
              color: _isSoilHealthSelected ? _selectedColor : unselectedColor,
              textStyle: TextStyles.s26,
            ),
          ),
          Gap(20.s),
          Expanded(
            child: GameButton.text(
              text: "Lands",
              onTap: () {
                setState(() {
                  _selectedAchievementType = AchievementType.lands;
                });
              },
              color: _isLandsSelected ? _selectedColor : unselectedColor,
              textStyle: TextStyles.s26,
            ),
          ),
        ],
      ),
    );
  }

  Widget get cards {
    switch (_selectedAchievementType) {
      case AchievementType.lands:
      case AchievementType.soilHealth:
        return checkpointAchievementCards;
      case AchievementType.challenge:
        return challengeCards;
    }
  }

  Widget get challengeCards {
    final challenges = widget.achievementsService.challengesModel.challenges;
    final challengeCards = challenges.map((challenge) {
      return ChallengeCard(
        challenge: challenge,
        bgColor: _selectedColor,
        onClaim: (offer) async {
          await widget.achievementsService.claimChallenge(challenge);
          setState(() {});
        },
        onGwalletClaim: (offer) async {
          await GwalletService.claimGwalletFromChallenge(challenge);
          setState(() {});
        },
      );
    }).toList();

    return ListView(
      key: ValueKey(_selectedAchievementType),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: challengeCards,
    );
  }

  Widget get checkpointAchievementCards {
    final checkpoints = widget.achievementsService.achievementsModel.checkpoints(_selectedAchievementType);
    final achievementCards = checkpoints.map((checkpoint) {
      return AchievementCard(
        bgColor: _isSoilHealthSelected ? Colors.green : Colors.deepPurple,
        checkpoint: checkpoint,
        onClaim: (offer) async {
          await widget.achievementsService.claimCheckpoint(checkpoint);
          setState(() {});
        },
      );
    }).toList();
    int firstUnclaimed = _initialScrollOffset(checkpoints);
    return ListView(
      key: ValueKey(_selectedAchievementType),
      padding: EdgeInsets.all(20.s),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      controller: ScrollController(
        initialScrollOffset: 300.s * (firstUnclaimed),
      ),
      children: achievementCards.addSeparator(Gap(20.s)),
    );
  }

  int _initialScrollOffset(List<CheckPointModel> checkpoints) {
    final firstUnclaimed = checkpoints.indexWhere((element) => !element.isClaimed);
    return firstUnclaimed == -1 ? 0 : firstUnclaimed;
  }

  Widget get _checkpointDescription {
    // TODO : Add checkpoint description
    if (_selectedAchievementType == AchievementType.challenge) return const SizedBox.shrink();
    final dataFetcher = CurrentDataFetcher(game: widget.achievementsService.game);
    final currentDataValue = dataFetcher.currentCheckpointValue(_selectedAchievementType);
    final currentDataRepresentation = switch (_selectedAchievementType) {
      AchievementType.lands => "Lands purchased:\t ${currentDataValue.toInt()} / ${dataFetcher.totalLandsAvailable}",
      AchievementType.soilHealth => "Average Soil health:\t ${currentDataValue.roundToDouble()}%",
      AchievementType.challenge => "",
    };

    return Container(
      decoration: BoxDecoration(
        color: _selectedColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.s),
        border: Border.all(color: _selectedColor, width: 2.s),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.s, horizontal: 20.s),
      child: Text(
        currentDataRepresentation,
        style: TextStyles.s30.copyWith(
          color: AppColors.brown,
        ),
      ),
    );

    // return MenuFooterTextRow(leftText: currentDataRepresentation, rightText: "");
  }
}
