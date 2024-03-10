import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart' hide Text;

import '../../../../../services/log/log.dart';
import '../../../../utils/game_assets.dart';
import '../../../../utils/game_extensions.dart';
import '../../../../utils/game_utils.dart';
import '../../../grow_green_game.dart';
import '../../../services/game_services/time/time_service.dart';
import '../../../services/priority/priority_engine.dart';
import 'components/farm/farm.dart';
import 'overlays/farm_menu/farm_menu.dart';
import 'overlays/system_selector_menu/model/farm_notifier.dart';

class LandController {
  static const riverAnimationSpeed = 0.1;
  static const tag = 'LandController';

  late final GrowGreenGame game;
  late final TiledComponent map;
  late final List<Farm> farms;

  static const _farmsLayerName = 'farms';
  static const _riverLayerName = 'river';
  static const _nonFarmsLayerName = 'non-farms';

  void _populateFarms() {
    final farmsObjectGroup = map.tileMap.getLayer<ObjectGroup>(_farmsLayerName);
    if (farmsObjectGroup == null) {
      throw Exception('$tag: $_farmsLayerName layer not found! Have you added it in the map?');
    }

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
      )
        ..priority = PriorityEngine.generatePriorityFrom(rectangle.center)
        ..anchor = Anchor.topLeft;

      farms.add(farm);
    }

    this.farms = farms;
  }

  String _getAssetFor({
    required String riverId,
    required int frameId,
  }) {
    return 'river/$riverId/$frameId.png';
  }

  Future<List<SpriteAnimationComponent>> getRivers() async {
    final riverObjectGroup = map.tileMap.getLayer<ObjectGroup>(_riverLayerName);
    if (riverObjectGroup == null) {
      throw Exception('$tag: $_riverLayerName layer not found! Have you added it in the map?');
    }

    final rivers = <SpriteAnimationComponent>[];

    for (final riverObj in riverObjectGroup.objects) {
      final rectangle = Rectangle.fromLTWH(
        riverObj.x,
        riverObj.y,
        riverObj.width,
        riverObj.height,
      );

      final List<Sprite> sprites = [];

      for (int i = 1; i <= 6; i++) {
        sprites.add(await Sprite.load(_getAssetFor(riverId: riverObj.name, frameId: i)));
      }

      final spriteAnimation = SpriteAnimation.spriteList(
        sprites,
        stepTime: riverAnimationSpeed,
        loop: true,
      );

      rivers.add(
        SpriteAnimationComponent(
          animation: spriteAnimation,
          position: rectangle.bottomRight.toCart(),
          anchor: Anchor.bottomCenter,
          priority: PriorityEngine.generatePriorityFrom(rectangle.center),
        ),
      );
    }

    return rivers;
  }

  Future<List<Component>> getNonFarms() async {
    final nonFarmsObjectGroup = map.tileMap.getLayer<ObjectGroup>(_nonFarmsLayerName);
    if (nonFarmsObjectGroup == null) {
      throw Exception('$tag: $nonFarmsObjectGroup layer not found! Have you added it in the map?');
    }

    final nonFarms = <Component>[];

    for (final nonFarmObj in nonFarmsObjectGroup.objects) {
      final rectangle = Rectangle.fromLTWH(
        nonFarmObj.x,
        nonFarmObj.y,
        nonFarmObj.width,
        nonFarmObj.height,
      );

      nonFarms.add(SpriteComponent.fromImage(
        await game.images.load(GameAssets.nonFarmAssetOfName(nonFarmObj.name)),
        position: rectangle.bottomRight.toCart(),
        anchor: Anchor.bottomCenter,
        priority: PriorityEngine.generatePriorityFrom(rectangle.center),
      ));
    }

    return nonFarms;
  }

  void onTimePaceChange({
    required int timePace,
    required List<SpriteAnimationComponent> riverAnimation,
  }) {
    for (final animation in riverAnimation) {
      /// decide weather to play the animation or not
      animation.playing = timePace != 0;

      /// if the animation is playing, decide the step time
      if (animation.playing) {
        if (timePace == 1) {
          animation.animation?.stepTime = riverAnimationSpeed;
        } else {
          animation.animation?.stepTime = riverAnimationSpeed * 0.3;
        }
      }
    }
  }

  Future<List<Component>> initialize(GrowGreenGame game) async {
    this.game = game;

    /// load map
    map = await TiledComponent.load(
      GameAssets.worldMap,
      GameUtils.tileSize,
      prefix: GameAssets.worldMapPrefix,
    )
      ..anchor = Anchor.topLeft;

    /// initialize game world size
    GameUtils.initializeWithWorldSize(map.size);

    /// callback to notify map loaded
    game.gameController.onWorldLoad(map.absoluteCenter);

    /// populate farms
    _populateFarms();

    final river = await getRivers();
    final nonFarms = await getNonFarms();

    /// listen for time pace changes
    TimeService().timePaceStream.listen(
      (timePace) {
        onTimePaceChange(timePace: timePace, riverAnimation: river);
      },
    );

    return [
      map,
      ...river,
      ...nonFarms,
      ...farms,
    ];
  }

  FarmNotifier get _farmNotifier => game.gameController.overlayData.farmNotifier;

  void _processFarmTap(Farm farm) async {
    Log.d('$tag: _processFarmTap: $farm is tapped');

    /// if a listener has registered for taps, let them handle it
    if (farm.farmController.onFarmTap != null) {
      _farmNotifier.farm = null;
      return farm.farmController.onFarmTap!();
    }

    /// if the farm is already selected deselect it & close farm menu
    if (farm.farmController.isFarmSelected) {
      farm.farmController.isFarmSelected = false;
      _farmNotifier.farm = null;
      return;
    }
    farm.farmController.isFarmSelected = true;

    /// open farm menu
    _farmNotifier.farm = farm;

    if (!game.overlays.isActive(FarmMenu.overlayName)) {
      game.overlays.add(FarmMenu.overlayName);
    }
  }

  void _processOutsideTap() {
    _farmNotifier.farm = null;
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
