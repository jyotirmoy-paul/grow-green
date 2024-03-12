import 'package:flutter/material.dart';

import '../../../../../l10n/l10n.dart';
import '../../../../../routes/routes.dart';
import '../model/notification_model.dart';
import 'notification_service.dart';

abstract class NotificationHelper {
  static BuildContext get _context => Navigation.navigationKey.currentContext!;

  /// non user issues
  static void farmPurchaseFailed() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.farmPurchaseFailed,
        textColor: Colors.red,
      ),
    );
  }

  static void farmContentsPurchaseFailed() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.contentPurchaseFailed,
        textColor: Colors.red,
      ),
    );
  }

  static void transactionFailed() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.transactionFailed,
        textColor: Colors.red,
      ),
    );
  }

  /// user issues
  static void cannotAffordFarm() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.insufficientFundsForFarm,
        textColor: Colors.red,
      ),
    );
  }

  static void cannotAffordFarmContents() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.insufficientFundsForFarmContent,
        textColor: Colors.red,
      ),
    );
  }

  static void nothingToBuy() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.nothingToBuy,
        textColor: Colors.red,
      ),
    );
  }

  static void treeMaintenanceMiss() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.treeDiedPrematurely,
        textColor: Colors.red,
      ),
    );
  }

  /// success
  static void farmPurchaseSuccess() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.farmPurchaseSuccess,
        textColor: Colors.green,
      ),
    );
  }

  static void treesSold() {
    NotificationService().notify(
      NotificationModel(
        text: _context.l10n.treeSold,
        textColor: Colors.green,
      ),
    );
  }
}
