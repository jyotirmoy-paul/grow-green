enum CropStage {
  germination,
  sprouting,
  flourishing,
  ripe;

  String get assetName => '${index + 1}.png';
}
