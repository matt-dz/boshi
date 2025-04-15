import 'package:frontend/utils/logger.dart';

final exceptionPrefixRegex = RegExp(r'(?:\w*Exception:\s)');

/// Formats an exception message by removing the prefix.
String formatExceptionMsg(Exception exception) {
  final msg = exception.toString();
  final match = exceptionPrefixRegex.matchAsPrefix(msg);
  if (match == null) {
    return msg;
  }
  return msg.substring(match.end);
}
