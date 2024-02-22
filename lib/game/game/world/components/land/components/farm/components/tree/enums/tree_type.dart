import '../../../../../../../../enums/measurables.dart';
import '../../system/enum/growable.dart';

enum TreeType implements Growable, Measurables {
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
