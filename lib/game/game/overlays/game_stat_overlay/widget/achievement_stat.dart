import 'package:flutter/material.dart';

import '../../../../../routes/navigation.dart';
import '../../../../../utils/extensions/num_extensions.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/button_animator.dart';
import '../../../../../widgets/stylized_text.dart';
import '../../../../utils/game_assets.dart';
import '../../../world/components/land/overlays/achievement/achievements_dialog.dart';
import '../../../world/components/land/overlays/achievement/achievements_service.dart';
import 'stat_skeleton_widget.dart';

class AchievementsStat extends StatelessWidget {
  final AchievementsService achievementsService;
  const AchievementsStat({
    super.key,
    required this.achievementsService,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonAnimator(
      onPressed: () {
        Utils.showNonAnimatedDialog(
          barrierLabel: 'Achievements',
          context: Navigation.navigationKey.currentContext!,
          builder: (context) {
            return AchievementsDialog(achievementsService: achievementsService);
          },
        );
      },
      child: Stack(
        children: [
          StatSkeletonWidget(
            width: 250.s,
            imageAlignment: StatSkeletonImageAlignment.left,
            iconAsset: GameAssets.trophy1,
            child: Center(
              child: StylizedText(
                text: Text(
                  'Achievements',
                  style: TextStyles.s28,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: StreamBuilder<int>(
              stream: achievementsService.unclaimedAchievementsStream,
              builder: (context, snapshot) {
                final hasUnclaimedAchievements = snapshot.data != null && snapshot.data! > 0;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: hasUnclaimedAchievements
                      ? Container(
                          height: 20.s,
                          width: 20.s,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(BorderSide(color: Colors.black)),
                          ),
                          child: StylizedText(
                            text: Text(
                              achievementsService.achievementsModel.numberOfUnclaimedAchievements.toString(),
                              style: TextStyles.s14.copyWith(color: Colors.white),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
