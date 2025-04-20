import 'package:logger/logger.dart';

class AppLogger extends Logger {
  static final Logger _logger = Logger();
  static Logger get instance => _logger;
}

final logger = AppLogger.instance;
