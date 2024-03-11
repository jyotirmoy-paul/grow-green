import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/flip_card/flip_card_controller.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../../utils/game_assets.dart';
import '../farm_composition_dialog/widgets/menu_item_flip_skeleton.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../farm_composition_dialog/widgets/system_item_widget.dart';
import 'achievements_model.dart';
import 'offer.dart';

class AchievementCard extends StatefulWidget {
  final CheckPointModel checkpoint;
  final Function(MoneyOffer offer) onClaim;
  const AchievementCard({
    super.key,
    required this.bgColor,
    required this.checkpoint,
    required this.onClaim,
  });

  final Color bgColor;

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

enum AchievementCardState {
  locked,
  unlockedNotClaimed,
  unlockedClaimed,
}

class _AchievementCardState extends State<AchievementCard> with SingleTickerProviderStateMixin {
  late FlipCardController _flipCardController;
  bool showAnimation = false;

  AchievementCardState get state {
    if (widget.checkpoint.isAchieved) {
      if (widget.checkpoint.isClaimed) {
        return AchievementCardState.unlockedClaimed;
      } else {
        return AchievementCardState.unlockedNotClaimed;
      }
    } else {
      return AchievementCardState.locked;
    }
  }

  @override
  void initState() {
    super.initState();
    _flipCardController = FlipCardController();
  }

  Future<void> claim() async {
    await widget.onClaim(widget.checkpoint.offer);
    _flipCardController.toggleCard();
    setState(() {
      showAnimation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.s,
      height: 250.s,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.s, vertical: 24.s),
        child: MenuItemFlipSkeleton(
          flipCardController: _flipCardController,
          bgColor: widget.bgColor,
          body: _front,
          backBody: _unlockedClaimedBody,
        ),
      ),
    );
  }

  Widget get _front {
    switch (state) {
      case AchievementCardState.locked:
        return _lockedBody;
      case AchievementCardState.unlockedNotClaimed:
        return _unlockedNotClaimedBody;
      case AchievementCardState.unlockedClaimed:
        return _unlockedClaimedBody;
    }
  }

  Column get _lockedBody {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StylizedText(
          text: Text("Required", style: TextStyles.s23),
        ),
        lockedRibbon,
        StylizedText(
          text: Text(requiredParameter, style: TextStyles.s23),
        ),
      ],
    );
  }

  Widget get lockedRibbon {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 16.s,
          width: 248.s,
          decoration: BoxDecoration(
              color: widget.bgColor.darken(0.2),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.white,
                  width: 1.s,
                ),
              )),
        ),
        Container(
          width: 64.s,
          height: 64.s,
          decoration: BoxDecoration(
            color: widget.bgColor.darken(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.s,
            ),
          ),
          child: StylizedText(
            text: Text(
              _lockedValueString,
              style: TextStyles.s16,
            ),
          ),
        ),
      ],
    );
  }

  String get _lockedValueString {
    switch (widget.checkpoint.achievementType) {
      case AchievementType.soilHealth:
        return widget.checkpoint.value.toString();
      case AchievementType.lands:
        return widget.checkpoint.value.round().toString();
    }
  }

  String get requiredParameter {
    return switch (widget.checkpoint.achievementType) {
      AchievementType.soilHealth => "Soil Health",
      AchievementType.lands => "Land",
    };
  }

  String get unlockHeaderText {
    return switch (widget.checkpoint.achievementType) {
      AchievementType.soilHealth => "${widget.checkpoint.value.toStringAsFixed(1)}%",
      AchievementType.lands => "${widget.checkpoint.value.round().ordinalized} Land",
    };
  }

  Widget get _unlockedClaimedBody {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StylizedText(text: Text("Unlocked $unlockHeaderText", style: TextStyles.s23)),
            _moneyOfferWidget,
          ],
        ),
        if (showAnimation)
          LottieBuilder.asset(
            GameAssets.confettiLottie,
            fit: BoxFit.contain,
            repeat: false,
          ),
      ],
    );
  }

  Widget get _unlockedNotClaimedBody {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StylizedText(text: Text("Unlocked $unlockHeaderText", style: TextStyles.s23)),
            Gap(16.s),
            _moneyOfferWidget,
            Gap(16.s),
            SizedBox(
              width: 150.s,
              child: GameButton.text(
                text: "CLAIM",
                onTap: () async {
                  await claim();
                },
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _moneyOfferWidget {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BackgroundGlow(
          dimension: 15.s,
          child: Image.asset(
            GameAssets.coinsPile,
            fit: BoxFit.contain,
            height: 30.s,
          ),
        ),
        Gap(8.s),
        StylizedText(text: Text(widget.checkpoint.offer.money.formattedValue, style: TextStyles.s23)),
      ],
    );
  }
}

extension on int {
  String get ordinalized {
    switch (this) {
      case 1:
        return "1st";
      case 2:
        return "2nd";
      case 3:
        return "3rd";
      default:
        return "${this}th";
    }
  }
}
