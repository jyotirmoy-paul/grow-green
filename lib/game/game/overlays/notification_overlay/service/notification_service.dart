import 'dart:async';

import '../model/notification_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();

  factory NotificationService() {
    return _instance;
  }

  final StreamController<NotificationModel> _streamController = StreamController.broadcast();
  Stream<NotificationModel> get notificationStream => _streamController.stream;

  /// call this method to add to the notification queue
  void notify(NotificationModel notification) {
    _streamController.add(notification);
  }
}
