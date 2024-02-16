import '../../system/growable.dart';

enum TreeType implements Growable {
  mahagony,
  neem,
  rosewood,
  teakwood,
  cocounut,
  jackfruit,
  mango,
  none;

  @override
  GrowableType getGrowableType() => GrowableType.tree;
}
