import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'money_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class MoneyModel {
  static final _formatter = NumberFormat.decimalPattern('en_IN');

  final int rupees;

  factory MoneyModel.zero() {
    return MoneyModel(rupees: 0);
  }

  MoneyModel({
    required int rupees,
  }) : rupees = rupees < 0 ? throw ArgumentError('rupees cannot be negative!') : rupees;

  String get formattedRupees => _formatter.format(rupees);

  bool isNegative() {
    return rupees < 0;
  }

  bool isZero() {
    return rupees == 0;
  }

  @override
  String toString() {
    return 'Money($formattedRupees)';
  }

  MoneyModel operator -(MoneyModel other) {
    return MoneyModel(
      rupees: rupees - other.rupees,
    );
  }

  MoneyModel operator +(MoneyModel other) {
    return MoneyModel(
      rupees: rupees + other.rupees,
    );
  }

  factory MoneyModel.fromJson(Map<String, dynamic> json) => _$MoneyModelFromJson(json);
  Map<String, dynamic> toJson() => _$MoneyModelToJson(this);
}
