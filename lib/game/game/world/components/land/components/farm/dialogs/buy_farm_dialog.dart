import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../../../../services/log/log.dart';
import '../../../../../../../../services/utils/service_action.dart';
import '../../../../../../services/game_services/monetary/enums/transaction_type.dart';
import '../../../../../../services/game_services/monetary/models/money_model.dart';
import '../farm.dart';

class BuyFarmDialog extends StatelessWidget {
  static const tag = 'BuyFarmDialog';

  static Future<ServiceAction> openDialog({
    required BuildContext context,
    required Farm farm,
  }) async {
    final serviceAction = await showDialog<ServiceAction>(
      context: context,
      builder: (_) => BuyFarmDialog(farm: farm),
    );

    return serviceAction ?? ServiceAction.failure;
  }

  const BuyFarmDialog({
    super.key,
    required this.farm,
  });

  final Farm farm;

  void _takeAction({
    required BuildContext context,
    bool purchase = false,
  }) async {
    if (purchase) {
      showDialog(
        context: context,
        builder: (_) {
          return const SimpleDialog(
            title: Text('Purchasing... please wait!'),
          );
        },
      );

      ///TODO: get the farm price here!
      final isSuccess = await farm.game.gameController.monetaryService.transact(
        transactionType: TransactionType.debit,
        value: MoneyModel(rupees: 100000),
      );

      Log.d('$tag: Farm purchase result from monetary service: $isSuccess');

      if (isSuccess) {
        if (context.mounted) {
          /// close the processing dialog
          Navigator.pop(context);

          showDialog(
            context: context,
            builder: (_) {
              return const SimpleDialog(
                title: Text('Hurray!! Purchased the farm!'),
              );
            },
          );
        }
      } else {
        if (context.mounted) {
          /// close the processing dialog
          Navigator.pop(context);

          showDialog(
            context: context,
            builder: (_) {
              return const SimpleDialog(
                title: Text('Yikes! The purchase could not go through! Do you have sufficient balance?'),
              );
            },
          );
        }
      }

      await Future.delayed(const Duration(seconds: 1));

      if (context.mounted) {
        /// close the status dialog
        Navigator.pop(context);

        /// close the purchase dialog
        Navigator.pop(context, isSuccess ? ServiceAction.success : ServiceAction.failure);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Purchase the farm: ${farm.farmId}?'),

      /// TODO: get the farm price
      content: Text('You would need to pay a total amount of Rs 1,00,000'),
      actions: [
        TextButton(
          onPressed: () {
            _takeAction(context: context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _takeAction(context: context, purchase: true);
          },
          child: Text('Confirm Purchase!'),
        ),
      ],
    );
  }
}
