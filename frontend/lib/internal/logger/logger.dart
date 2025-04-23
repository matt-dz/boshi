import 'package:logger/logger.dart';

/// A logger class that uses the `logger` package to log messages.
class AppLogger extends Logger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    output: null,
  );

  static Logger get instance => _logger;
}

final logger = AppLogger.instance;

/// Always logs everything, even in release mode.
// ignore: unused_element
class _AlwaysLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
