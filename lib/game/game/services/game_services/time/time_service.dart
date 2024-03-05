import 'dart:async';

import '../../datastore/game_datastore.dart';
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
  DateTime get currentDateTime => _dateTime;

  late GameDatastore _gameDatastore;

  Timer? _timer;
  int _timePace = 1;
  Duration _currentPeriod = Duration.zero;

  final _dateTimeStreamController = StreamController<DateTime>.broadcast();
  Stream<DateTime> get dateTimeStream => _dateTimeStreamController.stream;

  final _timePaceStreamController = StreamController<int>.broadcast();
  Stream<int> get timePaceStream => _timePaceStreamController.stream;

  void _initializeTimer() {
    /// cancel any existing timer
    _timer?.cancel();

    /// notify time pace has changed
    _timePaceStreamController.add(_timePace);

    if (_timePace == 0) {
      /// cancelling the timer is good enough, as now period becomes infinite!
      return;
    } else {
      _currentPeriod = Duration(milliseconds: 1000 ~/ _timePace);
    }

    /// start a new timer with new period
    _timer = Timer.periodic(
      _currentPeriod,
      (_) {
        /// every tick adds one day!
        _dateTime = _dateTime.add(const Duration(days: 1));
        _notifySubscribers();
      },
    );
  }

  void _notifySubscribers() {
    /// notify stream subscribers
    _dateTimeStreamController.add(_dateTime);

    /// notify game component subscribers
    for (final subscriber in _subscribers) {
      subscriber.onTimeChange(_dateTime);
    }

    /// let's invoke db to store time
    unawaited(_gameDatastore.saveDate(_dateTime));
  }

  /// public methods

  Future<void> initialize({required GameDatastore gameDatastore}) async {
    _gameDatastore = gameDatastore;
    _dateTime = await gameDatastore.getDate();

    _initializeTimer();
    _notifySubscribers();
  }

  void pauseTime() {
    _timer?.cancel();
  }

  void resumeTime() {
    if (_timer?.isActive == true) {
      throw Exception('$tag: cannot resume when already active!');
    }

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

  /// time acceleration & current period

  int get timePace => _timePace;
  set timePace(int v) {
    if (v < 0) throw Exception('$tag: timeAccelerationFactor invalid value $v, Factor cannot be negative!');

    _timePace = v;
    _initializeTimer();
  }
}
