// this is store per hacter

import 'package:json_annotation/json_annotation.dart';

part 'qty.g.dart';

enum Scale { kg, units }

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Qty {
  final int value;
  final Scale scale;

  const Qty({required this.value, required this.scale});

  @override
  String toString() {
    return 'Qty($value, $scale)';
  }

  factory Qty.fromJson(Map<String, dynamic> json) => _$QtyFromJson(json);
  Map<String, dynamic> toJson() => _$QtyToJson(this);
}
