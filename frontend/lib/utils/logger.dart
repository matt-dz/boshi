import 'package:logger/logger.dart';

class AppLogger extends Logger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    filter: _AlwaysLogFilter(),
    output: null,
  );

  static Logger get instance => _logger;
}

final logger = AppLogger.instance;

/// Always logs everything, even in release mode.
class _AlwaysLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
