import 'package:flutter/material.dart';

import '../model/notification_model.dart';
import 'notification_service.dart';

/// TODO: Language
abstract class NotificationHelper {
  /// non user issues
  static void farmPurchaseFailed() {}
  static void farmContentsPurchaseFailed() {}

  /// user issues
  static void cannotAffordFarm() {
    NotificationService().notify(
      NotificationModel(
        text: 'Insufficient funds to buy the farm.',
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

  /// others
  static void treesSold() {
    NotificationService().notify(
      NotificationModel(
        text: 'Yay! Sold the trees successfully.',
        textColor: Colors.green,
      ),
    );
  }
}
