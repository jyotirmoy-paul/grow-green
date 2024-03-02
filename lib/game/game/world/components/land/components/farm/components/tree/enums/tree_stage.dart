enum TreeStage {
  sprout,
  sapling,
  maturing,
  flourishing,
  elder;

  String get assetName => '${index + 1}.png';
}
