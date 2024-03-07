import 'package:flutter/material.dart';

import '../model/notification_model.dart';
import 'notification_service.dart';

/// TODO: Language
abstract class NotificationHelper {
  /// non user issues
  static void farmPurchaseFailed() {}
  static void farmContentsPurchaseFailed() {}
  static void transactionFailed() {
    NotificationService().notify(
      NotificationModel(
        text: 'Transaction failed, something went wrong',
        textColor: Colors.red,
      ),
    );
  }

  /// user issues
  static void cannotAffordFarm() {
    NotificationService().notify(
      NotificationModel(
        text: 'Insufficient funds to buy the farm',
        textColor: Colors.red,
      ),
    );
  }

  static void cannotAffordFarmContents() {
    NotificationService().notify(
      NotificationModel(
        text: 'Insufficient funds to buy the contents for your farm',
        textColor: Colors.red,
      ),
    );
  }

  static void agroforestrySystemTapNotAllowed() {
    NotificationService().notify(
      NotificationModel(
        text: 'Can\'t edit with trees present in the system!',
        textColor: Colors.red,
      ),
    );
  }

  static void nothingToBuy() {
    NotificationService().notify(
      NotificationModel(
        text: 'Nothing to buy!',
        textColor: Colors.red,
      ),
    );
  }

  /// success
  static void farmPurchaseSuccess() {
    NotificationService().notify(
      NotificationModel(
        text: 'Woohoo! Bought the farm',
        textColor: Colors.green,
      ),
    );
  }

  static void treesSold() {
    NotificationService().notify(
      NotificationModel(
        text: 'Yay! Sold the trees successfully',
        textColor: Colors.green,
      ),
    );
  }
}
