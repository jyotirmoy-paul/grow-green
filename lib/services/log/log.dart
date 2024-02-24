import 'dart:developer' as dev;

import 'package:logger/logger.dart';

class _LogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      dev.log(line, name: 'growgreen');
    }
  }
}

abstract class Log {
  static final _logger = Logger(
    printer: PrettyPrinter(
      printEmojis: false,
      noBoxingByDefault: true,
    ),
    output: _LogOutput(),
  );

  static void i(dynamic message) {
    _logger.i(message, time: DateTime.now(), stackTrace: StackTrace.empty);
  }

  static void e(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, time: DateTime.now(), error: error, stackTrace: stackTrace);
  }

  static void d(dynamic message) {
    _logger.d(message, time: DateTime.now(), stackTrace: StackTrace.empty);
  }

  static void w(dynamic message) {
    _logger.w(message, time: DateTime.now(), stackTrace: StackTrace.empty);
  }
}
