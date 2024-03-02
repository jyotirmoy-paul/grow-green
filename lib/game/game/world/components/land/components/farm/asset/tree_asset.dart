import '../components/tree/enums/tree_stage.dart';
import '../components/tree/enums/tree_type.dart';

class TreeAsset {
  final TreeType treeType;
  final String prefix;

  TreeAsset._(this.treeType, this.prefix);

  factory TreeAsset.of(TreeType treeType) {
    return TreeAsset._(treeType, 'trees');
  }

  factory TreeAsset.raw(TreeType treeType) {
    return TreeAsset._(treeType, 'assets/images/trees');
  }

  String at(TreeStage treeStage) {
    return '$prefix/${treeType.name}/${treeStage.assetName}';
  }

  static String representativeOf(TreeType treeType) {
    return TreeAsset.raw(treeType).at(TreeStage.elder);
  }
}
