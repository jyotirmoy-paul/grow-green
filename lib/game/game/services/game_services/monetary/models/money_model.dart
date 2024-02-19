import 'package:intl/intl.dart';

class MoneyModel {
  static final _formatter = NumberFormat.decimalPattern('en_IN');

  final int rupees;

  MoneyModel({
    required int rupees,
  }) : rupees = rupees < 0 ? throw ArgumentError('rupees cannot be negative!') : rupees;

  String get formattedRupees => _formatter.format(rupees);

  bool isNegative() {
    return rupees < 0;
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
}
