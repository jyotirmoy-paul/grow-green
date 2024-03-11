import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/dialog_container.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../../widgets/stylized_text.dart';
import 'achievement_card.dart';
import 'achievements_model.dart';
import 'achievements_service.dart';
import 'package:flutter/material.dart';

import 'current_data_fetcher.dart';

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      title: "Achievement",
      dialogType: DialogType.medium,
      child: Center(
        child: Column(
          children: [
            _headers,
            achievementCards,
            _description,
          ],
        ),
      ),
    );
  }

  Widget get _headers {
    return Padding(
      padding: EdgeInsets.only(top: 15.s),
      child: SizedBox(
        width: 300.s,
        height: 50.s,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GameButton.text(
                text: "Soil health",
                onTap: () => setState(() => _selectedAchievementType = AchievementType.soilHealth),
                color: _isSoilHealthSelected ? _selectedColor : unselectedColor,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get achievementCards {
    final checkpoints = widget.achievementsService.achievementsModel.checkpoints(_selectedAchievementType);
    final achievementCards = checkpoints.map((checkpoint) {
      return AchievementCard(
        bgColor: _isSoilHealthSelected ? Colors.green : Colors.deepPurple,
        checkpoint: checkpoint,
        onClaim: (offer) async {
          await widget.achievementsService.claim(checkpoint);
          setState(() {});
        },
      );
    }).toList();
    int firstUnclaimed = _initialScrollOffset(checkpoints);
    return SizedBox(
      key: ValueKey(_selectedAchievementType),
      height: 300.s,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        controller: ScrollController(
          initialScrollOffset: 300.s * (firstUnclaimed),
        ),
        children: achievementCards,
      ),
    );
  }

  int _initialScrollOffset(List<CheckPointModel> checkpoints) {
    final firstUnclaimed = checkpoints.indexWhere((element) => !element.isClaimed);

    return firstUnclaimed == -1 ? 0 : firstUnclaimed;
  }

  Widget get _description {
    final dataFetcher = CurrentDataFetcher(game: widget.achievementsService.game);
    final currentDataValue = dataFetcher.currentValue(_selectedAchievementType);
    final currentDataRepresentation = switch (_selectedAchievementType) {
      AchievementType.lands => "Lands purchased \t:\t ${currentDataValue.toInt()} / ${dataFetcher.totalLandsAvailable}",
      AchievementType.soilHealth => "Average Soil health \t:\t ${currentDataValue.roundToDouble()}%",
    };

    return Container(
      decoration: BoxDecoration(
        color: _selectedColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.s),
        border: Border.all(color: _selectedColor, width: 2.s),
      ),
      padding: EdgeInsets.all(10.s),
      child: StylizedText(text: Text(currentDataRepresentation, style: TextStyles.s16)),
    );

    // return MenuFooterTextRow(leftText: currentDataRepresentation, rightText: "");
  }
}
