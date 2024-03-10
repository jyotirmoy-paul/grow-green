import '../../../land/components/farm/components/tree/enums/tree_type.dart';

/// Source: https://onetreeplanted.org/blogs/stories/how-much-co2-does-tree-absorb
/// The mentioned source helped us to understand how Co2 sequestration works over time for various trees

class Co2AbsorptionData {
  static const youngThresholdAge = 10;
  static const matureThresholdAge = 20;

  final int youngSequestrationRate;
  final int matureSequestrationRate;
  final int oldSequestrationRate;

  /// calculated values
  final int totalYoungSequestration;
  final int totalMatureSequestration;

  Co2AbsorptionData({
    required this.youngSequestrationRate,
    required this.matureSequestrationRate,
    required this.oldSequestrationRate,
  })  : totalYoungSequestration = youngSequestrationRate * youngThresholdAge,
        totalMatureSequestration =
            youngSequestrationRate * youngThresholdAge + matureSequestrationRate * matureThresholdAge;

  /// Sequestration rate lowers with tree growth

  /// Young Trees
  /// In their early years, trees grow rapidly and have a high rate of CO2 absorption
  /// because they are increasing in biomass quickly. This phase is when trees can sequester carbon dioxide
  /// at a relatively fast rate compared to their size.

  /// Mature Trees
  /// As trees mature, their growth rate slows down. While mature trees absorb more CO2
  /// in absolute terms compared to young trees because of their larger biomass
  /// (more leaves, more surface area for photosynthesis), the rate of CO2 absorption
  /// relative to their size tends to plateau or decrease. Mature trees still play a critical role
  /// in carbon sequestration, holding large amounts of carbon in their wood, roots, and soil.

  /// Old Age and Decline
  /// In the later stages of a tree's life, its growth significantly slows
  /// and so does its ability to sequester CO2. When trees die and decompose, or are burned,
  /// much of the stored carbon is released back into the atmosphere, though some remains
  /// sequestered in the soil or, in the case of harvested wood, in timber products
  factory Co2AbsorptionData.of(TreeType treeType) {
    return switch (treeType) {
      TreeType.mahagony => Co2AbsorptionData(
          youngSequestrationRate: 22,
          matureSequestrationRate: 15,
          oldSequestrationRate: 10,
        ),
      TreeType.neem => Co2AbsorptionData(
          youngSequestrationRate: 18,
          matureSequestrationRate: 12,
          oldSequestrationRate: 8,
        ),
      TreeType.rosewood => Co2AbsorptionData(
          youngSequestrationRate: 25,
          matureSequestrationRate: 17,
          oldSequestrationRate: 11,
        ),
      TreeType.teakwood => Co2AbsorptionData(
          youngSequestrationRate: 18,
          matureSequestrationRate: 12,
          oldSequestrationRate: 8,
        ),
      TreeType.coconut => Co2AbsorptionData(
          youngSequestrationRate: 10, // coconut's absorption rate is lower due to being a palm
          matureSequestrationRate: 7,
          oldSequestrationRate: 5,
        ),
      TreeType.jackfruit => Co2AbsorptionData(
          youngSequestrationRate: 18,
          matureSequestrationRate: 12,
          oldSequestrationRate: 8,
        ),
      TreeType.mango => Co2AbsorptionData(
          youngSequestrationRate: 18,
          matureSequestrationRate: 12,
          oldSequestrationRate: 8,
        ),
    };
  }
}
