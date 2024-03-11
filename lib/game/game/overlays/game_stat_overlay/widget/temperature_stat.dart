import 'package:flutter/material.dart';

import '../../../../../utils/extensions/num_extensions.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/stylized_text.dart';
import '../../../../utils/game_assets.dart';
import '../../../world/components/sky/weather_service/services/village_temperature_service.dart';
import 'stat_skeleton_widget.dart';

class TemperatureStat extends StatelessWidget {
  final VillageTemperatureService villageTemperatureService;

  const TemperatureStat({
    super.key,
    required this.villageTemperatureService,
  });

  @override
  Widget build(BuildContext context) {
    return StatSkeletonWidget(
      imageAlignment: StatSkeletonImageAlignment.left,
      width: 180.s,
      iconAsset: GameAssets.temperature,
      child: StreamBuilder(
        stream: villageTemperatureService.temperatureStream,
        builder: (_, snapshot) {
          final temperature = snapshot.data;
          if (temperature == null) return const SizedBox.shrink();

          return StylizedText(
            text: Text(
              '${temperature.toStringAsFixed(2)}° C',
              style: TextStyles.s28,
            ),
          );
        },
      ),
    );
  }
}
