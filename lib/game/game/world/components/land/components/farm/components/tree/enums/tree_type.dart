import '../../system/enum/growable.dart';

enum TreeType implements Growable {
  mahagony,
  neem,
  rosewood,
  teakwood,
  cocounut,
  jackfruit,
  mango;

  @override
  GrowableType getGrowableType() => GrowableType.tree;
}
