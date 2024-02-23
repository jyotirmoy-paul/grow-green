import 'package:json_annotation/json_annotation.dart';

import '../../../../../../converters/measurables_converter.dart';
import '../../../../../../enums/measurables.dart';
import '../components/system/model/qty.dart';

part 'content.g.dart';

@JsonSerializable()
class Content {
  @MeasurablesConverter()
  final Measurables type;
  final Qty qty;

  const Content({
    required this.type,
    required this.qty,
  });

  @override
  String toString() {
    return 'Content($type, $qty)';
  }

  factory Content.empty(Measurables type) {
    return Content(
      type: type,
      qty: const Qty(value: 0, scale: Scale.units),
    );
  }

  bool get isEmpty => qty.value == 0;
  bool get isNotEmpty => !isEmpty;

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
