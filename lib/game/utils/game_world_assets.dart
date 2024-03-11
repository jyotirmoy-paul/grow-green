/// Holds game world related assets
/// Assets that are required by flame to draw the game components
abstract class GameWorldAssets {
  /// map
  static const worldMapPrefix = 'assets/images/';
  static const worldMap = 'map.tmx';

  /// land assets
  static const _landAssetPrefix = 'tiles';
  static const barrenLand = '$_landAssetPrefix/barren_land.png';
  static const notBoughtLand = '$_landAssetPrefix/not_bought_land.png';
  static const soilHorizontalLand = '$_landAssetPrefix/soil_horizontal.png';
  static const soilVerticalLand = '$_landAssetPrefix/soil_vertical.png';
  static const normalLand = '$_landAssetPrefix/normal_land.png';
  static const baseBottom = '$_landAssetPrefix/base_bottom.png';
  static const baseLeft = '$_landAssetPrefix/base_left.png';
  static String nonFarmAssetOfName(String name) => '$_landAssetPrefix/$name.png';

  /// animations
  static const _animationAssetPrefix = 'animations';
  static String coinAssetFor({required int frameId}) => '$_animationAssetPrefix/coins/$frameId.png';
  static String riverAssetFor({
    required String riverId,
    required int frameId,
  }) =>
      '$_animationAssetPrefix/river/$riverId/$frameId.png';

  /// others
  static const cloudsSpriteSheet = 'clouds/clouds.png';
  static const coinProp = 'props/coin.png';
}
