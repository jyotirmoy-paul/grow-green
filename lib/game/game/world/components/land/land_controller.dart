import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../../../../utils/game_extensions.dart';
import '../../../../../services/log/log.dart';

import '../../../../utils/game_utils.dart';
import '../../../grow_green_game.dart';
import 'components/farm/farm.dart';

class LandController {
  static const tag = 'LandController';

  late final GrowGreenGame game;
  late final TiledComponent map;
  late final List<Farm> farms;

  Farm? _selectedFarm;

  static const _farmsLayerName = 'Farms';

  void _populateFarms() {
    final farmsObjectGroup = map.tileMap.getLayer<ObjectGroup>(_farmsLayerName);

    if (farmsObjectGroup == null) {
      throw Exception('"$_farmsLayerName" layer not found! Have you added it in the map?');
    } else {
      final List<Farm> farms = [];

      for (final farmObj in farmsObjectGroup.objects) {
        final rectangle = Rectangle.fromLTWH(
          farmObj.x,
          farmObj.y,
          farmObj.width,
          farmObj.height,
        );

        final farm = Farm(
          [
            rectangle.topLeft.toCart(),
            rectangle.topRight.toCart(),
            rectangle.bottomRight.toCart(),
            rectangle.bottomLeft.toCart(),
          ],
          farmRect: rectangle,
          farmName: farmObj.name,
        )..anchor = Anchor.topLeft;

        farms.add(farm);
      }

      this.farms = farms;
    }
  }

  Future<List<Component>> initialize(GrowGreenGame game) async {
    this.game = game;

    /// load map
    map = await TiledComponent.load(
      GameUtils.worldMapFileName,
      GameUtils.tileSize,
      prefix: GameUtils.mapDirectoryPrefix,
    )
      ..anchor = Anchor.topLeft;

    /// initialize game world size
    GameUtils.initializeWithWorldSize(map.size);

    /// callback to notify map loaded
    game.gameController.onWorldLoad(map.absoluteCenter);

    /// populate farms
    _populateFarms();

    return [
      map,
      ...farms,
    ];
  }

  void _calculateFarmTap(Vector2 gamePosition) {
    bool isOneFarmSelected = false;

    for (final farm in farms) {
      final containsPoint = farm.farmRect.containsPoint(gamePosition);
      farm.farmController.isFarmSelected = containsPoint;

      if (containsPoint) {
        Log.d('$tag: _calculateFarmTap: $farm is tapped');
        _selectedFarm = farm;
        isOneFarmSelected = true;
        break;
      }
    }

    if (!isOneFarmSelected) {
      _selectedFarm = null;
    }
  }

  void onTapUp(TapUpEvent event) {
    final gamePosition = game.gameController.camera.viewfinder.parentToLocal(event.devicePosition).toIso();
    Log.i('$tag: onTapUp: tapped game world coordinate: $gamePosition');

    _calculateFarmTap(gamePosition);
  }
}
