import '../../../../tree/enums/tree_type.dart';

/// age data stored in days
class TreeGrowthData {
  final int sproutAge;
  final int saplingAge;
  final int maturingAge;
  final int flourishingAge;

  const TreeGrowthData({
    required this.sproutAge,
    required this.saplingAge,
    required this.maturingAge,
    required this.flourishingAge,
  });

  factory TreeGrowthData.of({required TreeType treeType}) {
    return switch (treeType) {
      TreeType.mahagony => const TreeGrowthData(
          sproutAge: 60,
          saplingAge: 365, // 1 year
          maturingAge: 1825, // 5 years
          flourishingAge: 5475, // 15 years
        ),
      TreeType.neem => const TreeGrowthData(
          sproutAge: 30,
          saplingAge: 180, // 6 months
          maturingAge: 730, // 2 years
          flourishingAge: 2190, // 6 years
        ),
      TreeType.rosewood => const TreeGrowthData(
          sproutAge: 60,
          saplingAge: 365, // 1 year
          maturingAge: 1825, // 5 years
          flourishingAge: 7300, // 20 years
        ),
      TreeType.teakwood => const TreeGrowthData(
          sproutAge: 60,
          saplingAge: 365, // 1 year
          maturingAge: 1825, // 5 years
          flourishingAge: 7300, // 20 years
        ),
      TreeType.coconut => const TreeGrowthData(
          sproutAge: 60,
          saplingAge: 180, // 6 months
          maturingAge: 730, // 2 years
          flourishingAge: 3650, // 10 years
        ),
      TreeType.jackfruit => const TreeGrowthData(
          sproutAge: 60,
          saplingAge: 180, // 6 months
          maturingAge: 730, // 2 years
          flourishingAge: 3650, // 10 years
        ),
      TreeType.mango => const TreeGrowthData(
          sproutAge: 60,
          saplingAge: 365, // 1 year
          maturingAge: 1095, // 3 years
          flourishingAge: 3650, // 10 years
        ),
    };
  }
}
