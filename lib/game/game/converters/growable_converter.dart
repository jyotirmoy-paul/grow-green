import 'package:json_annotation/json_annotation.dart';

import '../../../utils/extensions/string_extensions.dart';
import '../world/components/land/components/farm/components/crop/enums/crop_type.dart';
import '../world/components/land/components/farm/components/system/enum/growable.dart';
import '../world/components/land/components/farm/components/tree/enums/tree_type.dart';

class GrowableConverter implements JsonConverter<Growable, String> {
  static const tag = 'GrowableConverter';

  const GrowableConverter();

  @override
  Growable fromJson(String name) {
    final crop = name.toEnum<CropType?>(CropType.values, null);
    final tree = name.toEnum<TreeType?>(TreeType.values, null);

    return (crop ?? tree ?? (throw Exception('$tag: fromJson($name) failed to find enum from crop, tree'))) as Growable;
  }

  @override
  String toJson(Growable object) {
    return object.name;
  }
}
