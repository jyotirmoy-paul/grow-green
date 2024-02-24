import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart' hide Text;

import '../../../../../services/log/log.dart';
import '../../../../../services/utils/service_action.dart';
import '../../../../utils/game_extensions.dart';
import '../../../../utils/game_utils.dart';
import '../../../grow_green_game.dart';
import 'components/farm/dialogs/buy_farm_dialog.dart';
import 'components/farm/enum/farm_state.dart';
import 'components/farm/farm.dart';
import 'overlays/system_selector_menu/system_selector_menu.dart';

class LandController {
  static const tag = 'LandController';

  late final GrowGreenGame game;
  late final TiledComponent map;
  late final List<Farm> farms;

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
          farmId: farmObj.name,
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

  void _handleFarmBuying(Farm farm) async {
    Log.d('$tag: _handleFarmBuying: $farm menu is shown');

    final context = game.buildContext;
    if (context == null) {
      throw Exception('$tag: _handleFarmBuying received empty game context!');
    }

    final serviceAction = await BuyFarmDialog.openDialog(
      context: context,
      farm: farm,
    );

    Log.d('$tag: _handleFarmBuying: $farm purchase result: $serviceAction');

    if (serviceAction == ServiceAction.success) {
      farm.farmController.purchaseSuccess();
    }
  }

  void _processFarmTap(Farm farm) async {
    Log.d('$tag: _processFarmTap: $farm is tapped');

    /// if a listener has registered for taps, let them handle it
    if (farm.farmController.onFarmTap != null) {
      return farm.farmController.onFarmTap!();
    }

    if (farm.farmController.farmState == FarmState.notBought) {
      return _handleFarmBuying(farm);
    }

    /// mark farm as selected
    farm.farmController.isFarmSelected = true;

    /// open farm composition menu
    game.gameController.overlayData.farm = farm;
    game.overlays.add(SystemSelectorMenu.overlayName);
  }

  void _processOutsideTap() {
    /// TODO: is there anything to do?
  }

  void _onFarmTap(Farm? selectedFarm) {
    if (selectedFarm != null) {
      _processFarmTap(selectedFarm);
    } else {
      _processOutsideTap();
    }
  }

  void _findFarmTap(Vector2 gamePosition) {
    Farm? selectedFarm;

    for (final farm in farms) {
      final containsPoint = farm.farmRect.containsPoint(gamePosition);

      if (containsPoint) {
        selectedFarm = farm;
      } else {
        farm.farmController.isFarmSelected = false;
      }
    }

    _onFarmTap(selectedFarm);
  }

  void onTapUp(TapUpEvent event) {
    final gamePosition = game.gameController.camera.viewfinder.parentToLocal(event.devicePosition).toIso();
    Log.i('$tag: onTapUp: tapped game world coordinate: $gamePosition');

    _findFarmTap(gamePosition);
  }
}
