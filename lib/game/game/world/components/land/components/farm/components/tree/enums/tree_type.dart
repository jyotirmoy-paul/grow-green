import 'package:growgreen/game/game/world/components/land/components/farm/components/system/growable.dart';

enum TreeType implements Growable {
  a,
  b,
  c,
  d,
  e,
  f,
  none;

  @override
  GrowableType getGrowableType() => GrowableType.tree;
}
