import 'package:growgreen/game/game/world/components/land/components/farm/components/system/growable.dart';

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
