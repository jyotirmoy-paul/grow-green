import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'money_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class MoneyModel {
  static final _formatter = NumberFormat.decimalPattern('en_IN');

  final int value;

  /// internal constructor
  MoneyModel._(this.value);

  factory MoneyModel.zero() {
    return MoneyModel(value: 0);
  }

  MoneyModel({
    required int value,
  }) : value = value < 0 ? throw ArgumentError('value cannot be negative!') : value;

  String get formattedValue => _formatter.format(value).replaceAll(',', ' ');

  bool isNegative() {
    return value < 0;
  }

  bool isZero() {
    return value == 0;
  }

  @override
  String toString() {
    return 'Money($formattedValue)';
  }

  MoneyModel operator -(MoneyModel other) {
    return MoneyModel._(value - other.value);
  }

  MoneyModel operator +(MoneyModel other) {
    return MoneyModel(
      value: value + other.value,
    );
  }

  factory MoneyModel.fromJson(Map<String, dynamic> json) => _$MoneyModelFromJson(json);
  Map<String, dynamic> toJson() => _$MoneyModelToJson(this);
}
