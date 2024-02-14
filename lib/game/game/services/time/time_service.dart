import 'dart:async';

import 'time_aware.dart';

/// Singleton class
class TimeService {
  static const tag = 'TimeService';
  static final TimeService _instance = TimeService._();
  TimeService._();

  factory TimeService() {
    return _instance;
  }

  final List<TimeAware> _subscribers = [];

  late DateTime _dateTime;
  Timer? _timer;
  int _timeAccelerationFactor = 1;

  void _initializeTimer() {
    /// cancel any existing timer
    _timer?.cancel();

    /// start a new timer with new period
    _timer = Timer.periodic(
      Duration(milliseconds: 1000 ~/ _timeAccelerationFactor),
      (_) {
        /// every tick adds one day!
        _dateTime = _dateTime.add(const Duration(days: 1));
        _notifySubscribers();
      },
    );
  }

  void _notifySubscribers() {
    for (var subscriber in _subscribers) {
      subscriber.onTimeChange(_dateTime);
    }
  }

  /// public methods

  /// TODO: get time from database to initialize timer with
  Future<void> initialize({DateTime? dateTime}) async {
    _dateTime = dateTime ?? DateTime(2000);

    _initializeTimer();
  }

  void register(TimeAware subscriber) {
    if (!_subscribers.contains(subscriber)) {
      _subscribers.add(subscriber);
    }
  }

  void deregister(TimeAware subscriber) {
    _subscribers.remove(subscriber);
  }

  int get timeAccelerationFactor => _timeAccelerationFactor;
  set timeAccelerationFactor(int v) {
    if (v < 0) throw Exception('$tag: timeAccelerationFactor invalid value $v, Factor cannot be negative!');
    if (v < 1) throw Exception('$tag: timeAccelerationFactor invalid value $v, Time cannot be slowed down!');

    _timeAccelerationFactor = v;
    _initializeTimer();
  }
}
