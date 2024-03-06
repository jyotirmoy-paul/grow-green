import '../../../components/farm/components/tree/enums/tree_type.dart';

class TreeInfo {
  static String getTreeInfo(TreeType? treeType) {
    switch (treeType) {
      case TreeType.mahagony:
        return 'A large tropical tree known for its strong and beautiful reddish-brown wood, widely used in furniture making and cabinetry.';
      case TreeType.neem:
        return 'A versatile tree native to the Indian subcontinent, valued for its medicinal properties and environmental benefits.';
      case TreeType.rosewood:
        return 'A valuable hardwood known for its rich color and grain, used in the manufacture of musical instruments and fine furniture.';

      case TreeType.teakwood:
        return 'A tropical hardwood tree highly prized for its durability, water resistance, and used in shipbuilding, furniture, and outdoor constructions.';
      case TreeType.coconut:
        return 'A tropical palm known for its versatile fruit, used for water, milk, oil, and flesh, with significant cultural and economic importance.';
      case TreeType.jackfruit:
        return 'A large tropical fruit tree known for producing the largest fruit of all trees, offering a meaty texture and used in various culinary dishes.';
      case TreeType.mango:
        return 'A tropical fruit tree beloved for its sweet and juicy fruit, regarded as the "king of fruits" and widely cultivated in many tropical regions.';
      default:
        return '';
    }
  }
}
