import '../../../../../../../../enums/measurables.dart';
import '../../system/enum/growable.dart';

enum TreeType implements Growable, Measurables {
  mahagony,
  neem,
  rosewood,
  teakwood,
  coconut,
  jackfruit,
  mango;

  @override
  GrowableType getGrowableType() => GrowableType.tree;
}
