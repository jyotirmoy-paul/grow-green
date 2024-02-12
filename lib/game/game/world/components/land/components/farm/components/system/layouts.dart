// This is assuming one hactar area
class PlantationLayout {
  final int numberOfTrees;
  final double leftoverAreaForCrops;

  const PlantationLayout._({
    required this.numberOfTrees,
    required this.leftoverAreaForCrops,
  });

  static const boundary = PlantationLayout._(
    numberOfTrees: 158,
    leftoverAreaForCrops: 8760.6,
  );

  static const alleyCropping = PlantationLayout._(
    numberOfTrees: 348,
    leftoverAreaForCrops: 7270.18,
  );

  static const blockPlantation = PlantationLayout._(
    numberOfTrees: 594,
    leftoverAreaForCrops: 4473,
  );
  static const monoPlantation = PlantationLayout._(
    numberOfTrees: 0,
    leftoverAreaForCrops: 10000,
  );
}
