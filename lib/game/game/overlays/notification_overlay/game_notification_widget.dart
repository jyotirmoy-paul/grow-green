import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../services/log/log.dart';
import '../../../../utils/extensions/num_extensions.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/stylized_text.dart';
import 'model/notification_model.dart';
import 'service/notification_service.dart';
import 'widget/fading_widget.dart';

class GameNotificationWidget extends StatefulWidget {
  const GameNotificationWidget({
    super.key,
  });

  @override
  State<GameNotificationWidget> createState() => _GameNotificationWidgetState();
}

class _GameNotificationWidgetState extends State<GameNotificationWidget> {
  static const tag = '_NotificationOverlayState';
  static const maxNotificationsVisible = 5;
  static const routineNotificationCheckDuration = Duration(seconds: 10);

  StreamSubscription? _streamSubscription;
  Timer? _timer;

  final ValueNotifier<List<NotificationModel>> _notifications = ValueNotifier(const []);
  final Set<String> _expiredNotificationIds = {};

  void _onNewNotification(NotificationModel notification) {
    Log.d('$tag: received a new notification: $notification');
    final newNotifications = List.of(_notifications.value);
    newNotifications.insert(0, notification);

    if (newNotifications.length > maxNotificationsVisible) {
      /// keep only n, ignore extras!
      final newShortNotifications = newNotifications.sublist(0, maxNotificationsVisible);
      _notifications.value = newShortNotifications;
      return;
    }

    _notifications.value = newNotifications;
  }

  /// routine check to clean up old notification models
  /// purge older models only if all notifications in the current model is shown
  void _onRoutineCheckUp() {
    final notifications = _notifications.value;
    bool isAllShown = true;

    for (final n in notifications) {
      if (!_expiredNotificationIds.contains(n.id)) {
        isAllShown = false;
        break;
      }
    }

    if (!isAllShown) {
      Log.d('$tag: Some notifications are still visible, deferring clean up to next time!');
      return;
    }

    Log.d('$tag: All notifications are shown, purging all');
    _notifications.value = const [];
  }

  void _listenForNotifications() {
    _streamSubscription = NotificationService().notificationStream.listen(_onNewNotification);
  }

  void _startRoutineTocheckUpOnExpiredNotifications() {
    _timer = Timer.periodic(
      routineNotificationCheckDuration,
      (_) {
        _onRoutineCheckUp();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _listenForNotifications();
    _startRoutineTocheckUpOnExpiredNotifications();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FractionallySizedBox(
          heightFactor: 0.5,
          child: ValueListenableBuilder(
            valueListenable: _notifications,
            builder: (_, notifications, ___) {
              return ListView.separated(
                clipBehavior: Clip.none,
                // shrinkWrap: true,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (_, index) {
                  final notification = notifications[index];

                  return Center(
                    key: notification.key,
                    child: FadingWidget(
                      id: notification.id,
                      onFinish: (notificationId) => _expiredNotificationIds.add(notificationId),
                      child: StylizedText(
                        strokeWidth: 4.s,
                        text: Text(
                          notification.text,
                          style: TextStyles.s32.copyWith(
                            color: notification.textColor,
                            letterSpacing: 3.s,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return Gap(12.s);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
