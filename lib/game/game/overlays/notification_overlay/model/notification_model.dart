import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NotificationModel {
  final GlobalKey key;
  final String id;
  final String text;
  final Color textColor;

  NotificationModel({
    required this.text,
    required this.textColor,
  })  : key = GlobalKey(),
        id = const Uuid().v1();

  @override
  String toString() {
    return 'Notification(text: $text)';
  }
}
