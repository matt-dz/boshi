

/// Exception thrown when a verification code is not found.
class CodeNotFoundException implements Exception {
  final String message;

  CodeNotFoundException([
    this.message = 'Code not found',
  ]);

  @override
  String toString() => 'CodeNotFoundException: $message';
}
