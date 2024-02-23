import 'dart:async';

import '../../../../../services/log/log.dart';
import '../../../../../services/utils/service_action.dart';
import '../../datastore/game_datastore.dart';
import 'enums/transaction_type.dart';
import 'models/money_model.dart';

class MonetaryService {
  static const tag = 'MonetaryService';

  final GameDatastore gameDatastore;

  MoneyModel _balanceValue = MoneyModel(rupees: 0);
  MoneyModel get _balance => _balanceValue;
  set _balance(MoneyModel value) {
    _balanceValue = value;
    _balanceStreamController.add(value);
  }

  final StreamController<MoneyModel> _balanceStreamController = StreamController.broadcast();

  MonetaryService({
    required this.gameDatastore,
  });

  Future<void> initialize() async {
    _balance = await gameDatastore.getMoney();
  }

  /// Deducts `value` amount from user's balance
  /// If not enough balance is available, this method immediately returns false
  /// Otherwise any changes to balance is reported back to the server immediately
  /// And if a successful transation happens and the balance gets updated from the server the method returns true,
  /// Or it fails with false
  Future<bool> _transactDebit(MoneyModel value) async {
    final balance = _balance - value;
    if (balance.isNegative()) {
      Log.d('$tag: _transactDebit invoked with value: $value, User cannot afford item!');
      return false;
    }

    final serverStatus = await gameDatastore.saveMoney(balance);
    if (serverStatus == ServiceAction.failure) {
      Log.e('_transactDebit($value) failed to commit to server!');
      return false;
    }

    Log.d('$tag: A debit transaction of value $value was successful. Balance amount: $_balance');

    _balance = balance;

    return true;
  }

  /// Adds `value` amount to user's balance
  /// Any changes to the balance is reported back to the server immediately
  /// And if a successful transation happens and the balance gets updated from the server the method returns true,
  /// Or it fails with false
  Future<bool> _transactCredit(MoneyModel value) async {
    final balance = _balance + value;

    final serverStatus = await gameDatastore.saveMoney(balance);
    if (serverStatus == ServiceAction.failure) {
      Log.e('_transactCredit($value) failed to commit to server!');
      return false;
    }

    Log.d('$tag: A credit transaction of value $value was successful. Balance amount: $_balance');

    _balance = balance;

    return true;
  }

  Future<bool> transact({
    required TransactionType transactionType,
    required MoneyModel value,
  }) async {
    switch (transactionType) {
      case TransactionType.debit:
        return _transactDebit(value);

      case TransactionType.credit:
        return _transactCredit(value);
    }
  }

  MoneyModel get balance => _balance;
  Stream<MoneyModel> get balanceStream => _balanceStreamController.stream;
}
