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

    _currentPeriod = Duration(milliseconds: 1000 ~/ _timePace);

    /// start a new timer with new period
    _timer = Timer.periodic(
      _currentPeriod,
      (_) {
        /// every tick adds one day!
        _dateTime = _dateTime.add(const Duration(days: 1));
        _notifySubscribers();
      },
    );

    /// notify time pace has changed
    _timePaceStreamController.add(_timePace);
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
    if (v < 1) throw Exception('$tag: timeAccelerationFactor invalid value $v, Time cannot be slowed down!');

    _timePace = v;
    _initializeTimer();
  }

  Duration get currentPeriod => _currentPeriod;
}
