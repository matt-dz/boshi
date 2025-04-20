/// Regex to remove the prefix from an exception message.
final exceptionPrefixRegex = RegExp(r'(\w*(Exception|Error):\s)');

/// Formats an exception message by removing the prefix.
String formatExceptionMsg(Exception exception) {
  final msg = exception.toString().trim();
  final match = exceptionPrefixRegex.matchAsPrefix(msg);
  if (match == null) {
    return msg;
  }
  return msg.substring(match.end);
}
