import '../../system/enum/growable.dart';

enum CropType implements Growable {
  maize,
  bajra,
  wheat,
  groundnut,
  pepper,
  banana;

  @override
  GrowableType getGrowableType() => GrowableType.crop;
}
