// this is store per hacter

import 'package:json_annotation/json_annotation.dart';

part 'qty.g.dart';

enum Scale {
  kg,
  units;

  String get suffix {
    switch (this) {
      case Scale.kg:
        return 'kg';
      case Scale.units:
        return '';
    }
  }

  String get prefix {
    switch (this) {
      case Scale.kg:
        return '';
      case Scale.units:
        return 'x';
    }
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Qty {
  final int value;
  final Scale scale;

  const Qty({required this.value, required this.scale});

  String get readableFormat {
    return '${scale.prefix} $value ${scale.suffix}';
  }

  @override
  String toString() {
    return 'Qty($value, $scale)';
  }

  factory Qty.fromJson(Map<String, dynamic> json) => _$QtyFromJson(json);
  Map<String, dynamic> toJson() => _$QtyToJson(this);

  Qty copyWith({
    int? value,
    Scale? scale,
  }) {
    return Qty(
      value: value ?? this.value,
      scale: scale ?? this.scale,
    );
  }

  Qty operator *(double factor) {
    return Qty(
      value: (value * factor).round(),
      scale: scale,
    );
  }

  Qty round() {
    return Qty(
      value: value.round(),
      scale: scale,
    );
  }
}
