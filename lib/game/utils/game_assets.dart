abstract class GameAssets {
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
}
