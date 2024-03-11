import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

import '../../../../../../../../services/log/log.dart';
import '../../../../../../../utils/game_utils.dart';

class CloudDistributionService {
  static const tag = 'CloudDistributionService';

  final Vector2 worldSize;
  final Vector2 cloudSize;
  final Vector2 adjustedWorldSize;
  final Vector2 worldPosition;

  CloudDistributionService({
    required this.worldSize,
    required this.cloudSize,
    required this.worldPosition,
  }) : adjustedWorldSize = worldSize - cloudSize;

  Vector2 generateCloudSpawnPoint() {
    final y = GameUtils().getPureRandomNumberBetween(min: worldPosition.y, max: adjustedWorldSize.y);
    return Vector2(worldPosition.x, y);
  }

  List<Vector2> generateCloudPoints({required int numberOfPoints}) {
    List<Vector2> points = [];

    int attempts = 0;
    while (points.length < numberOfPoints) {
      final x = GameUtils().getPureRandomNumberBetween(min: worldPosition.x, max: adjustedWorldSize.x);
      final y = GameUtils().getPureRandomNumberBetween(min: worldPosition.y, max: adjustedWorldSize.y);

      final newPoint = Vector2(x, y);

      // Check for overlap with existing points
      final hasOverlap = points.any((existingCloud) {
        final existingCloudRect = Rectangle.fromCenter(center: existingCloud, size: cloudSize).toRect();
        final newCloudRect = Rectangle.fromCenter(center: newPoint, size: cloudSize).toRect();

        return existingCloudRect.overlaps(newCloudRect);
      });

      if (!hasOverlap) {
        points.add(newPoint);
      } else {
        attempts++;
      }

      if (attempts >= numberOfPoints * 100) {
        Log.d(
          '$tag: Failed to place all clouds without overlap after $attempts attempts. Placed ${points.length} clouds.',
        );

        break; // tried enough, let's break out!
      }
    }

    return points;
  }
}
