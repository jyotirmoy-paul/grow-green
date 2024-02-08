import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart' hide Text;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'overlays/farm_composition_menu/cubit/farm_composition_menu_cubit.dart';
import '../../../../../screens/game_screen/cubit/game_overlay_cubit.dart';

import '../../../../../services/log/log.dart';
import '../../../../utils/game_extensions.dart';
import '../../../../utils/game_utils.dart';
import '../../../grow_green_game.dart';
import 'components/farm/farm.dart';
import 'overlays/farm_composition_menu/farm_composition_menu.dart';

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

  void _processFarmTap(Farm farm) async {
    Log.d('$tag: _processFarmTap: $farm is tapped');

    if (farm.farmController.isFarmSelected) {
      /// the farm is already selected, we don't have to procees anything!
      return;
    }

    /// mark farm as selected
    farm.farmController.isFarmSelected = true;

    if (game.overlays.isActive(FarmCompositionMenu.overlayName)) {
      game.overlays.remove(FarmCompositionMenu.overlayName);
      await Future.delayed(const Duration(milliseconds: 80));
    }

    /// open farm composition menu
    game.buildContext?.read<GameOverlayCubit>().onFarmCompositionShow(farm);
    game.buildContext?.read<FarmCompositionMenuCubit>().populate(farm.farmController.farmContent);
    game.overlays.add(FarmCompositionMenu.overlayName);
  }

  void _processOutsideTap() {
    game.overlays.removeAll([
      FarmCompositionMenu.overlayName,
    ]);
  }

  void _onFarmTap(Farm? selectedFarm) {
    ///  If farm is getting edited (inventory is open) skip closing!
    final farmCompositionState = game.buildContext?.read<FarmCompositionMenuCubit>().state;
    if (farmCompositionState is FarmCompositionMenuEditing) {
      return;
    }

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
