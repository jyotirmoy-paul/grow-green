import '../../../../../../enums/agroforestry_type.dart';
import '../components/tree/enums/tree_type.dart';

class TreeData {
  final AgroforestryType agroforestryType;
  final DateTime lifeStartedAt;
  final TreeType treeType;

  TreeData({
    required this.agroforestryType,
    required this.treeType,
    required this.lifeStartedAt,
  });
}
