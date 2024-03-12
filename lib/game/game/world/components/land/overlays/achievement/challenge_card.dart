import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../utils/extensions/num_extensions.dart';
import '../../../../../../../utils/text_styles.dart';
import '../../../../../../../widgets/flip_card/flip_card_controller.dart';
import '../../../../../../../widgets/game_button.dart';
import '../../../../../../../widgets/shadowed_container.dart';
import '../../../../../../../widgets/stylized_text.dart';
import '../../../../../../utils/game_icons.dart';
import '../farm_composition_dialog/widgets/menu_item_flip_skeleton.dart';
import '../farm_composition_dialog/widgets/system_item_widget.dart';
import 'achievement_card.dart';
import 'models/challenges_model.dart';
import 'models/offer.dart';

class ChallengeCard extends StatefulWidget {
  final ChallengeModel challenge;
  final Function(GwalletOffer offer) onClaim;
  final Function(GwalletOffer offer) onGwalletClaim;
  final Color bgColor;
  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onClaim,
    required this.onGwalletClaim,
    required this.bgColor,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  late FlipCardController _flipCardController;
  bool showAnimation = false;

  AchievementCardState get state {
    if (widget.challenge.isAchieved) {
      if (widget.challenge.isClaimed) {
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
    await widget.onClaim(widget.challenge.offer);
    _flipCardController.toggleCard();
    setState(() {
      showAnimation = true;
    });
  }

  Future<void> gwalletClaim() async {
    await widget.onGwalletClaim(widget.challenge.offer);
    _flipCardController.toggleCard();
    setState(() {
      showAnimation = true;
    });

    // TODO : SHOW Gwallet Claimed Animation
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ShadowedContainer(
          width: 300.s,
          height: 400.s,
          padding: EdgeInsets.symmetric(horizontal: 26.s, vertical: 24.s),
          child: MenuItemFlipSkeleton(
            flipCardController: _flipCardController,
            bgColor: widget.bgColor,
            header: _header,
            backHeader: _header,
            body: _front,
            backBody: _unlockedClaimedBody,
          ),
        ),
      ],
    );
  }

  Widget get _header {
    return Center(child: StylizedText(text: Text(widget.challenge.label, style: TextStyles.s23)));
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

  Widget get _lockedBody {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MenuFooterTextRow(
          leftText: "Soil health",
          rightText: widget.challenge.avgSoilHealth.toStringAsFixed(1),
        ),
        MenuFooterTextRow(
          leftText: "Money",
          rightText: "${widget.challenge.bankBalance.toDouble() / 1000000}M",
        ),
        MenuFooterTextRow(
          leftText: "Years passed",
          rightText: widget.challenge.timePassedInYears.toString(),
        ),
        MenuFooterTextRow(
          leftText: "Lands bought",
          rightText: widget.challenge.landsBought.toString(),
        )
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
            GameIcons.coinsPile,
            fit: BoxFit.contain,
            height: 30.s,
          ),
        ),
        Gap(8.s),
        StylizedText(text: Text(widget.challenge.offer.value.formattedValue, style: TextStyles.s23)),
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
            StylizedText(text: Text("Congrats!!", style: TextStyles.s23)),
            Gap(16.s),
            _moneyOfferWidget,
            Gap(16.s),
            SizedBox(
              width: 200.s,
              child: GameButton.text(
                text: "CLAIM",
                onTap: () async {
                  await claim();
                },
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Gap(20.s),
            SizedBox(
              width: 200.s,
              child: GameButton.text(
                text: "Add to Gwallet",
                onTap: () async {
                  await gwalletClaim();
                },
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _unlockedClaimedBody {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StylizedText(text: Text("Congrats!!", style: TextStyles.s23)),
            Gap(16.s),
            _moneyOfferWidget,
          ],
        ),
        if (showAnimation)
          LottieBuilder.asset(
            GameIcons.confettiLottie,
            fit: BoxFit.contain,
            repeat: false,
          ),
      ],
    );
  }
}
